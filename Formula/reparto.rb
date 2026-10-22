class Reparto < Formula
  desc "CLI for validating and importing CAST.md cast documents"
  homepage "https://github.com/intrusive-memory/SwiftReparto"
  url "https://github.com/intrusive-memory/SwiftReparto/releases/download/v0.2.0/reparto-0.2.0-arm64-macos.tar.gz"
  sha256 "423d6d8c1587a1ba8f66bda3fd56a0c3913210bf5a29c501ce83398392aa3cc0"
  license "MIT"
  version "0.2.0"

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
