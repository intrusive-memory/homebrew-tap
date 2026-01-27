class Bruja < Formula
  desc "CLI tool for on-device LLM queries on Apple Silicon"
  homepage "https://github.com/intrusive-memory/SwiftBruja"
  url "https://github.com/intrusive-memory/SwiftBruja/releases/download/v1.0.3/bruja-1.0.3-arm64-macos.tar.gz"
  sha256 "78430a379352ad0a67333a58a0a1ede2d50936a278d57d331308ee8d698ddfba"
  license "MIT"
  version "1.0.3"

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
