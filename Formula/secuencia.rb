class Secuencia < Formula
  desc "CLI tool for professional media timeline generation and export"
  homepage "https://github.com/intrusive-memory/SwiftSecuencia"
  url "https://github.com/intrusive-memory/SwiftSecuencia/releases/download/v3.4.0/secuencia-3.4.0-arm64-macos.tar.gz"
  sha256 "a4b2eceb36a17f2b72d361efcaf969ff7ca866c0f7dfe30b9d4566f71a2e6039"
  license "MIT"
  version "3.4.0"

  depends_on arch: :arm64
  depends_on macos: :tahoe

  def install
    bin.install "secuencia"
  end

  def caveats
    <<~EOS
      secuencia requires Apple Silicon (M1 or later) and macOS Tahoe (26.0+).

      secuencia provides three core functions:
        - Generate type-safe Timeline and TimelineClip SwiftData models
        - Export to Final Cut Pro FCPXML bundles (macOS only)
        - Export to M4A audio with optional timing data (macOS + iOS)

      Run `secuencia --help` for usage information.
    EOS
  end

  test do
    system "#{bin}/secuencia", "--version"
  end
end
