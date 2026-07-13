class Glosa < Formula
  desc "GLOSA performance notation compiler and stage director for screenplays"
  homepage "https://github.com/intrusive-memory/glosa-tools"
  url "https://github.com/intrusive-memory/glosa-tools/releases/download/v0.5.2/glosa-0.5.2-arm64-macos.tar.gz"
  sha256 "fe949b9d689cff3a79e0d01f31ebd5d6fb6b3dfd1c21465a5cb4d577075a540c"
  version "0.5.2"

  depends_on arch: :arm64
  depends_on macos: :tahoe

  def install
    # Install the binary and ALL its resource bundles to libexec, colocated so
    # Bundle.module resolves relative to the binary's real location. Critically
    # this includes mlx-swift_Cmlx.bundle (default.metallib) — without it the
    # LLM subcommands die with "Failed to load the default metallib" — plus the
    # GlosaDirector glossary and the swift-transformers/crypto/ZIP bundles.
    libexec.install "glosa"
    Dir["*.bundle"].each { |b| libexec.install b }
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
