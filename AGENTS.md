---
type: reference
---

# Agent Instructions — homebrew-tap

This is a Homebrew tap for [Intrusive Memory](https://github.com/intrusive-memory):
formulas that install pre-built arm64 CLI binaries, and a cask that installs the
ContainerBodega Mac app. Everything targets macOS 26 (Tahoe)+ on Apple silicon.

This file has two halves. **Installing from this tap** is for an agent setting
up a user's machine. Everything from **Repository Structure** on is for an agent
maintaining this repo.

## Installing from this tap

For an agent installing on a user's Mac. Every command below is
non-interactive unless marked otherwise. For the human-oriented version, see
[README.md](README.md).

### Rules

1. **Always use the fully qualified name**, `intrusive-memory/tap/<name>`, for
   *every* brew command, including `uninstall`, `upgrade` and `info`. Since
   Homebrew 6 (Tap Trust), a short name from an untrusted tap fails with
   `Refusing to load … from untrusted tap intrusive-memory/tap`, even for
   uninstalling something already installed. A qualified name works with no trust
   step.
2. **Don't run `brew trust intrusive-memory/tap` on your own initiative.**
   Trusting a whole tap lets all of its Ruby run on the user's machine. That's
   the user's decision; ask first, or stick to qualified names.
3. **Check the platform first.** Nothing here installs on Intel or before
   macOS 26, and Homebrew's refusal message is less clear than a check:

   ```bash
   [ "$(uname -m)" = arm64 ] || echo "unsupported: needs Apple silicon"
   [ "$(sw_vers -productVersion | cut -d. -f1)" -ge 26 ] || echo "unsupported: needs macOS 26+"
   ```

4. **Never pass `--no-quarantine`** and never strip quarantine from these
   apps. The cask is Developer ID signed and notarized, so it opens normally;
   if Gatekeeper objects, something is wrong. Report it rather than working
   around it.

### A CLI tool (formula)

```bash
brew install intrusive-memory/tap/<formula>
<formula> --version                                   # verify
```

The formulas are `acervo`, `ambienta`, `bruja`, `diga`, `echada`, `glosa`,
`proyecto`, `reparto`, `secuencia`, `vinetas` and `vox`. `hablare` is **disabled**
(its repo went library-only), so install `diga` for command-line TTS instead.

### ContainerBodega (cask)

ContainerBodega is a GUI for Apple's `container` CLI and needs that CLI to do
anything. Install the CLI first. The app finds it in `/usr/local/bin` (Apple's
.pkg) or `/opt/homebrew/bin` (Homebrew).

```bash
# 1. Apple's container CLI, unless `command -v container` already finds one
command -v container || brew install container

# 2. Start its service. Without the flag, the first start PROMPTS to download a
#    Linux kernel and blocks an unattended run.
container system start --enable-kernel-install

# 3. The app
brew install --cask intrusive-memory/tap/containerbodega
```

Verify:

```bash
brew list --cask --versions intrusive-memory/tap/containerbodega           # -> containerbodega <version>
spctl -a -vv /Applications/ContainerBodega.app 2>&1 | grep -q 'source=Notarized Developer ID' \
  && echo "notarized OK"
container system status                               # the service is running
```

Update with `brew upgrade --cask intrusive-memory/tap/containerbodega`, and
remove with `brew uninstall --cask intrusive-memory/tap/containerbodega`. **Don't add `--zap`
unless the user asked for it**: it deletes the app's data in `~/Library`,
including its list of Bodegas. It leaves `BODEGA.md` files in the user's
repositories alone.

Launching (`open -a ContainerBodega`) is optional; don't open a GUI app the user
didn't ask for. If it opens to an onboarding screen instead of the sidebar, it
can't find `container`: go back to step 1.

### When something fails

| Error | Cause and fix |
|-------|---------------|
| `Refusing to load … from untrusted tap` | A short name was used. Retry with `intrusive-memory/tap/<name>` |
| macOS version / architecture requirement | Unsupported machine (see rule 3). Stop and tell the user |
| `SHA256 mismatch` | The release changed after the tap recorded it. Run `brew update` and retry once; if it persists, report it and don't bypass it |
| A new release isn't visible | `brew update`. The tap can lag a release by up to six hours |

## Repository Structure

```
homebrew-tap/
├── Formula/          # One .rb file per formula
├── Casks/            # One .rb file per cask (macOS apps)
├── .github/
│   └── workflows/
│       ├── update-formula.yml      # Push: a source repo dispatches on release
│       └── reconcile-formulas.yml  # Pull: every 6h, formulas AND casks
├── scripts/
│   └── reconcile-formulas.sh       # The reconciler (formulas and casks)
├── AGENTS.md         # This file (CLAUDE.md and GEMINI.md are symlinks to it)
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
| `glosa` | [glosa-tools](https://github.com/intrusive-memory/glosa-tools) | 0.5.0 |
| `hablare` | [SwiftHablare](https://github.com/intrusive-memory/SwiftHablare) | 5.6.0 |
| `proyecto` | [SwiftProyecto](https://github.com/intrusive-memory/SwiftProyecto) | 4.1.0 |
| `reparto` | [SwiftReparto](https://github.com/intrusive-memory/SwiftReparto) | 0.1.0 |
| `secuencia` | [SwiftSecuencia](https://github.com/intrusive-memory/SwiftSecuencia) | 3.3.0 |
| `vinetas` | [SwiftVinetas](https://github.com/intrusive-memory/SwiftVinetas) | 0.15.7 |
| `vox` | [vox-format](https://github.com/intrusive-memory/vox-format) | 0.4.1 |

## Casks

| Cask | Source Repo | Downloads From |
|------|-------------|----------------|
| `containerbodega` | [ContainerBodega](https://github.com/intrusive-memory/ContainerBodega) (private) | [ContainerBodega-releases](https://github.com/intrusive-memory/ContainerBodega-releases) (public) |

A cask installs a signed, notarized `.app` from a DMG. Because
ContainerBodega's source repo is private, its release workflow publishes the
DMG to the public `ContainerBodega-releases` repo, and the cask's `url` points
there.

Casks have **no push-based update path**. `reconcile-formulas.yml` picks them
up: it reads the release repo from the cask's `url` (which must be a GitHub
release download containing `#{version}`), and rewrites only `version` and
`sha256`. A `sha256 "PLACEHOLDER"` counts as drift even when the version
already matches, so a new cask can be committed before its first release.
ContainerBodega's release workflow starts the reconciler right after
publishing, so the cask normally updates within minutes rather than at the
next six-hourly run.

Install: `brew install --cask intrusive-memory/tap/containerbodega`.

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
