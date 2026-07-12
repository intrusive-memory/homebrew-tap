---
type: reference
---

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

> Versions below are a point-in-time snapshot; the source of truth is each
> `Formula/<name>.rb` (`version` / `url` / `sha256`). The `update-formula`
> workflow keeps them current — don't hand-edit versions here to "fix" drift,
> re-read the formula files instead.

| Formula | Source Repo | Current Version |
|---------|-------------|-----------------|
| `acervo` | [SwiftAcervo](https://github.com/intrusive-memory/SwiftAcervo) | 0.20.0 |
| `ambienta` | [SwiftAmbiente](https://github.com/intrusive-memory/SwiftAmbiente) | 0.1.0 |
| `bruja` | [SwiftBruja](https://github.com/intrusive-memory/SwiftBruja) | 1.8.1 |
| `diga` | [SwiftVoxAlta](https://github.com/intrusive-memory/SwiftVoxAlta) | 0.14.0 |
| `echada` | [SwiftEchada](https://github.com/intrusive-memory/SwiftEchada) | 0.14.1 |
| `glosa` | [glosa-av](https://github.com/intrusive-memory/glosa-av) | 0.4.0 |
| `hablare` | [SwiftHablare](https://github.com/intrusive-memory/SwiftHablare) | 5.6.0 |
| `proyecto` | [SwiftProyecto](https://github.com/intrusive-memory/SwiftProyecto) | 4.1.0 |
| `secuencia` | [SwiftSecuencia](https://github.com/intrusive-memory/SwiftSecuencia) | 3.3.0 |
| `vinetas` | [SwiftVinetas](https://github.com/intrusive-memory/SwiftVinetas) | 0.15.7 |
| `vox` | [vox-format](https://github.com/intrusive-memory/vox-format) | 0.4.1 |

## Homebrew Context & Tap Trust

Reference docs agents should scan before reasoning about install/CI behavior:

- Homebrew Formula Cookbook: <https://docs.brew.sh/Formula-Cookbook>
- Formula Ruby API: <https://rubydoc.brew.sh/Formula.html>
- **Tap Trust** (Homebrew 6.0.0+): <https://docs.brew.sh/Tap-Trust>
- Security & Supply Chain: <https://docs.brew.sh/Homebrew-Security-and-Supply-Chain>

**Tap Trust — what it means for this tap.** As of Homebrew 6.0.0 (June 2026),
third-party (non-official) taps must be explicitly trusted by the *user* before
their Ruby is evaluated. This is a **consumer-side** gate — there is nothing to
add to this repo (no signing, attestations, or metadata) to make it "trusted."
Build-provenance attestations apply only to `homebrew/core` and `homebrew/cask`,
never third-party taps. Install flows:

```bash
# Trust the whole tap, then install by short name:
brew tap intrusive-memory/tap
brew trust intrusive-memory/tap
brew install <formula>

# Or install one formula without trusting the whole tap (narrower, preferred):
brew install intrusive-memory/tap/<formula>
```

The `update-formula.yml` workflow does **not** run `brew test-bot` / `brew doctor`,
so it is unaffected by the trust gate. If a `brew test-bot` job is ever added,
`HOMEBREW_NO_REQUIRE_TAP_TRUST=1` is a temporary bridge (Homebrew plans to remove
it) — prefer `brew trust` instead.

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
