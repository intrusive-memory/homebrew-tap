class Hablare < Formula
  desc "CLI tool for on-device text-to-speech on Apple Silicon via Qwen3-TTS"
  homepage "https://github.com/intrusive-memory/SwiftHablare"
  url "https://github.com/intrusive-memory/SwiftHablare/releases/download/v5.6.0/hablare-5.6.0-arm64-macos.tar.gz"
  sha256 "895435aa334351cb17cc59a911993b9eadf39ecd4454ffb0317ca26042bcd5b9"
  license "MIT"
  version "5.6.0"

  depends_on arch: :arm64
  depends_on macos: :tahoe
  depends_on "mlx"

  def install
    # Install binary and Metal bundle to libexec (keeps them colocated)
    # MLX resolves the Metal shader bundle relative to the binary's actual location
    # Using libexec ensures dladdr/Bundle.main resolve to where the bundle lives
    libexec.install "hablare"
    libexec.install "mlx-swift_Cmlx.bundle"
    # Create wrapper script in bin that execs the real binary
    (bin/"hablare").write_env_script libexec/"hablare", {}
  end

  def caveats
    <<~EOS
      hablare requires Apple Silicon (M1 or later) and macOS Tahoe (26.0+).

      On first run, hablare will download ML models from Hugging Face:
        - LLM for text analysis (~4 GB) to ~/Library/SharedModels/
        - TTS model for speech (~3.5 GB) to ~/Library/SharedModels/

      This is a one-time download and requires an internet connection.
    EOS
  end

  test do
    system "#{bin}/hablare", "--version"
  end
end
