cask "whisk" do
  version "0.3.0"
  sha256 "16c3fecc127ebc47f39cae05375735e02bcad2bdfcaf704f7a28a6f840f226e7"

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
