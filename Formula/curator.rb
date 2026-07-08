# Homebrew formula for the `curator` CLI — the source of truth is this file;
# releases mirror it into alexnodeland/homebrew-tap under `Formula/`.
#
# Build-from-source with the in-process ONNX embedder loading Homebrew's
# `onnxruntime` at RUNTIME (the `embed-onnx-dynamic` feature): the build does
# NOT download ONNX Runtime, and the installed binary uses the shared system
# library instead of a bundled copy — so `brew install` needs no build-time
# network for the ML stack, and `curator` ships the real bge-small-en-v1.5
# semantic embedder (not the offline `hash` fallback).
class Curator < Formula
  desc "Local-first knowledge plane: markdown vault + index + MCP for agents"
  homepage "https://github.com/alexnodeland/curator"
  url "https://github.com/alexnodeland/curator/archive/refs/tags/v0.1.0.tar.gz"
  # Filled from the v0.1.0 source tarball at publish time — see
  # dist/homebrew/README.md. `brew fetch --build-from-source` prints it.
  sha256 "7157c21b4558b57a0d75b1fd980985b5a864b83a2bad25fc636013da9d979512"
  license "MIT"
  head "https://github.com/alexnodeland/curator.git", branch: "main"

  depends_on "rust" => :build
  depends_on "onnxruntime"

  def install
    system "cargo", "install",
           "--no-default-features",
           "--features", "embed-onnx-dynamic",
           *std_cargo_args(path: "crates/curator-cli")

    # Point ort's runtime loader at Homebrew's onnxruntime so the binary
    # works without the user setting ORT_DYLIB_PATH. Move the real binary to
    # libexec and expose a bin wrapper that sets it.
    dylib = OS.mac? ? "libonnxruntime.dylib" : "libonnxruntime.so"
    libexec.install bin/"curator"
    (bin/"curator").write_env_script libexec/"curator",
      ORT_DYLIB_PATH: "#{Formula["onnxruntime"].opt_lib}/#{dylib}"
  end

  def caveats
    <<~EOS
      curator ships the in-process ONNX embedder (embedder = "builtin"),
      backed by Homebrew's onnxruntime. The first command that embeds
      (e.g. `curator init` / `curator ingest` on the default config) fetches
      the pinned ~130 MB bge-small-en-v1.5 model into your vault's .kp/models
      (one-time). For a fully offline setup, set `embedder = "hash"` in
      curator.toml (deterministic, no ML, no download).

      Get started:
        curator init ~/vault
        curator --help
    EOS
  end

  test do
    assert_match "curator #{version}", shell_output("#{bin}/curator --version")
    # The wrapper points ONNX Runtime at Homebrew's library.
    assert_match "onnxruntime", (bin/"curator").read
  end
end
