class Echada < Formula
  desc "On-device voice generation for screenplay casts"
  homepage "https://github.com/intrusive-memory/SwiftEchada"
  url "https://github.com/intrusive-memory/SwiftEchada/releases/download/v3.1.1/echada-3.1.1-arm64-macos.tar.gz"
  sha256 "f38dc59b23a8b8a81c7ab4509451871fb13b14fe638f651407c701cb2cdaefc4"
  license "MIT"
  version "3.1.1"

  depends_on arch: :arm64
  depends_on macos: :golden_gate
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
      echada requires Apple Silicon (M1 or later) and macOS 27 or later.
      On macOS 26, install echada 2.0.x instead.

      Voice prompts use the on-device Apple Intelligence model by default
      (`--llm`); cloud models are set up with `echada auth login`.

      On first use, echada downloads the Qwen3-TTS voice models (~3.5 GB)
      to the shared model cache. This is a one-time download.
    EOS
  end

  test do
    system "#{bin}/echada", "--version"
  end
end
