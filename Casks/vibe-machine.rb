cask "vibe-machine" do
  version "1.0.0"
  sha256 "82aef66263f77d671ff096523411e76cb09f1f1fb0f5be962ddf5fb7edc280e9"

  url "https://vre6kzshqnquncrg.public.blob.vercel-storage.com/releases/vibe-machine-v#{version}.dmg"
  name "Vibe Machine"
  desc "Cinematic audio visualization for macOS"
  homepage "https://github.com/misty-step/vibe-machine"

  depends_on macos: ">= :big_sur"

  app "Vibe Machine.app"

  zap trash: [
    "~/Library/Application Support/io.mistystep.vibe-machine",
    "~/Library/Preferences/io.mistystep.vibe-machine.plist",
  ]
end
