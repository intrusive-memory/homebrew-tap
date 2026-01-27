class Hablare < Formula
  desc "CLI tool for on-device text-to-speech on Apple Silicon via Qwen3-TTS"
  homepage "https://github.com/intrusive-memory/SwiftHablare"
  url "https://github.com/intrusive-memory/SwiftHablare/releases/download/v5.5.0/hablare-5.5.0-arm64-macos.tar.gz"
  sha256 "3d3e6f1962c132ec5665a563e441b8e95e244894788971d90390ef458cc0d1d4"
  license "MIT"
  version "5.5.0"

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
