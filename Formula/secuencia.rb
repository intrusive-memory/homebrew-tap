class Secuencia < Formula
  desc "CLI tool for professional media timeline generation and export"
  homepage "https://github.com/intrusive-memory/SwiftSecuencia"
  url "https://github.com/intrusive-memory/SwiftSecuencia/releases/download/v3.5.0/secuencia-3.5.0-arm64-macos.tar.gz"
  sha256 "e97936f64f674af96c48ca86b213c5a00eb1fdb8d0065acea575e5154e5d636f"
  license "MIT"
  version "3.5.0"

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
