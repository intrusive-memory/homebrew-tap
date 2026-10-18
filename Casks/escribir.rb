cask "escribir" do
  version "1.2.0"
  sha256 "PLACEHOLDER"

  # The source repo is private; its release workflow publishes the signed,
  # notarized DMG to this public releases-only repo instead.
  url "https://github.com/intrusive-memory/Escribir-releases/releases/download/v#{version}/Escribir.dmg"
  name "Escribir"
  desc "Text editor for Markdown, Fountain and plain text"
  homepage "https://escribir.app/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :tahoe

  app "Escribir.app"

  zap trash: [
    "~/Library/Containers/io.intrusive-memory.Escribir",
    "~/Library/Preferences/io.intrusive-memory.Escribir.plist",
    "~/Library/Saved Application State/io.intrusive-memory.Escribir.savedState",
  ]

  caveats <<~EOS
    Escribir is also on the Mac App Store, with the same bundle id. If a copy
    from the App Store is installed at /Applications/Escribir.app, remove it
    first: Homebrew will refuse to overwrite it.
  EOS
end
