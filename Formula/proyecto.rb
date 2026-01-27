class Proyecto < Formula
  desc "CLI tool for analyzing directories and generating PROJECT.md files using local LLM"
  homepage "https://github.com/intrusive-memory/SwiftProyecto"
  url "https://github.com/intrusive-memory/SwiftProyecto/releases/download/v0.0.0/proyecto-0.0.0-arm64-macos.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"
  license "MIT"
  version "0.0.0"

  depends_on arch: :arm64
  depends_on macos: :sequoia

  def install
    bin.install "proyecto"
    # Install Metal shader bundle next to binary (required for MLX GPU acceleration)
    bin.install "mlx-swift_Cmlx.bundle"
  end

  test do
    system "#{bin}/proyecto", "--version"
  end
end
