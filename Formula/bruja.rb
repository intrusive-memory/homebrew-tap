class Bruja < Formula
  desc "CLI tool for on-device LLM queries on Apple Silicon"
  homepage "https://github.com/intrusive-memory/SwiftBruja"
  url "https://github.com/intrusive-memory/SwiftBruja/releases/download/v1.0.1/bruja-1.0.1-arm64-macos.tar.gz"
  sha256 "2a8c7b2ba033e3ae33bc95cf13fb7965e4dbb285d12e7ab4ecbec1dfe9be3e4e"
  license "MIT"
  version "1.0.1"

  depends_on arch: :arm64
  depends_on macos: :sequoia

  def install
    bin.install "bruja"
  end

  test do
    system "#{bin}/bruja", "--version"
  end
end
