class Hablare < Formula
  desc "CLI tool for on-device text-to-speech on Apple Silicon via Qwen3-TTS"
  homepage "https://github.com/intrusive-memory/SwiftHablare"
  url "https://github.com/intrusive-memory/SwiftHablare/releases/download/v5.5.2/hablare-5.5.2-arm64-macos.tar.gz"
  sha256 "061e8c6d8af70fa9a27d96bed34d2464819579b4f569681700f2611382230591"
  license "MIT"
  version "5.5.2"

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

  test do
    system "#{bin}/hablare", "--version"
  end
end
