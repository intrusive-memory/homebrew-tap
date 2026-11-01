class Reparto < Formula
  desc "CLI for validating and importing CAST.md cast documents"
  homepage "https://github.com/intrusive-memory/SwiftReparto"
  url "https://github.com/intrusive-memory/SwiftReparto/releases/download/v0.2.1/reparto-0.2.1-arm64-macos.tar.gz"
  sha256 "241e3e9cac360879db6519240b6b718397ef66c801f429719ab52eb953f9edec"
  license "MIT"
  version "0.2.1"

  depends_on arch: :arm64
  depends_on macos: :tahoe

  def install
    bin.install "reparto"
  end

  def caveats
    <<~EOS
      reparto requires Apple Silicon (M1 or later) and macOS Tahoe (26.0+).

      reparto ships two subcommands:
        - `reparto validate <path>` — parse a CAST.md and report errors
        - `reparto import <PROJECT.md>` — import a project's cast: block
          into a versioned CAST.md beside the source file

      Run `reparto --help` for usage information.
    EOS
  end

  test do
    system "#{bin}/reparto", "--version"
  end
end
