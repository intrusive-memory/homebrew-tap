cask "containerbodega" do
  version "0.1.0"
  sha256 "PLACEHOLDER"

  # The source repo is private; its release workflow publishes the signed,
  # notarized DMG to this public releases-only repo instead.
  url "https://github.com/intrusive-memory/ContainerBodega-releases/releases/download/v#{version}/ContainerBodega.dmg",
      verified: "github.com/intrusive-memory/ContainerBodega-releases/"
  name "ContainerBodega"
  desc "Desktop app for Apple's container CLI"
  homepage "https://container-bodega.app/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: ">= :tahoe"

  app "ContainerBodega.app"

  zap trash: [
    "~/Library/Application Support/ContainerBodega",
    "~/Library/Caches/io.intrusive-memory.ContainerBodega",
    "~/Library/Containers/io.intrusive-memory.ContainerBodega.Widget",
    "~/Library/HTTPStorages/io.intrusive-memory.ContainerBodega",
    "~/Library/Preferences/io.intrusive-memory.ContainerBodega.plist",
    "~/Library/Saved Application State/io.intrusive-memory.ContainerBodega.savedState",
  ]

  caveats <<~EOS
    ContainerBodega drives Apple's `container` CLI but does not install it.
    Get it from:
      https://github.com/apple/container/releases
  EOS
end
