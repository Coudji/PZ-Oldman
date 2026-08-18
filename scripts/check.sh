#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root"

mod_root="OldManMode"
version_root="$mod_root/42"
lua_root="$version_root/media/lua"

required=(
  "$version_root/mod.info"
  "$lua_root/shared/OldMan_Config.lua"
  "$lua_root/shared/OldMan_Phobias.lua"
  "$lua_root/shared/OldMan_Traits.lua"
  "$lua_root/client/OldMan_Personality.lua"
  "$lua_root/client/OldMan_Reactions.lua"
  "$lua_root/server/OldMan_Server.lua"
  "$lua_root/shared/Translate/EN/UI_EN.txt"
  "$lua_root/shared/Translate/FR/UI_FR.txt"
)

for file in "${required[@]}"; do
  test -f "$file" || { echo "missing required file: $file" >&2; exit 1; }
done

test ! -e "$mod_root/common/mod.info" || {
  echo "mod.info must be inside the version directory, not common/" >&2
  exit 1
}
test ! -d "$mod_root/common/42" || {
  echo "invalid nested version directory: common/42" >&2
  exit 1
}

rg -q '^id=OldManMode$' "$version_root/mod.info"
rg -q '^versionMin=42([.]0)?$' "$version_root/mod.info"

if command -v luac >/dev/null 2>&1; then
  while IFS= read -r -d '' file; do
    luac -p "$file"
  done < <(find "$lua_root" -type f -name '*.lua' -print0)
else
  echo "warning: luac is unavailable; skipped Lua parser check" >&2
fi

if rg -n 'TODO|FIXME' "$mod_root" docs; then
  echo "found unresolved markers" >&2
  exit 1
fi

echo "Old Man Mode static checks passed (this is not an in-game test)"
