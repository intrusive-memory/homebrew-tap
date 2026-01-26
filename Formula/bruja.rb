class Bruja < Formula
  desc "CLI tool for on-device LLM queries on Apple Silicon"
  homepage "https://github.com/intrusive-memory/SwiftBruja"
  url "https://github.com/intrusive-memory/SwiftBruja/releases/download/v1.0.0/bruja-1.0.0-arm64-macos.tar.gz"
  sha256 "b145d2826117d8144109f13126bf89d2453e620feb727176cb42f4731fc4ad43"
  license "MIT"
  version "1.0.0"

  depends_on arch: :arm64
  depends_on macos: :sequoia

  def install
    bin.install "bruja"
  end

  test do
    system "#{bin}/bruja", "--version"
  end
end
