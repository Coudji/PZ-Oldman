#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root"

test -f OldManMode/common/mod.info
test -d OldManMode/common/42/media/lua/shared

if command -v luac >/dev/null 2>&1; then
  while IFS= read -r -d '' file; do
    luac -p "$file"
  done < <(find OldManMode -type f -name '*.lua' -print0)
else
  echo "warning: luac is unavailable; skipped Lua parser check" >&2
fi

if rg -n 'TODO|FIXME' OldManMode docs; then
  echo "found unresolved markers" >&2
  exit 1
fi

echo "Old Man Mode static checks passed"
