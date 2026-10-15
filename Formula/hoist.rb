# A Homebrew formula for Hoist's release binaries, as a template: the
# release workflow fills in the version and the archives' checksums with
# packaging/homebrew/fill.sh and attaches the result to the release as
# hoist.rb. Homebrew installs it from a tap, a repository named
# homebrew-tap under the same account, as Formula/hoist.rb
# (docs/releasing.md).
class Hoist < Formula
  desc "Learn an LLM agent's next reads from its tool calls and serve them over MCP"
  homepage "https://hoist.alexnodeland.com/"
  version "0.2.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/alexnodeland/hoist/releases/download/v#{version}/hoist-aarch64-apple-darwin.tar.gz"
      sha256 "6546257f6f4f9c14b301140e4870331a48233862a6f58d9ab15701550871d9fc"
    end
    on_intel do
      url "https://github.com/alexnodeland/hoist/releases/download/v#{version}/hoist-x86_64-apple-darwin.tar.gz"
      sha256 "b6a6e2ab52f8c7984a286d9f6cb1a0ae27043f435a268a3b03fd23e47ef0881e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/alexnodeland/hoist/releases/download/v#{version}/hoist-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a3a3277dcb8716a02b6eb0b36a3745142bb48dcb028c9d8f555ec8ca89ba454f"
    end
    on_intel do
      url "https://github.com/alexnodeland/hoist/releases/download/v#{version}/hoist-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0a79762427267c3ff1df66a013b580fc1833d5acf5424f5187d97cf8d47a63cf"
    end
  end

  def install
    bin.install "hoist", "hoist-mcp", "hoist-procedure", "hoist-mcp-demo", "hoist-console"
    generate_completions_from_executable(bin/"hoist", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hoist --version")
    assert_match version.to_s, shell_output("#{bin}/hoist-mcp --version")
  end
end
