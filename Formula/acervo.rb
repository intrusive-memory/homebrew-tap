class Acervo < Formula
  desc "CLI tool for downloading, verifying, and mirroring AI models to the intrusive-memory CDN"
  homepage "https://github.com/intrusive-memory/SwiftAcervo"
  url "https://github.com/intrusive-memory/SwiftAcervo/releases/download/v0.18.2/acervo-0.18.2-arm64-macos.tar.gz"
  sha256 "1fce7014febe6e14b0b3925053efc6efdce3b115020f63f7c43083d92c6da4d2"
  license "MIT"
  version "0.18.2"

  depends_on arch: :arm64
  depends_on macos: :tahoe
  depends_on "awscli"
  depends_on "hf"

  def install
    bin.install "acervo"
  end

  def caveats
    <<~EOS
      acervo requires Apple Silicon (M1 or later) and macOS Tahoe (26.0+).

      The following dependencies are automatically installed:
        - AWS CLI v2 for R2 CDN uploads
        - HuggingFace CLI for model downloads

      Required environment variables for upload/ship commands:
        R2_ACCESS_KEY_ID      Cloudflare R2 access key
        R2_SECRET_ACCESS_KEY  Cloudflare R2 secret key
        HF_TOKEN              HuggingFace API token
    EOS
  end

  test do
    system "#{bin}/acervo", "--version"
  end
end
