class Diga < Formula
  desc "Drop-in replacement for Apple's say command using Qwen3-TTS for AI-generated speech"
  homepage "https://github.com/intrusive-memory/SwiftVoxAlta"
  url "https://github.com/intrusive-memory/SwiftVoxAlta/releases/download/v0.10.2/diga-0.10.2-arm64-macos.tar.gz"
  sha256 "58f63f1a6f019be997570995bff6425421289079a81e248ad67498d78b56a773"
  license "MIT"
  version "0.10.2"

  depends_on arch: :arm64
  depends_on macos: :tahoe
  depends_on "mlx"

  def install
    # Install binary and Metal bundle to libexec (keeps them colocated)
    # MLX resolves the Metal shader bundle relative to the binary's actual location
    # Using libexec ensures dladdr/Bundle.main resolve to where the bundle lives
    libexec.install "diga"
    libexec.install "mlx-swift_Cmlx.bundle"
    # Create wrapper script in bin that execs the real binary
    (bin/"diga").write_env_script libexec/"diga", {}
  end

  def caveats
    <<~EOS
      diga requires Apple Silicon (M1 or later) and macOS Tahoe (26.0+).

      On first run, diga will download the Qwen3-TTS model (~3.5 GB)
      from Hugging Face to ~/Library/SharedModels/. This is a one-time
      download and requires an internet connection.

      Use diga as a drop-in replacement for the 'say' command:
        diga "Hello, world!"
    EOS
  end

  test do
    system "#{bin}/diga", "--help"
  end
end
