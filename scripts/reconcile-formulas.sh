#!/usr/bin/env bash
#
# Reconcile every formula in this tap against its source repo's latest release.
#
# This is a PULL, not a push. Nothing outside this repo needs to notify us, and
# nothing needs a cross-repo credential: every source repo is public, and the
# only write is to this repo, which the built-in GITHUB_TOKEN already covers.
#
# It exists because push-based dispatch fails silently. When the DEPLOY_TOKEN
# PAT expired in July 2026, three formulas sat stale for a week with no signal.
# A reconciler self-heals regardless of why drift happened.
#
# Usage:
#   scripts/reconcile-formulas.sh            # bump what drifted, stage changes
#   DRY_RUN=1 scripts/reconcile-formulas.sh  # report only, touch nothing
#
# Requires: gh (authenticated), curl, shasum/sha256sum, perl.
# Exits non-zero only on internal error. Drift that cannot be applied is
# reported as a warning and does not fail the run -- see MISSING_ASSET below.

set -euo pipefail

DRY_RUN="${DRY_RUN:-0}"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

# Accumulated for the run summary.
BUMPED=()
OK=()
SKIPPED=()
WARNED=()

sha256_of() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | cut -d' ' -f1
  else
    shasum -a 256 "$1" | cut -d' ' -f1
  fi
}

for formula_file in Formula/*.rb; do
  formula="$(basename "$formula_file" .rb)"

  # A disabled or deprecated formula is pinned on purpose. Bumping it would
  # undo a deliberate decision -- and for a library-only repo there is no
  # tarball to bump to anyway. This is what stranded `hablare` for 3 months.
  if grep -qE '^\s*(disable|deprecate)!' "$formula_file"; then
    SKIPPED+=("${formula}: disabled/deprecated on purpose")
    continue
  fi

  # The source repo is authoritative in `homepage`, not `url` -- `url` points
  # at a release asset path and breaks if the release layout ever changes.
  source_repo="$(perl -ne 'print "$1\n" and exit if m{^\s*homepage\s+"https://github\.com/([^/"]+/[^/"]+)}' "$formula_file")"
  if [ -z "$source_repo" ]; then
    WARNED+=("${formula}: could not parse a GitHub source repo from homepage")
    continue
  fi

  current="$(perl -ne 'print "$1\n" and exit if m{^\s*version\s+"([^"]+)"}' "$formula_file")"
  if [ -z "$current" ]; then
    WARNED+=("${formula}: no version stanza found")
    continue
  fi

  # `releases/latest` deliberately excludes drafts and prereleases; a formula
  # should never track either. 404 means the repo has no stable release yet.
  if ! latest_tag="$(gh api "repos/${source_repo}/releases/latest" --jq '.tag_name' 2>/dev/null)"; then
    SKIPPED+=("${formula}: ${source_repo} has no stable release")
    continue
  fi
  latest="${latest_tag#v}"

  if [ "$current" = "$latest" ]; then
    OK+=("${formula}: ${current}")
    continue
  fi

  url="https://github.com/${source_repo}/releases/download/${latest_tag}/${formula}-${latest}-arm64-macos.tar.gz"

  # Verify the asset exists BEFORE rewriting anything. A source repo that
  # stopped shipping binaries (SwiftHablare at v6.1.0) still cuts releases, so
  # a version diff alone is not evidence that a tarball is there to install.
  if ! curl -sfL --retry 3 --retry-delay 2 -o /tmp/formula-asset.tar.gz "$url"; then
    WARNED+=("${formula}: ${current} -> ${latest} available but NO BINARY at ${url} -- source repo may have gone library-only; consider disable!")
    continue
  fi
  if [ ! -s /tmp/formula-asset.tar.gz ]; then
    WARNED+=("${formula}: ${current} -> ${latest} downloaded an empty asset from ${url}")
    continue
  fi

  sha="$(sha256_of /tmp/formula-asset.tar.gz)"
  rm -f /tmp/formula-asset.tar.gz

  if [ "$DRY_RUN" = "1" ]; then
    BUMPED+=("${formula}: ${current} -> ${latest} (dry run, not written)")
    continue
  fi

  # Env-passed values rather than interpolated into the regex: formula fields
  # are URLs and hashes, and one stray slash in a sed expression corrupts the file.
  URL="$url" SHA="$sha" VER="$latest" perl -pi -e '
    s{^(\s*url\s+)".*"}{$1."\"$ENV{URL}\""}e;
    s{^(\s*sha256\s+)".*"}{$1."\"$ENV{SHA}\""}e;
    s{^(\s*version\s+)".*"}{$1."\"$ENV{VER}\""}e;
  ' "$formula_file"

  git add "$formula_file"
  BUMPED+=("${formula}: ${current} -> ${latest}")
done

emit() {
  local title="$1"; shift
  [ "$#" -eq 0 ] && return 0
  echo ""
  echo "${title}"
  printf '  %s\n' "$@"
}

echo "=== Formula reconciliation ==="
emit "BUMPED:" ${BUMPED+"${BUMPED[@]}"}
emit "WARNINGS (drift found but not applied):" ${WARNED+"${WARNED[@]}"}
emit "UP TO DATE:" ${OK+"${OK[@]}"}
emit "SKIPPED:" ${SKIPPED+"${SKIPPED[@]}"}
echo ""

# Mirror the same report into the Actions run summary when running in CI.
if [ -n "${GITHUB_STEP_SUMMARY:-}" ]; then
  {
    echo "## Formula reconciliation"
    echo ""
    if [ "${#BUMPED[@]}" -gt 0 ]; then
      echo "### Bumped"
      printf -- '- %s\n' "${BUMPED[@]}"
      echo ""
    fi
    if [ "${#WARNED[@]}" -gt 0 ]; then
      echo "### :warning: Drift found but NOT applied"
      printf -- '- %s\n' "${WARNED[@]}"
      echo ""
    fi
    if [ "${#OK[@]}" -gt 0 ]; then
      echo "<details><summary>Up to date (${#OK[@]})</summary>"
      echo ""
      printf -- '- %s\n' "${OK[@]}"
      echo ""
      echo "</details>"
      echo ""
    fi
    if [ "${#SKIPPED[@]}" -gt 0 ]; then
      echo "<details><summary>Skipped (${#SKIPPED[@]})</summary>"
      echo ""
      printf -- '- %s\n' "${SKIPPED[@]}"
      echo ""
      echo "</details>"
    fi
  } >> "$GITHUB_STEP_SUMMARY"
fi

# Surface the count so the workflow can decide whether to commit.
if [ -n "${GITHUB_OUTPUT:-}" ]; then
  echo "bumped_count=${#BUMPED[@]}" >> "$GITHUB_OUTPUT"
  echo "warned_count=${#WARNED[@]}" >> "$GITHUB_OUTPUT"
fi
