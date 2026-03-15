class Secuencia < Formula
  desc "CLI tool for professional media timeline generation and export"
  homepage "https://github.com/intrusive-memory/SwiftSecuencia"
  url "https://github.com/intrusive-memory/SwiftSecuencia/releases/download/v3.1.0/secuencia-3.1.0-arm64-macos.tar.gz"
  sha256 "9cf55fed53aa2c859e32bfb20c440c57cf0a79fd4e295f2aad666a0c35e20c88"
  license "MIT"
  version "3.1.0"

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
