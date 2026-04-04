class Glosa < Formula
  desc "GLOSA performance notation compiler and stage director for screenplays"
  homepage "https://github.com/intrusive-memory/glosa-av"
  url "https://github.com/intrusive-memory/glosa-av/releases/download/v0.2.0/glosa-0.2.0-arm64-macos.tar.gz"
  sha256 "b6176b81297526b5d226569e8280152fac21e2a39b5cf2a3407c61b2af1eaeb5"
  version "0.2.0"

  depends_on arch: :arm64
  depends_on macos: :tahoe

  def install
    # Install binary and resource bundle to libexec (keeps them colocated)
    # Bundle.module resolves resources relative to the binary's actual location
    libexec.install "glosa"
    libexec.install "glosa-av_GlosaDirector.bundle" if File.exist?("glosa-av_GlosaDirector.bundle")
    # Create wrapper script in bin that execs the real binary
    (bin/"glosa").write_env_script libexec/"glosa", {}
  end

  def caveats
    <<~EOS
      glosa requires Apple Silicon (M1 or later) and macOS Tahoe (26.0+).

      GLOSA (Annotation Vocabulary) is a performance notation system for
      screenplays. It compiles GLOSA annotations into per-line instruct
      strings for TTS pipelines.

      Run `glosa --help` for usage information.
    EOS
  end

  test do
    system "#{bin}/glosa", "--help"
  end
end
