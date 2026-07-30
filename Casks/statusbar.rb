cask "statusbar" do
  version "0.4.0"
  sha256 "cb54749484df37a5543f466ee2798f137f7ac9db66eeb3681bd7aa039e33275b"

  url "https://github.com/alexnodeland/StatusBar/releases/download/v#{version}/StatusBar-universal.zip"
  name "StatusBar"
  desc "Menu bar app to monitor status pages"
  homepage "https://github.com/alexnodeland/StatusBar"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  app "StatusBar.app"
  binary "#{appdir}/StatusBar.app/Contents/MacOS/statusbar-cli", target: "statusbar"

  zap trash: [
    "~/Library/Application Support/StatusBar",
    "~/Library/Preferences/com.statusbar.app.plist",
  ]
end
