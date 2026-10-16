cask "vibe-machine" do
  version "1.6.0"
  sha256 "6366d333605833a31a5ee2798589f22e9c34dca8d40bbec6dee4482dbfde4fc2"

  url "https://github.com/misty-step/vibe-machine/releases/download/v#{version}/Vibe.Machine_#{version}_aarch64.dmg"
  name "Vibe Machine"
  desc "Create cinematic audio visualizations"
  homepage "https://github.com/misty-step/vibe-machine"

  depends_on macos: :monterey

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
