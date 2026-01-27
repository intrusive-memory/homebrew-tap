class Hablare < Formula
  desc "CLI tool for on-device text-to-speech on Apple Silicon via Qwen3-TTS"
  homepage "https://github.com/intrusive-memory/SwiftHablare"
  url "https://github.com/intrusive-memory/SwiftHablare/releases/download/v2.1.2/hablare-2.1.2-arm64-macos.tar.gz"
  sha256 "94e90803adb49a30252455c5fcf635023a928dda5dd273a0f1e229db49cae57e"
  license "MIT"
  version "2.1.2"

  depends_on arch: :arm64
  depends_on macos: :sequoia

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
