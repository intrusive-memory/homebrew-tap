class Bruja < Formula
  desc "CLI tool for on-device LLM queries on Apple Silicon"
  homepage "https://github.com/intrusive-memory/SwiftBruja"
  url "https://github.com/intrusive-memory/SwiftBruja/releases/download/v1.0.7/bruja-1.0.7-arm64-macos.tar.gz"
  sha256 "b18bdc30519853594e5e02a2685184429c2af5aa1bb710b755b089c0e02818c4"
  license "MIT"
  version "1.0.7"

  depends_on arch: :arm64
  depends_on macos: :sequoia

  def install
    # Install binary and Metal bundle to libexec (keeps them colocated)
    # MLX resolves the Metal shader bundle relative to the binary's actual location
    # Using libexec ensures dladdr/Bundle.main resolve to where the bundle lives
    libexec.install "bruja"
    libexec.install "mlx-swift_Cmlx.bundle"
    # Create wrapper script in bin that execs the real binary
    (bin/"bruja").write_env_script libexec/"bruja", {}
  end

  test do
    system "#{bin}/bruja", "--version"
  end
end
