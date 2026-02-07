class Echada < Formula
  desc "CLI tool for AI-powered cast extraction and voice matching for screenplays"
  homepage "https://github.com/intrusive-memory/SwiftEchada"
  url "https://github.com/intrusive-memory/SwiftEchada/releases/download/v0.8.0/echada-0.8.0-arm64-macos.tar.gz"
  sha256 "9869ce8ca77d5d0e78c32ac4e10a5a25fd71a92df4b89e70c871a5ccbdcb5cb8"
  license "MIT"
  version "0.8.0"

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

  test do
    system "#{bin}/echada", "--version"
  end
end
