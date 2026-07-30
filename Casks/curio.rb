# Homebrew cask for Curio — the unsigned macOS distribution channel.
#
# The app is neither signed nor notarized (Apple Developer enrollment is
# skipped by decision), so this ships the unsigned .app from the GitHub
# release and documents the Gatekeeper right-click-open path in `caveats`.
# Source of truth: alexnodeland/curio-rss → dist/homebrew/Casks/curio.rb.
cask "curio" do
  # Pinned, not `:latest`. The app is unsigned, so this checksum is the only
  # integrity check between GitHub's CDN and the machine installing it — and
  # `brew upgrade` skips `version :latest` casks unless you pass `--greedy`,
  # which is not what the README promised. `.github/workflows/bump.yml` keeps
  # both lines current; do not edit them by hand.
  # One universal DMG (arm64 + x64), which avoids the scarce Intel runner.
  version "0.4.0"
  sha256 "808490683549d5151a47d7a7f2427208eb539167f12afe4eec3d33b32ab526e3"

  url "https://github.com/alexnodeland/curio-rss/releases/download/v#{version}/Curio-universal.dmg"
  name "Curio"
  desc "Local-first RSS reader"
  homepage "https://github.com/alexnodeland/curio-rss"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  app "Curio.app"

  # Full uninstall footprint (matches the app's platform paths:
  # io.github.alexnodeland.curio data dir + the curio cache dir).
  zap trash: [
    "~/Library/Application Support/io.github.alexnodeland.curio",
    "~/Library/Caches/curio",
    "~/Library/Preferences/io.github.alexnodeland.curio.plist",
  ]

  caveats <<~EOS
    Curio is NOT signed or notarized (Apple Developer enrollment is skipped),
    so macOS Gatekeeper will refuse to open it on first launch. To run it:

      1. In Finder, open /Applications and right-click (Control-click) Curio.app
      2. Choose "Open", then "Open" again in the warning dialog

    or clear the quarantine flag from a terminal:

      xattr -dr com.apple.quarantine "/Applications/Curio.app"

    You only need to do this once per install.
  EOS
end
