class Bruja < Formula
  desc "CLI tool for on-device LLM queries on Apple Silicon"
  homepage "https://github.com/intrusive-memory/SwiftBruja"
  url "https://github.com/intrusive-memory/SwiftBruja/releases/download/v1.0.4/bruja-1.0.4-arm64-macos.tar.gz"
  sha256 "f90318aecc039565831252f8fd321c012e621692bde1e8e85641a97d884f43f6"
  license "MIT"
  version "1.0.4"

  depends_on arch: :arm64
  depends_on macos: :sequoia

  def install
    bin.install "bruja"
    # Install Metal shader bundle next to binary (required for MLX GPU acceleration)
    bin.install "mlx-swift_Cmlx.bundle"
  end

  test do
    system "#{bin}/bruja", "--version"
  end
end
