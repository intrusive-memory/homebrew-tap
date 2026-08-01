class Vinetas < Formula
  desc "CLI for generating storyboard panels and comic art with FLUX.2 + PixArt-Sigma on Apple Silicon"
  homepage "https://github.com/intrusive-memory/SwiftVinetas"
  url "https://github.com/intrusive-memory/SwiftVinetas/releases/download/v0.19.0/vinetas-0.19.0-arm64-macos.tar.gz"
  sha256 "434ae5ab90a0724f731bb22ed41eb2d1b6f152d13d140a8aeb4a33dc46ccf58c"
  license "MIT"
  version "0.19.0"

  depends_on arch: :arm64
  depends_on macos: :tahoe
  depends_on "mlx"

  def install
    # Install binary and Metal bundle to libexec (keeps them colocated)
    # MLX resolves the Metal shader bundle relative to the binary's actual location
    # Using libexec ensures dladdr/Bundle.main resolve to where the bundle lives
    libexec.install "vinetas"
    libexec.install "mlx-swift_Cmlx.bundle"
    # Create wrapper script in bin that execs the real binary
    (bin/"vinetas").write_env_script libexec/"vinetas", {}
  end

  def caveats
    <<~EOS
      vinetas requires Apple Silicon (M1 or later) and macOS Tahoe (26.0+).

      On first run, vinetas will download diffusion model weights (several GB)
      from Hugging Face to ~/Library/SharedModels/. This is a one-time download
      and requires an internet connection.

      Generate a panel from a prompt:
        vinetas generate "a red car parked on a cobblestone street"
    EOS
  end

  test do
    system "#{bin}/vinetas", "--help"
  end
end
