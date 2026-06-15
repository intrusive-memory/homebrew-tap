class Vox < Formula
  desc "CLI tool for working with .vox voice identity files"
  homepage "https://github.com/intrusive-memory/vox-format"
  url "https://github.com/intrusive-memory/vox-format/releases/download/v0.4.1/vox-0.4.1-arm64-macos.tar.gz"
  sha256 "3ab2b0af2d9dfd06f24ee3184570d997ea26e8563a5eb5c90541112594f7d8d2"
  license "CC0-1.0"
  version "0.4.1"

  depends_on arch: :arm64
  depends_on macos: :ventura

  def install
    bin.install "vox"
  end

  def caveats
    <<~EOS
      vox requires Apple Silicon (M1 or later) and macOS Ventura (13.0+).

      Use vox to inspect, validate, create, and extract .vox voice identity files:
        vox inspect voice.vox
        vox validate voice.vox
        vox create --name "Narrator" --description "A warm narrator voice" --output narrator.vox
    EOS
  end

  test do
    system "#{bin}/vox", "--help"
  end
end
