cask "whisk" do
  version "0.2.0"
  sha256 "db666bb2421638e7538529958927d94273a256701be7530fadb8a04f26913f7b"

  url "https://github.com/alexnodeland/whisk/releases/download/v#{version}/Whisk-universal.zip"
  name "Whisk"
  desc "Menu bar utility that keeps folders clean with user-defined rules"
  homepage "https://github.com/alexnodeland/whisk"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  app "Whisk.app"

  zap trash: [
    "~/.config/whisk",
    "~/Library/Application Support/Whisk",
    "~/Library/Preferences/com.alexnodeland.whisk.plist",
  ]

  caveats <<~EOS
    Whisk is not yet signed or notarized. If macOS blocks the first launch:
      xattr -dr com.apple.quarantine "#{appdir}/Whisk.app"
  EOS
end
