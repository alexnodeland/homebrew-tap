cask "no-doze" do
  version "0.3.1"
  sha256 "8b4bb39dd287ba73230a888db2a10835a77ea26f08b480ce60b64ca2419e987d"

  url "https://github.com/alexnodeland/no-doze/releases/download/v#{version}/NoDoze-universal.zip"
  name "NoDoze"
  desc "Menu bar app to prevent sleep (a free caffeinate wrapper)"
  homepage "https://github.com/alexnodeland/no-doze"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  app "NoDoze.app"

  zap trash: [
    "~/Library/Application Support/NoDoze",
    "~/Library/Preferences/com.alexnodeland.nodoze.plist",
  ]
end
