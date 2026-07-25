class Proyecto < Formula
  desc "CLI tool for analyzing directories and generating PROJECT.md files using local LLM"
  homepage "https://github.com/intrusive-memory/SwiftProyecto"
  url "https://github.com/intrusive-memory/SwiftProyecto/releases/download/v4.6.2/proyecto-4.6.2-arm64-macos.tar.gz"
  sha256 "0ae1d949da555f30fe82c6c01ded802b92604e6792f59c50624ed39311f776a7"
  license "MIT"
  version "4.6.2"

  depends_on arch: :arm64
  depends_on macos: :tahoe

  def install
    # Install the binary plus any SwiftPM resource bundles shipped alongside it
    # into libexec, so Bundle.module resolves them relative to the real binary.
    # The bundle set varies by release (e.g. ZIPFoundation); glob rather than
    # hard-code any single name so a missing/renamed bundle never breaks install.
    libexec.install "proyecto"
    Dir["*.bundle"].each { |bundle| libexec.install bundle }
    # Wrapper in bin execs the real binary in libexec, next to its bundles.
    (bin/"proyecto").write_env_script libexec/"proyecto", {}
  end

  def caveats
    <<~EOS
      proyecto requires Apple Silicon (M1 or later) and macOS Tahoe (26.0+).

      On first run, proyecto will download an LLM (~4 GB) from Hugging Face
      to ~/Library/SharedModels/. This is a one-time download and requires
      an internet connection.
    EOS
  end

  test do
    system "#{bin}/proyecto", "--version"
  end
end
