class Proyecto < Formula
  desc "CLI tool for analyzing directories and generating PROJECT.md files using local LLM"
  homepage "https://github.com/intrusive-memory/SwiftProyecto"
  url "https://github.com/intrusive-memory/SwiftProyecto/releases/download/v4.4.0/proyecto-4.4.0-arm64-macos.tar.gz"
  sha256 "6fdc6ebf0e2c9f538b4cd95f70a9b0d7a168fcdbcb0538f77b118c4a3b777113"
  license "MIT"
  version "4.4.0"

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
