#!/bin/bash
# Blink installer: stages model weights, clears quarantine, checks the app runs.
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODELS_DST="$HOME/Library/Caches/desert-ant-models"

echo "Blink installer"
echo "  bundle: $HERE"
echo

if [ ! -d "$HERE/Blink.app" ]; then
    echo "error: Blink.app not found next to install.sh" >&2
    exit 1
fi

if [ -d "$HERE/models/desert-ant-labs" ]; then
    mkdir -p "$MODELS_DST"
    rsync -a "$HERE/models/" "$MODELS_DST/"
    echo "  weights: $MODELS_DST ($(du -sh "$MODELS_DST" | cut -f1))"
else
    echo "  weights: none bundled, Blink will download on first run"
fi

xattr -dr com.apple.quarantine "$HERE/Blink.app" 2>/dev/null || true
for bin in blink-cli blink-snap; do
    if [ -f "$HERE/bin/$bin" ]; then
        chmod +x "$HERE/bin/$bin"
        xattr -dr com.apple.quarantine "$HERE/bin/$bin" 2>/dev/null || true
    fi
done

echo "  app:     $HERE/Blink.app"
echo
echo "Open it:"
echo "  open \"$HERE/Blink.app\""
echo "Or open straight into a folder:"
echo "  open \"$HERE/Blink.app\" --args \"$HERE/sample\""
