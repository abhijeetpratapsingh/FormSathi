#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IOS_DIR="$PROJECT_ROOT/ios"
BREW_BIN="${BREW_BIN:-/opt/homebrew/bin/brew}"

if [[ ! -x "$BREW_BIN" ]]; then
  echo "Homebrew was not found at $BREW_BIN."
  echo "Install Homebrew first, or run with BREW_BIN=/path/to/brew $0"
  exit 1
fi

echo
echo "== Homebrew =="
"$BREW_BIN" --version

echo
echo "== Install CocoaPods via Homebrew =="
if "$BREW_BIN" list cocoapods >/dev/null 2>&1; then
  "$BREW_BIN" upgrade cocoapods || true
else
  "$BREW_BIN" install cocoapods
fi

BREW_PREFIX="$("$BREW_BIN" --prefix)"
export PATH="$BREW_PREFIX/bin:$PATH"
POD_BIN="$BREW_PREFIX/bin/pod"

echo
echo "== Verify CocoaPods =="
which pod
"$POD_BIN" --version

echo
echo "== Flutter dependencies =="
cd "$PROJECT_ROOT"
flutter pub get

echo
echo "== CocoaPods install =="
cd "$IOS_DIR"
"$POD_BIN" install --repo-update

echo
echo "Done. You can now run:"
echo "  cd \"$PROJECT_ROOT\""
echo "  export PATH=\"$BREW_PREFIX/bin:\$PATH\""
echo "  flutter run"
