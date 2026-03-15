# Agent Instructions — homebrew-tap

This is a Homebrew tap for [Intrusive Memory](https://github.com/intrusive-memory) CLI tools. It distributes pre-built arm64 binaries for macOS 26 (Tahoe)+.

## Repository Structure

```
homebrew-tap/
├── Formula/          # One .rb file per formula
├── .github/
│   └── workflows/
│       └── update-formula.yml  # Auto-updates formulas on release
├── AGENTS.md         # This file
└── README.md
```

## Formulas

| Formula | Source Repo | Current Version |
|---------|-------------|-----------------|
| `bruja` | [SwiftBruja](https://github.com/intrusive-memory/SwiftBruja) | 1.1.0 |
| `diga` | [SwiftVoxAlta](https://github.com/intrusive-memory/SwiftVoxAlta) | 0.8.0 |
| `echada` | [SwiftEchada](https://github.com/intrusive-memory/SwiftEchada) | 0.10.1 |
| `hablare` | [SwiftHablare](https://github.com/intrusive-memory/SwiftHablare) | 5.6.0 |
| `proyecto` | [SwiftProyecto](https://github.com/intrusive-memory/SwiftProyecto) | 3.2.0 |
| `secuencia` | [SwiftSecuencia](https://github.com/intrusive-memory/SwiftSecuencia) | 3.0.1 |
| `vox` | [vox-format](https://github.com/intrusive-memory/vox-format) | 0.1.0 |

## Formula Anatomy

Each formula in `Formula/<name>.rb` follows this pattern:

```ruby
class Name < Formula
  desc "..."
  homepage "https://github.com/intrusive-memory/<SourceRepo>"
  url "https://github.com/intrusive-memory/<SourceRepo>/releases/download/v<VERSION>/<name>-<VERSION>-arm64-macos.tar.gz"
  sha256 "<sha256 of tarball>"
  license "MIT"
  version "<VERSION>"

  depends_on arch: :arm64
  depends_on macos: :tahoe   # macOS 26.0+

  def install
    bin.install "<name>"
  end

  test do
    system "#{bin}/<name>", "--version"
  end
end
```

## Automated Formula Updates

The `update-formula.yml` workflow handles formula updates. It is triggered two ways:

### 1. Automatic (via `repository_dispatch` from source repos)

Source repos fire a `formula-update` event after publishing a release:

```json
{
  "event-type": "formula-update",
  "client-payload": {
    "formula": "proyecto",
    "version": "v3.2.0",
    "repo": "intrusive-memory/SwiftProyecto"
  }
}
```

### 2. Manual (via `workflow_dispatch`)

Trigger from the GitHub Actions UI or CLI:

```bash
gh workflow run update-formula.yml \
  -f formula=proyecto \
  -f version=v3.2.0 \
  -f repo=intrusive-memory/SwiftProyecto
```

The workflow will:
1. Download the tarball from the release
2. Compute the SHA256
3. Update `url`, `sha256`, and `version` in the formula file
4. Commit and push directly to `main`

## Adding a New Formula

1. Create `Formula/<name>.rb` following the pattern above (use `PLACEHOLDER` for sha256 until first release).
2. Add the formula name to the `options` list in `.github/workflows/update-formula.yml`.
3. Update the tables in `README.md` and `AGENTS.md`.
4. Configure the source repo to dispatch a `formula-update` event on release, using the `HOMEBREW_TAP_TOKEN` secret.

## Secrets

| Secret | Where | Purpose |
|--------|-------|---------|
| `HOMEBREW_TAP_TOKEN` | Source repos | PAT with `repo` scope to trigger this repo's workflow |
| `DEPLOY_TOKEN` | This repo | PAT used by the workflow to push formula updates |

## Branch

Default branch is `main`. The update workflow checks out and pushes to `main`.
