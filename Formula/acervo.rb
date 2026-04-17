class Acervo < Formula
  desc "CLI tool for downloading, verifying, and mirroring AI models to the intrusive-memory CDN"
  homepage "https://github.com/intrusive-memory/SwiftAcervo"
  url "https://github.com/intrusive-memory/SwiftAcervo/releases/download/v0.7.0/acervo-0.7.0-arm64-macos.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"
  license "MIT"
  version "0.7.0"

  depends_on arch: :arm64
  depends_on macos: :tahoe

  def install
    bin.install "acervo"
  end

  def caveats
    <<~EOS
      acervo requires Apple Silicon (M1 or later) and macOS Tahoe (26.0+).

      The following tools are required at runtime:
        aws   AWS CLI v2 for R2 CDN uploads:  brew install awscli
        hf    HuggingFace CLI for downloads:  brew install huggingface-hub

      Set these environment variables before running upload or ship commands:
        R2_ACCESS_KEY_ID
        R2_SECRET_ACCESS_KEY
        HF_TOKEN
    EOS
  end

  test do
    system "#{bin}/acervo", "--version"
  end
end
