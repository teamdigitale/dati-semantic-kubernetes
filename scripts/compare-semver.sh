#!/usr/bin/env bash
# Output the latest semver tag that is strictly greater than current.
# Usage: compare-semver.sh CURRENT_TAG REMOTE_TAG [REMOTE_TAG ...]
#   or:  echo CURRENT_TAG | compare-semver.sh - REMOTE_TAG [REMOTE_TAG ...]
# - If current tag is not valid semver, treat it as 0.0.0.
# - Ignore non-semver remote tags.
# Exit 0 with the chosen tag on stdout, or exit 1 if no such tag.

set -e

SEMVER_RE='^v?([0-9]+)\.([0-9]+)\.([0-9]+)(-[^+]+)?(\+.+)?$'

normalize() {
  local tag="$1"
  if [[ "$tag" =~ $SEMVER_RE ]]; then
    echo "${BASH_REMATCH[1]}.${BASH_REMATCH[2]}.${BASH_REMATCH[3]}"
  else
    echo ""
  fi
}

# current tag: first arg or stdin if first arg is "-"
current_tag=""
if [[ "${1:-}" == "-" ]]; then
  shift
  read -r current_tag || true
else
  current_tag="${1:-}"
  shift
fi

current_norm=$(normalize "$current_tag")
[[ -z "$current_norm" ]] && current_norm="0.0.0"

# remote tags: rest of args (or stdin if no args left)
remote_tags=("$@")
if [[ ${#remote_tags[@]} -eq 0 ]]; then
  while read -r line; do
    remote_tags+=("$line")
  done || true
fi

best_norm=""
best_original=""

for tag in "${remote_tags[@]}"; do
  tag=$(echo "$tag" | tr -d '\r')
  [[ -z "$tag" ]] && continue
  norm=$(normalize "$tag")
  [[ -z "$norm" ]] && continue
  # strict greater: norm > current_norm (by sort -V order)
  sorted=$(echo -e "${current_norm}\n${norm}" | sort -V)
  first=$(echo "$sorted" | head -1)
  if [[ "$first" == "$current_norm" && "$norm" != "$current_norm" ]]; then
    # norm is strictly greater; keep if best is empty or norm is greater than best
    if [[ -z "$best_norm" ]] || [[ $(echo -e "${best_norm}\n${norm}" | sort -V | tail -1) == "$norm" ]]; then
      best_norm="$norm"
      best_original="$tag"
    fi
  fi
done

if [[ -z "$best_original" ]]; then
  exit 1
fi
echo "$best_original"
exit 0
