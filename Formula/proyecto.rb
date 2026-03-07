class Proyecto < Formula
  desc "CLI tool for analyzing directories and generating PROJECT.md files using local LLM"
  homepage "https://github.com/intrusive-memory/SwiftProyecto"
  url "https://github.com/intrusive-memory/SwiftProyecto/releases/download/v3.1.1/proyecto-3.1.1-arm64-macos.tar.gz"
  sha256 "9103213501f9cb06c841c4e1f1699b99d8fc0464f00c93bde85299a94b790c0d"
  license "MIT"
  version "3.1.1"

  depends_on arch: :arm64
  depends_on macos: :tahoe
  depends_on "mlx"

  def install
    # Install binary and Metal bundle to libexec (keeps them colocated)
    # MLX resolves the Metal shader bundle relative to the binary's actual location
    # Using libexec ensures dladdr/Bundle.main resolve to where the bundle lives
    libexec.install "proyecto"
    libexec.install "mlx-swift_Cmlx.bundle"
    # Create wrapper script in bin that execs the real binary
    (bin/"proyecto").write_env_script libexec/"proyecto", {}
  end

  def caveats
    <<~EOS
      proyecto requires Apple Silicon (M1 or later) and macOS Tahoe (26.0+).

      On first run, proyecto will download an LLM (~4 GB) from Hugging Face
      to ~/Library/SharedModels/. This is a one-time download and requires
      an internet connection.
    EOS
  end

  test do
    system "#{bin}/proyecto", "--version"
  end
end
