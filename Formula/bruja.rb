class Bruja < Formula
  desc "CLI tool for on-device LLM queries on Apple Silicon"
  homepage "https://github.com/intrusive-memory/SwiftBruja"
  url "https://github.com/intrusive-memory/SwiftBruja/releases/download/v1.0.2/bruja-1.0.2-arm64-macos.tar.gz"
  sha256 "a2bde9452f26f5ed0e48a064adc433256e20eb0a1346a429fb6b2d0f51abd26c"
  license "MIT"
  version "1.0.2"

  depends_on arch: :arm64
  depends_on macos: :sequoia

  def install
    bin.install "bruja"
  end

  test do
    system "#{bin}/bruja", "--version"
  end
end
