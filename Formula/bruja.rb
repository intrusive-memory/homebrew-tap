class Bruja < Formula
  desc "CLI tool for on-device LLM queries on Apple Silicon"
  homepage "https://github.com/intrusive-memory/SwiftBruja"
  url "https://github.com/intrusive-memory/SwiftBruja/releases/download/v1.1.0/bruja-1.1.0-arm64-macos.tar.gz"
  sha256 "7517f769372d60fd69e377f7c0566858bebb09da02a5c68b877e23ca99a9f676"
  license "MIT"
  version "1.1.0"

  depends_on arch: :arm64
  depends_on macos: :tahoe

  def install
    # Install binary and Metal bundle to libexec (keeps them colocated)
    # MLX resolves the Metal shader bundle relative to the binary's actual location
    # Using libexec ensures dladdr/Bundle.main resolve to where the bundle lives
    libexec.install "bruja"
    libexec.install "mlx-swift_Cmlx.bundle"
    # Create wrapper script in bin that execs the real binary
    (bin/"bruja").write_env_script libexec/"bruja", {}
  end

  def caveats
    <<~EOS
      bruja requires Apple Silicon (M1 or later) and macOS Tahoe (26.0+).

      On first run, bruja will download an LLM (~4 GB) from Hugging Face
      to ~/Library/SharedModels/. This is a one-time download and requires
      an internet connection.
    EOS
  end

  test do
    system "#{bin}/bruja", "--version"
  end
end
