class Hablare < Formula
  desc "CLI tool for on-device text-to-speech on Apple Silicon via Qwen3-TTS"
  homepage "https://github.com/intrusive-memory/SwiftHablare"
  url "https://github.com/intrusive-memory/SwiftHablare/releases/download/v5.5.1/hablare-5.5.1-arm64-macos.tar.gz"
  sha256 "cf1655eae08bdf50d161ea1903927bfeb6dd0a02cb2691f47c56b5a823310063"
  license "MIT"
  version "5.5.1"

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
