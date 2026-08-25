cask "whisk" do
  version "0.4.3"
  sha256 "3d1da16cfec864e6e68231b6a4e60a69e5d0f0ccf97953ce7e90c224a79ec2be"

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
