class Ambiente < Formula
  desc "Generate atmospheric / foley background beds from a text prompt or scene preset"
  homepage "https://github.com/intrusive-memory/SwiftAmbiente"
  url "https://github.com/intrusive-memory/SwiftAmbiente/releases/download/v0.3.0/ambiente-0.3.0-arm64-macos.tar.gz"
  sha256 "145949226eed1042be2d78ebab453e6f2397fee913de5c1ce1948b16035bae5f"
  license "MIT"
  version "0.3.0"

  depends_on arch: :arm64
  depends_on macos: :tahoe

  def install
    # Install binary and Metal bundle to libexec (keeps them colocated).
    # MLX resolves the Metal shader bundle relative to the binary's real location,
    # so the bundle must sit next to the executable, not in bin/.
    libexec.install "ambiente"
    libexec.install "mlx-swift_Cmlx.bundle"
    (bin/"ambiente").write_env_script libexec/"ambiente", {}
  end

  def caveats
    <<~EOS
      ambiente requires Apple Silicon (M1 or later) and macOS Tahoe (26.0+).

      When the Stable Audio 3 Small SFX model is installed, ambiente renders with
      the neural backend; otherwise it uses a procedural (filtered-noise)
      generator that needs no download. The model (~3.5 GB) comes from the
      intrusive-memory CDN via SwiftAcervo; override with ACERVO_CDN_BASE_URL.
      Neural output is subject to the Stability AI Community License and the
      Gemma Terms of Use -- see the SwiftAmbiente README.

      Generate a background bed from a built-in scene:
        ambiente --scene rain -d 30 -o rain.wav

      ...or from a free-form prompt:
        ambiente "distant city traffic, muffled hum" -d 15 -o city.wav

      Run `ambiente --list-scenes` for the built-in presets.
    EOS
  end

  test do
    assert_match "ambiente", shell_output("#{bin}/ambiente --version")
  end
end
