# Homebrew Tap Requirements

## Overview

This document outlines the requirements for creating and maintaining a public Homebrew tap that distributes pre-built binaries for:

- **proyecto** - CLI tool for analyzing directories and generating PROJECT.md files using local LLM inference
- **bruja** - CLI tool for on-device LLM queries on Apple Silicon

**Tap Repository**: `intrusive-memory/homebrew-tap`
**Installation**: `brew tap intrusive-memory/tap && brew install proyecto bruja`

---

## Source Projects

| Project | Repository | Binary Name | Current Version |
|---------|------------|-------------|-----------------|
| SwiftProyecto | `intrusive-memory/SwiftProyecto` | `proyecto` | TBD |
| SwiftBruja | `intrusive-memory/SwiftBruja` | `bruja` | TBD |

### Platform Requirements

Both binaries share identical platform requirements:

- **Architecture**: Apple Silicon only (arm64)
- **OS**: macOS 26.0 or later
- **Build System**: xcodebuild (required for Metal shader compilation)
- **Swift**: 6.2+

---

## Distribution Strategy: Pre-built Binaries

We will distribute **pre-built binaries** rather than source builds because:

1. **Metal Shaders**: Both projects require `xcodebuild` to compile Metal shaders; `swift build` alone produces non-functional binaries
2. **Build Time**: Source builds would require users to have Xcode installed and take significant time
3. **Reliability**: Pre-built binaries eliminate build-time variability
4. **User Experience**: Faster, simpler installation

### Binary Packaging

Each release will include:
- A tarball: `{binary}-{version}-arm64-macos.tar.gz`
- Contains the compiled binary
- SHA256 checksum for verification

---

## Tap Repository Structure

```
homebrew-tap/
├── Formula/
│   ├── proyecto.rb      # Formula for proyecto CLI
│   └── bruja.rb         # Formula for bruja CLI
├── .github/
│   └── workflows/
│       └── update-formula.yml  # Webhook handler for formula updates
├── REQUIREMENTS.md      # This document
├── README.md            # User-facing documentation
└── LICENSE              # MIT License
```

---

## Formula Specifications

### proyecto.rb

```ruby
class Proyecto < Formula
  desc "CLI tool for analyzing directories and generating PROJECT.md files using local LLM"
  homepage "https://github.com/intrusive-memory/SwiftProyecto"
  url "https://github.com/intrusive-memory/SwiftProyecto/releases/download/v{VERSION}/proyecto-{VERSION}-arm64-macos.tar.gz"
  sha256 "{SHA256}"
  license "MIT"
  version "{VERSION}"

  depends_on arch: :arm64
  depends_on macos: :sequoia  # macOS 26 minimum

  def install
    bin.install "proyecto"
  end

  test do
    system "#{bin}/proyecto", "--version"
  end
end
```

### bruja.rb

```ruby
class Bruja < Formula
  desc "CLI tool for on-device LLM queries on Apple Silicon"
  homepage "https://github.com/intrusive-memory/SwiftBruja"
  url "https://github.com/intrusive-memory/SwiftBruja/releases/download/v{VERSION}/bruja-{VERSION}-arm64-macos.tar.gz"
  sha256 "{SHA256}"
  license "MIT"
  version "{VERSION}"

  depends_on arch: :arm64
  depends_on macos: :sequoia  # macOS 26 minimum

  def install
    bin.install "bruja"
  end

  test do
    system "#{bin}/bruja", "--version"
  end
end
```

---

## Release Workflow Requirements

### Phase 1: Source Repository Release Workflows

Each source repository (SwiftProyecto, SwiftBruja) needs a release workflow that:

1. **Triggers on**: GitHub release published
2. **Builds**: Release binary using `make release`
3. **Packages**: Creates tarball with the binary
4. **Uploads**: Attaches tarball to the GitHub release
5. **Notifies**: Triggers formula update in homebrew-tap

#### Workflow: `.github/workflows/release.yml` (for both repos)

```yaml
name: Release

on:
  release:
    types: [published]

jobs:
  build-and-upload:
    name: Build Release Binary
    runs-on: macos-26

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Build Release
        run: make release

      - name: Package Binary
        run: |
          BINARY_NAME="${{ github.event.repository.name == 'SwiftProyecto' && 'proyecto' || 'bruja' }}"
          VERSION="${{ github.event.release.tag_name }}"
          VERSION_NUM="${VERSION#v}"  # Remove 'v' prefix if present

          cd bin
          tar -czvf "${BINARY_NAME}-${VERSION_NUM}-arm64-macos.tar.gz" "${BINARY_NAME}"
          shasum -a 256 "${BINARY_NAME}-${VERSION_NUM}-arm64-macos.tar.gz" > "${BINARY_NAME}-${VERSION_NUM}-arm64-macos.tar.gz.sha256"

      - name: Upload to Release
        uses: softprops/action-gh-release@v2
        with:
          files: |
            bin/*.tar.gz
            bin/*.sha256

      - name: Trigger Homebrew Tap Update
        uses: peter-evans/repository-dispatch@v3
        with:
          token: ${{ secrets.HOMEBREW_TAP_TOKEN }}
          repository: intrusive-memory/homebrew-tap
          event-type: formula-update
          client-payload: |
            {
              "formula": "${{ github.event.repository.name == 'SwiftProyecto' && 'proyecto' || 'bruja' }}",
              "version": "${{ github.event.release.tag_name }}",
              "repo": "${{ github.repository }}"
            }
```

### Phase 2: Homebrew Tap Formula Update Workflow

The tap repository needs a workflow that:

1. **Triggers on**: `repository_dispatch` event from source repos
2. **Downloads**: The release tarball to compute SHA256
3. **Updates**: The formula file with new version and SHA256
4. **Commits**: Changes directly to main branch

#### Workflow: `.github/workflows/update-formula.yml`

```yaml
name: Update Formula

on:
  repository_dispatch:
    types: [formula-update]
  workflow_dispatch:
    inputs:
      formula:
        description: 'Formula name (proyecto or bruja)'
        required: true
        type: choice
        options:
          - proyecto
          - bruja
      version:
        description: 'Version (e.g., v1.0.0)'
        required: true
      repo:
        description: 'Source repository (e.g., intrusive-memory/SwiftProyecto)'
        required: true

jobs:
  update:
    name: Update Formula
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Set Variables
        id: vars
        run: |
          if [ "${{ github.event_name }}" == "repository_dispatch" ]; then
            echo "formula=${{ github.event.client_payload.formula }}" >> $GITHUB_OUTPUT
            echo "version=${{ github.event.client_payload.version }}" >> $GITHUB_OUTPUT
            echo "repo=${{ github.event.client_payload.repo }}" >> $GITHUB_OUTPUT
          else
            echo "formula=${{ inputs.formula }}" >> $GITHUB_OUTPUT
            echo "version=${{ inputs.version }}" >> $GITHUB_OUTPUT
            echo "repo=${{ inputs.repo }}" >> $GITHUB_OUTPUT
          fi

      - name: Download and Compute SHA256
        id: sha
        run: |
          FORMULA="${{ steps.vars.outputs.formula }}"
          VERSION="${{ steps.vars.outputs.version }}"
          VERSION_NUM="${VERSION#v}"
          REPO="${{ steps.vars.outputs.repo }}"

          URL="https://github.com/${REPO}/releases/download/${VERSION}/${FORMULA}-${VERSION_NUM}-arm64-macos.tar.gz"

          curl -sL "$URL" -o binary.tar.gz
          SHA256=$(shasum -a 256 binary.tar.gz | cut -d' ' -f1)

          echo "sha256=${SHA256}" >> $GITHUB_OUTPUT
          echo "url=${URL}" >> $GITHUB_OUTPUT
          echo "version_num=${VERSION_NUM}" >> $GITHUB_OUTPUT

      - name: Update Formula
        run: |
          FORMULA="${{ steps.vars.outputs.formula }}"
          VERSION_NUM="${{ steps.sha.outputs.version_num }}"
          SHA256="${{ steps.sha.outputs.sha256 }}"
          URL="${{ steps.sha.outputs.url }}"

          # Update the formula file
          FORMULA_FILE="Formula/${FORMULA}.rb"

          # Use sed to update version, url, and sha256
          sed -i "s|url \".*\"|url \"${URL}\"|" "$FORMULA_FILE"
          sed -i "s|sha256 \".*\"|sha256 \"${SHA256}\"|" "$FORMULA_FILE"
          sed -i "s|version \".*\"|version \"${VERSION_NUM}\"|" "$FORMULA_FILE"

      - name: Commit and Push
        run: |
          git config user.name "github-actions[bot]"
          git config user.email "github-actions[bot]@users.noreply.github.com"

          FORMULA="${{ steps.vars.outputs.formula }}"
          VERSION="${{ steps.vars.outputs.version }}"

          git add Formula/${FORMULA}.rb
          git commit -m "Update ${FORMULA} to ${VERSION}"
          git push
```

---

## Secrets Required

### Source Repositories (SwiftProyecto, SwiftBruja)

| Secret | Purpose |
|--------|---------|
| `HOMEBREW_TAP_TOKEN` | Personal Access Token with `repo` scope for triggering workflows in homebrew-tap |

### Homebrew Tap Repository

| Secret | Purpose |
|--------|---------|
| `GITHUB_TOKEN` | Built-in token (auto-provided) for committing formula updates |

---

## Setup Checklist

### 1. Create Homebrew Tap Repository

- [ ] Create `intrusive-memory/homebrew-tap` repository on GitHub
- [ ] Initialize with this structure
- [ ] Add MIT LICENSE
- [ ] Add README.md with installation instructions

### 2. Create Initial Formulas

- [ ] Create `Formula/proyecto.rb` with placeholder values
- [ ] Create `Formula/bruja.rb` with placeholder values

### 3. Configure Secrets

- [ ] Create Personal Access Token with `repo` scope
- [ ] Add `HOMEBREW_TAP_TOKEN` secret to SwiftProyecto
- [ ] Add `HOMEBREW_TAP_TOKEN` secret to SwiftBruja

### 4. Update Source Repositories

- [ ] Add/update release workflow in SwiftProyecto
- [ ] Add/update release workflow in SwiftBruja
- [ ] Ensure `make release` produces working binary in `./bin/`

### 5. Add Tap Workflow

- [ ] Add `.github/workflows/update-formula.yml` to homebrew-tap

### 6. Test the Pipeline

- [ ] Create a test release in SwiftBruja
- [ ] Verify binary is attached to release
- [ ] Verify formula is updated in homebrew-tap
- [ ] Test installation: `brew tap intrusive-memory/tap && brew install bruja`
- [ ] Repeat for SwiftProyecto

---

## User Installation

Once set up, users can install via:

```bash
# Add the tap
brew tap intrusive-memory/tap

# Install individual tools
brew install proyecto
brew install bruja

# Or install both at once
brew install proyecto bruja

# Update to latest versions
brew update
brew upgrade proyecto bruja
```

---

## Version Tagging Convention

Releases should follow semantic versioning with a `v` prefix:

- `v1.0.0` - Major release
- `v1.1.0` - Minor release (new features)
- `v1.1.1` - Patch release (bug fixes)

The release workflow will handle stripping the `v` prefix for the formula version number.

---

## Future Considerations

### Intel Support (x86_64)

Currently both projects are Apple Silicon only due to MLX requirements. If Intel support is added in the future:

1. Build matrix would include both architectures
2. Formulas would need conditional URLs based on `Hardware::CPU.arm?`
3. Consider using Homebrew bottles for official distribution

### Homebrew Core Submission

Once the tap is stable and has sufficient users, consider submitting to homebrew-core for wider distribution. Requirements:
- 50+ GitHub stars (soft guideline)
- Stable release history
- No proprietary dependencies
- Comprehensive test coverage

---

## Maintenance

### Formula Updates

Formulas are automatically updated when releases are published. Manual updates may be needed for:
- Changing dependencies
- Updating homepage URLs
- Modifying test commands
- Adding caveats

### Monitoring

- Watch for failed workflow runs in both source repos and tap
- Monitor GitHub issues for installation problems
- Test installations periodically on fresh systems
