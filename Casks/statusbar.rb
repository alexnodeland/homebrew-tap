cask "statusbar" do
  version :latest
  sha256 :no_check

  url "https://github.com/alexnodeland/StatusBar/releases/latest/download/StatusBar-universal.zip"
  name "StatusBar"
  desc "Monitor status pages from the macOS menu bar"
  homepage "https://github.com/alexnodeland/StatusBar"

  app "StatusBar.app"

  zap trash: [
    "~/Library/Application Support/StatusBar",
    "~/Library/Preferences/com.statusbar.app.plist",
  ]
end
