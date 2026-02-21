# Homebrew Tap for Intrusive Memory Tools

This tap provides Homebrew formulas for CLI tools from [Intrusive Memory](https://github.com/intrusive-memory).

## Available Formulas

| Formula | Description |
|---------|-------------|
| `proyecto` | CLI tool for analyzing directories and generating PROJECT.md files using local LLM inference |
| `bruja` | CLI tool for on-device LLM queries on Apple Silicon |
| `echada` | CLI tool for screenplay character extraction and voice casting |
| `hablare` | CLI tool for voice provider abstraction and TTS |
| `diga` | Drop-in replacement for Apple's say command using Qwen3-TTS |
| `vox` | CLI tool for working with .vox voice identity files |

## Requirements

- **macOS 26** (Tahoe) or later
- **Apple Silicon** (M1/M2/M3/M4)

## Installation

```bash
# Add the tap
brew tap intrusive-memory/tap

# Install tools
brew install proyecto
brew install bruja
brew install vox
```

## Updating

```bash
brew update
brew upgrade
```

## Source Repositories

- [SwiftProyecto](https://github.com/intrusive-memory/SwiftProyecto) - Source for `proyecto`
- [SwiftBruja](https://github.com/intrusive-memory/SwiftBruja) - Source for `bruja`
- [SwiftEchada](https://github.com/intrusive-memory/SwiftEchada) - Source for `echada`
- [SwiftHablare](https://github.com/intrusive-memory/SwiftHablare) - Source for `hablare`
- [SwiftVoxAlta](https://github.com/intrusive-memory/SwiftVoxAlta) - Source for `diga`
- [vox-format](https://github.com/intrusive-memory/vox-format) - Source for `vox`

## License

MIT License - See [LICENSE](LICENSE) for details.
