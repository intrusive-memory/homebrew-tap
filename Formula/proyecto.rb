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
    # Install binary and Metal bundle to libexec (keeps them colocated)
    # MLX resolves the Metal shader bundle relative to the binary's actual location
    # Using libexec ensures dladdr/Bundle.main resolve to where the bundle lives
    libexec.install "proyecto"
    libexec.install "mlx-swift_Cmlx.bundle"
    # Create wrapper script in bin that execs the real binary
    (bin/"proyecto").write_env_script libexec/"proyecto", {}
  end

  test do
    system "#{bin}/proyecto", "--version"
  end
end
