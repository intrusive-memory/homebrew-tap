class Echada < Formula
  desc "CLI tool for AI-powered cast extraction and voice matching for screenplays"
  homepage "https://github.com/intrusive-memory/SwiftEchada"
  url "https://github.com/intrusive-memory/SwiftEchada/releases/download/v0.13.2/echada-0.13.2-arm64-macos.tar.gz"
  sha256 "baf0bac4d84e2022688f2674b36d26d2ff70bb39f2c109bceac41b387ba7265c"
  license "MIT"
  version "0.13.2"

  depends_on arch: :arm64
  depends_on macos: :tahoe
  depends_on "mlx"

  def install
    # Install binary and Metal bundle to libexec (keeps them colocated)
    # MLX resolves the Metal shader bundle relative to the binary's actual location
    # Using libexec ensures dladdr/Bundle.main resolve to where the bundle lives
    libexec.install "echada"
    libexec.install "mlx-swift_Cmlx.bundle"
    # Create wrapper script in bin that execs the real binary
    (bin/"echada").write_env_script libexec/"echada", {}
  end

  def caveats
    <<~EOS
      echada requires Apple Silicon (M1 or later) and macOS Tahoe (26.0+).

      On first run, echada will download ML models from Hugging Face:
        - LLM for character extraction (~4 GB) to ~/Library/SharedModels/
        - TTS model for voice generation (~3.5 GB) to ~/Library/SharedModels/

      This is a one-time download and requires an internet connection.
    EOS
  end

  test do
    system "#{bin}/echada", "--version"
  end
end
