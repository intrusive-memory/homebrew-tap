class Bruja < Formula
  desc "CLI tool for on-device LLM queries on Apple Silicon"
  homepage "https://github.com/intrusive-memory/SwiftBruja"
  url "https://github.com/intrusive-memory/SwiftBruja/releases/download/v1.0.10/bruja-1.0.10-arm64-macos.tar.gz"
  sha256 "9afbe65234e3897a45ae0c1b00511c3a290b5a2e0de1ec46b6fd33437b42e603"
  license "MIT"
  version "1.0.10"

  depends_on arch: :arm64
  depends_on macos: :tahoe
  depends_on "mlx"

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
