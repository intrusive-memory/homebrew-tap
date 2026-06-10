class Glosa < Formula
  desc "GLOSA performance notation compiler and stage director for screenplays"
  homepage "https://github.com/intrusive-memory/glosa-av"
  url "https://github.com/intrusive-memory/glosa-av/releases/download/v0.4.0/glosa-0.4.0-arm64-macos.tar.gz"
  sha256 "dd9ad1c052e402d2619ea6321f93ccd1e4f43a728817d5123aa76bb899f53d91"
  version "0.4.0"

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
