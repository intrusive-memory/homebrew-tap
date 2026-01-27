class Proyecto < Formula
  desc "CLI tool for analyzing directories and generating PROJECT.md files using local LLM"
  homepage "https://github.com/intrusive-memory/SwiftProyecto"
  url "https://github.com/intrusive-memory/SwiftProyecto/releases/download/v2.1.0/proyecto-2.1.0-arm64-macos.tar.gz"
  sha256 "ec7293891d1c80290cc670d0c8ee229543926faa06d41e1a2caa3431c6dd0e70"
  license "MIT"
  version "2.1.0"

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
