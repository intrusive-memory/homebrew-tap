---
type: reference
---

# Homebrew Tap for Intrusive Memory Tools

This tap provides Homebrew formulas for CLI tools from [Intrusive Memory](https://github.com/intrusive-memory).

## Available Formulas

| Formula | Description |
|---------|-------------|
| `acervo` | CLI tool for downloading, verifying, and mirroring AI models to the intrusive-memory CDN |
| `ambienta` | Generate atmospheric / foley background beds from a text prompt or scene preset |
| `bruja` | CLI tool for on-device LLM queries on Apple Silicon |
| `diga` | Drop-in replacement for Apple's `say` command using Qwen3-TTS |
| `echada` | CLI tool for screenplay character extraction and voice casting |
| `glosa` | GLOSA performance notation compiler and stage director for screenplays |
| `hablare` | CLI tool for voice provider abstraction and TTS |
| `proyecto` | CLI tool for analyzing directories and generating PROJECT.md files using local LLM inference |
| `secuencia` | CLI tool for professional media timeline generation and export |
| `vinetas` | CLI for generating storyboard panels and comic art with FLUX.2 + PixArt-Sigma |
| `vox` | CLI tool for working with .vox voice identity files |

## Requirements

- **macOS 26** (Tahoe) or later
- **Apple Silicon** (M1/M2/M3/M4)

## Installation

> **Homebrew 6.0+ (Tap Trust):** Since Homebrew 6.0.0, third-party taps must be
> explicitly trusted before their formulae can run. This tap is unofficial, so
> you'll grant trust once (or per-formula) before installing.

**Option A — trust the tap, then install by short name:**

```bash
brew tap intrusive-memory/tap
brew trust intrusive-memory/tap
brew install proyecto bruja secuencia vox
```

**Option B — install a single formula without trusting the whole tap (narrower, recommended by Homebrew):**

```bash
brew install intrusive-memory/tap/proyecto
```

On older Homebrew (pre-6.0), the `brew trust` step is unnecessary — `brew tap`
followed by `brew install <formula>` works as before.

## Updating

```bash
brew update
brew upgrade
```

## Source Repositories

- [SwiftAcervo](https://github.com/intrusive-memory/SwiftAcervo) - Source for `acervo`
- [SwiftAmbiente](https://github.com/intrusive-memory/SwiftAmbiente) - Source for `ambienta`
- [SwiftBruja](https://github.com/intrusive-memory/SwiftBruja) - Source for `bruja`
- [SwiftVoxAlta](https://github.com/intrusive-memory/SwiftVoxAlta) - Source for `diga`
- [SwiftEchada](https://github.com/intrusive-memory/SwiftEchada) - Source for `echada`
- [glosa-tools](https://github.com/intrusive-memory/glosa-tools) - Source for `glosa`
- [SwiftHablare](https://github.com/intrusive-memory/SwiftHablare) - Source for `hablare`
- [SwiftProyecto](https://github.com/intrusive-memory/SwiftProyecto) - Source for `proyecto`
- [SwiftSecuencia](https://github.com/intrusive-memory/SwiftSecuencia) - Source for `secuencia`
- [SwiftVinetas](https://github.com/intrusive-memory/SwiftVinetas) - Source for `vinetas`
- [vox-format](https://github.com/intrusive-memory/vox-format) - Source for `vox`

## License

MIT License - See [LICENSE](LICENSE) for details.
