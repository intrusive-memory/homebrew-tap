class Glosa < Formula
  desc "GLOSA performance notation compiler and stage director for screenplays"
  homepage "https://github.com/intrusive-memory/glosa-av"
  url "https://github.com/intrusive-memory/glosa-av/releases/download/v0.2.1/glosa-0.2.1-arm64-macos.tar.gz"
  sha256 "60627b833e06bd0c15565179c19fb4f2488e4e024e69fa6eaea5fa23237670aa"
  version "0.2.1"

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
