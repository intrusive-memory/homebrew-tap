# Homebrew Tap for Intrusive Memory Tools

This tap provides Homebrew formulas for CLI tools from [Intrusive Memory](https://github.com/intrusive-memory).

## Available Formulas

| Formula | Description |
|---------|-------------|
| `proyecto` | CLI tool for analyzing directories and generating PROJECT.md files using local LLM inference |
| `bruja` | CLI tool for on-device LLM queries on Apple Silicon |

## Requirements

- **macOS 26** (Sequoia) or later
- **Apple Silicon** (M1/M2/M3/M4)

## Installation

```bash
# Add the tap
brew tap intrusive-memory/tap

# Install tools
brew install proyecto
brew install bruja
```

## Updating

```bash
brew update
brew upgrade proyecto bruja
```

## Source Repositories

- [SwiftProyecto](https://github.com/intrusive-memory/SwiftProyecto) - Source for `proyecto`
- [SwiftBruja](https://github.com/intrusive-memory/SwiftBruja) - Source for `bruja`

## License

MIT License - See [LICENSE](LICENSE) for details.
