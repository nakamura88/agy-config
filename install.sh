#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$HOME/.gemini/antigravity-cli"
TARGET_FILE="$TARGET_DIR/settings.json"
SOURCE_FILE="$SCRIPT_DIR/settings.json"

mkdir -p "$TARGET_DIR"

if [ -f "$TARGET_FILE" ] && command -v python3 >/dev/null 2>&1; then
  python3 - "$SOURCE_FILE" "$TARGET_FILE" <<'PY'
import json
import sys

source_path, target_path = sys.argv[1], sys.argv[2]
with open(source_path, "r", encoding="utf-8") as f:
    new_settings = json.load(f)
try:
    with open(target_path, "r", encoding="utf-8") as f:
        current_settings = json.load(f)
except Exception:
    current_settings = {}

current_settings.update(new_settings)
with open(target_path, "w", encoding="utf-8") as f:
    json.dump(current_settings, f, indent=2, ensure_ascii=False)
    f.write("\n")
PY
else
  cp "$SOURCE_FILE" "$TARGET_FILE"
fi

echo "Updated $TARGET_FILE successfully."
cat "$TARGET_FILE"
