cask "vibe-machine" do
  version "1.4.0"
  sha256 "2d77e7e4d9605ea917ced1a9981701e565e4ca39befcab6293c50a697ca2c657"

  url "https://github.com/misty-step/vibe-machine/releases/download/v#{version}/Vibe.Machine_#{version}_aarch64.dmg"
  name "Vibe Machine"
  desc "Create cinematic audio visualizations"
  homepage "https://github.com/misty-step/vibe-machine"

  depends_on macos: :big_sur

  app "Vibe Machine.app"

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-cr", "#{appdir}/Vibe Machine.app"]
  end

  zap trash: [
    "~/Library/Application Support/io.mistystep.vibe-machine",
    "~/Library/Preferences/io.mistystep.vibe-machine.plist",
  ]
end
