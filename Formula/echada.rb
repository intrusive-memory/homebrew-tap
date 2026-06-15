class Echada < Formula
  desc "CLI tool for AI-powered cast extraction and voice matching for screenplays"
  homepage "https://github.com/intrusive-memory/SwiftEchada"
  url "https://github.com/intrusive-memory/SwiftEchada/releases/download/v0.13.1/echada-0.13.1-arm64-macos.tar.gz"
  sha256 "f3de048c974cc5db08de3bbf375e7c73690dcb794ad1b550313ea85cf5d783c7"
  license "MIT"
  version "0.13.1"

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
