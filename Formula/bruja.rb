class Bruja < Formula
  desc "CLI tool for on-device LLM queries on Apple Silicon"
  homepage "https://github.com/intrusive-memory/SwiftBruja"
  url "https://github.com/intrusive-memory/SwiftBruja/releases/download/v0.0.0/bruja-0.0.0-arm64-macos.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"
  license "MIT"
  version "0.0.0"

  depends_on arch: :arm64
  depends_on macos: :sequoia

  def install
    bin.install "bruja"
  end

  test do
    system "#{bin}/bruja", "--version"
  end
end
