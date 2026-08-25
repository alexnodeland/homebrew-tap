cask "whisk" do
  version "0.4.0"
  sha256 "e7a473e6a6c61a00c52d3b048ba239b87a1b3d7f7f07391f5f25b375767c765f"

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
