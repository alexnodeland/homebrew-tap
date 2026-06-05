cask "no-doze" do
  version :latest
  sha256 :no_check

  url "https://github.com/alexnodeland/no-doze/releases/latest/download/NoDoze-universal.zip"
  name "NoDoze"
  desc "Keep your Mac awake from the menu bar (a free caffeinate wrapper)"
  homepage "https://github.com/alexnodeland/no-doze"

  app "NoDoze.app"

  zap trash: [
    "~/Library/Application Support/NoDoze",
    "~/Library/Preferences/com.alexnodeland.nodoze.plist",
  ]
end
