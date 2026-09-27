---
type: reference
---

# Homebrew Tap for Intrusive Memory

Homebrew formulas for [Intrusive Memory](https://github.com/intrusive-memory)'s
command-line tools, and a cask for the **ContainerBodega** Mac app.

> **Using an AI agent?** Point it at [AGENTS.md](AGENTS.md#installing-from-this-tap). It has
> non-interactive install and verification steps.

## Requirements

- **macOS 26 (Tahoe)** or later
- **Apple silicon** (M1 or newer). Nothing here runs on Intel Macs.
- [Homebrew](https://brew.sh)

## Quick start

Install any package by its **full name**, `intrusive-memory/tap/<name>`. That
works straight away with no other setup. Use the full name for `upgrade` and
`uninstall` too:

```bash
# The ContainerBodega app
brew install --cask intrusive-memory/tap/containerbodega

# A command-line tool
brew install intrusive-memory/tap/proyecto
```

### Why the full name? (Tap Trust)

Since Homebrew 6, Homebrew won't load packages from a third-party tap like this
one until you trust them. Installing by full name trusts just that one package.
If you'd rather use short names (`brew install proyecto`), trust the whole tap
once:

```bash
brew tap intrusive-memory/tap
brew trust intrusive-memory/tap
brew install proyecto bruja secuencia
brew install --cask containerbodega
```

Without that trust, a short name fails with *"Refusing to load … from untrusted
tap intrusive-memory/tap"*. The error message tells you which `brew trust`
command to run.

## ContainerBodega (cask)

[ContainerBodega](https://container-bodega.app) is a native Mac app for Apple's
[`container`](https://github.com/apple/container) CLI: containers, images,
volumes, networks and multi-repo compose projects in one window. It's Developer
ID signed and notarized, so it opens normally, with no *Open Anyway* step.

**1. Install Apple's `container` CLI.** The app drives it but doesn't bundle
it. Either of these works; the app looks in both `/usr/local/bin` and
`/opt/homebrew/bin`:

```bash
brew install container                     # from Homebrew
# or: the signed .pkg from https://github.com/apple/container/releases
```

Then start its service once. The first start offers to download a Linux
kernel; answer yes.

```bash
container system start
```

**2. Install the app:**

```bash
brew install --cask intrusive-memory/tap/containerbodega
open -a ContainerBodega
```

| Task | Command |
|------|---------|
| Update | `brew upgrade --cask intrusive-memory/tap/containerbodega` |
| Uninstall | `brew uninstall --cask intrusive-memory/tap/containerbodega` |
| Uninstall and remove settings and data | `brew uninstall --cask --zap intrusive-memory/tap/containerbodega` |

`--zap` deletes the app's data in `~/Library`, including its list of Bodegas.
The `BODEGA.md` files in your repositories stay, so you can reopen them.
`container` itself, its images and your containers aren't touched either.

You can also download the DMG directly from
[ContainerBodega-releases](https://github.com/intrusive-memory/ContainerBodega-releases/releases/latest).

## Command-line tools (formulas)

| Formula | Description |
|---------|-------------|
| `acervo` | Download, verify and mirror AI models to the intrusive-memory CDN |
| `ambienta` | Generate atmospheric / foley background beds from a text prompt or scene preset |
| `bruja` | On-device LLM queries on Apple silicon |
| `diga` | Drop-in replacement for macOS `say`, using Qwen3-TTS |
| `echada` | Screenplay character extraction and voice casting |
| `glosa` | GLOSA performance notation compiler and stage director for screenplays |
| `proyecto` | Analyze directories and generate PROJECT.md files with a local LLM |
| `reparto` | Validate and import CAST.md cast documents |
| `secuencia` | Media timeline generation and export |
| `vinetas` | Storyboard panels and comic art with FLUX.2 + PixArt-Sigma |
| `vox` | Work with .vox voice identity files |

`hablare` is disabled: SwiftHablare became a library and no longer ships a
binary. Use `diga` for text-to-speech on the command line.

```bash
brew install intrusive-memory/tap/<formula>
<formula> --version        # check it installed
```

## Updating everything

```bash
brew update
brew upgrade               # formulas and casks
```

If you haven't trusted the tap and a package from it doesn't upgrade, upgrade
it by full name: `brew upgrade intrusive-memory/tap/<name>` (add `--cask` for
ContainerBodega).

The tap updates itself automatically: new releases of each source repo reach
it within about six hours at most.

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| `Refusing to load … from untrusted tap` | Use the full name (`intrusive-memory/tap/<name>`), or run `brew trust intrusive-memory/tap` |
| Install refuses with a macOS version or architecture requirement | Needs macOS 26+ on Apple silicon. There is no Intel build |
| ContainerBodega opens to its onboarding screen | It can't find `container`. Install it (step 1 above) or set its path in the app's Settings |
| `brew upgrade` doesn't see a new release yet | `brew update` first. The tap can lag a release by up to six hours |

## Source repositories

- [SwiftAcervo](https://github.com/intrusive-memory/SwiftAcervo): `acervo`
- [SwiftAmbiente](https://github.com/intrusive-memory/SwiftAmbiente): `ambienta`
- [SwiftBruja](https://github.com/intrusive-memory/SwiftBruja): `bruja`
- [SwiftVoxAlta](https://github.com/intrusive-memory/SwiftVoxAlta): `diga`
- [SwiftEchada](https://github.com/intrusive-memory/SwiftEchada): `echada`
- [glosa-tools](https://github.com/intrusive-memory/glosa-tools): `glosa`
- [SwiftHablare](https://github.com/intrusive-memory/SwiftHablare): `hablare` (disabled)
- [SwiftProyecto](https://github.com/intrusive-memory/SwiftProyecto): `proyecto`
- [SwiftReparto](https://github.com/intrusive-memory/SwiftReparto): `reparto`
- [SwiftSecuencia](https://github.com/intrusive-memory/SwiftSecuencia): `secuencia`
- [SwiftVinetas](https://github.com/intrusive-memory/SwiftVinetas): `vinetas`
- [vox-format](https://github.com/intrusive-memory/vox-format): `vox`
- [ContainerBodega-releases](https://github.com/intrusive-memory/ContainerBodega-releases): downloads for the `containerbodega` cask (the app's source is private)

## License

MIT License. See [LICENSE](LICENSE).
