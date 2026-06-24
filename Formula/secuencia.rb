class Secuencia < Formula
  desc "CLI tool for professional media timeline generation and export"
  homepage "https://github.com/intrusive-memory/SwiftSecuencia"
  url "https://github.com/intrusive-memory/SwiftSecuencia/releases/download/v3.3.0/secuencia-3.3.0-arm64-macos.tar.gz"
  sha256 "1d961ee6ff07cc88d784beca7f5bd017b2552419e57f1cb395eed4eca0cdefbf"
  license "MIT"
  version "3.3.0"

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
