#!/usr/bin/env bash
# AI Champions Kit installer.
# Copies skills and agents from this kit into the current project's .claude/ directory.

set -euo pipefail

KIT_ROOT="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
TARGET_DIR="${PWD}/.claude"
TIER="universal"
FORCE=0
DRY_RUN=0

usage() {
  cat <<EOF
AI Champions Kit installer

Usage:
  install.sh --tier <universal|content|code|champion|all> [options]

Options:
  --tier TIER       Which tier to install (required). Use --tier all to install everything.
  --target DIR      Override install target (default: \$PWD/.claude)
  --force           Overwrite existing files in the target
  --dry-run         Show what would be copied, don't write anything
  -h, --help        Show this message

Tiers:
  universal   Core skills every Champion should have
  content     Writing, voice, docs, review tools
  code        For vibe-coders and engineers
  champion    Gap-fillers (PII, hallucinations, GPT context caps)
  all         All of the above
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --tier)     TIER="$2"; shift 2 ;;
    --target)   TARGET_DIR="$2"; shift 2 ;;
    --force)    FORCE=1; shift ;;
    --dry-run)  DRY_RUN=1; shift ;;
    -h|--help)  usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage; exit 1 ;;
  esac
done

case "$TIER" in
  universal|content|code|champion|all) ;;
  *) echo "Invalid --tier: $TIER" >&2; usage; exit 1 ;;
esac

TIERS=()
if [[ "$TIER" == "all" ]]; then
  TIERS=(universal content code-adjacent champion-specific)
elif [[ "$TIER" == "code" ]]; then
  TIERS=(code-adjacent)
elif [[ "$TIER" == "champion" ]]; then
  TIERS=(champion-specific)
else
  TIERS=("$TIER")
fi

copy_dir() {
  local src="$1"
  local dst="$2"
  [[ -d "$src" ]] || return 0

  mkdir -p "$dst"
  local count=0
  while IFS= read -r -d '' file; do
    local name
    name="$(basename "$file")"
    local target="$dst/$name"
    if [[ -e "$target" && $FORCE -eq 0 ]]; then
      echo "  skip (exists): $name"
      continue
    fi
    if [[ $DRY_RUN -eq 1 ]]; then
      echo "  would copy: $name"
    else
      cp "$file" "$target"
      echo "  copied: $name"
    fi
    count=$((count + 1))
  done < <(find "$src" -maxdepth 1 -name '*.md' -type f -print0)
  echo "  ($count files from $(basename "$src"))"
}

echo "Installing tiers: ${TIERS[*]}"
echo "Target: $TARGET_DIR"
[[ $DRY_RUN -eq 1 ]] && echo "(dry run — no files will be written)"
echo

for tier in "${TIERS[@]}"; do
  echo "Skills: $tier"
  copy_dir "$KIT_ROOT/skills/$tier" "$TARGET_DIR/skills"
  echo "Agents: $tier"
  copy_dir "$KIT_ROOT/agents/$tier" "$TARGET_DIR/agents"
  echo
done

echo "Done."
echo
echo "Next steps:"
echo "  1. Review the installed files in $TARGET_DIR"
echo "  2. Open $KIT_ROOT/templates/ and copy the starter templates you need"
echo "  3. Open Claude Code in this project — the skills and agents are now discoverable"
