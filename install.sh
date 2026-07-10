#!/bin/zsh
set -eu

REPO_RAW="${TS_MULLVAD_RAW_BASE:-https://raw.githubusercontent.com/0xSero/tailscale-mullvad-toggle/main}"
PREFIX="${TS_MULLVAD_PREFIX:-$HOME/.local}"
BIN_DIR="$PREFIX/bin"
SWIFTBAR_DIR="${SWIFTBAR_PLUGIN_DIR:-$HOME/Library/Application Support/SwiftBar/Plugins}"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

say() {
  printf '%s\n' "$*"
}

fetch_or_copy() {
  local source="$1"
  local dest="$2"
  if [[ -f "$source" ]]; then
    cp "$source" "$dest"
  else
    curl -fsSL "$source" -o "$dest"
  fi
}

ROOT="$(cd "$(dirname "$0")" && pwd)"
if [[ -f "$ROOT/bin/ts-mullvad" ]]; then
  fetch_or_copy "$ROOT/bin/ts-mullvad" "$TMP_DIR/ts-mullvad"
  fetch_or_copy "$ROOT/swiftbar/mullvad-toggle.1m.sh" "$TMP_DIR/mullvad-toggle.1m.sh"
else
  fetch_or_copy "$REPO_RAW/bin/ts-mullvad" "$TMP_DIR/ts-mullvad"
  fetch_or_copy "$REPO_RAW/swiftbar/mullvad-toggle.1m.sh" "$TMP_DIR/mullvad-toggle.1m.sh"
fi

mkdir -p "$BIN_DIR" "$SWIFTBAR_DIR"
install -m 700 "$TMP_DIR/ts-mullvad" "$BIN_DIR/ts-mullvad"
install -m 700 "$TMP_DIR/mullvad-toggle.1m.sh" "$SWIFTBAR_DIR/mullvad-toggle.1m.sh"

say "Installed CLI:"
say "  $BIN_DIR/ts-mullvad"
say "Installed SwiftBar plugin:"
say "  $SWIFTBAR_DIR/mullvad-toggle.1m.sh"

if ! command -v tailscale >/dev/null 2>&1; then
  say ""
  say "Tailscale CLI was not found."
  say "Install Tailscale: https://tailscale.com/download"
fi

if [[ "$(uname -s)" == "Darwin" ]]; then
  if ! [[ -d "/Applications/SwiftBar.app" || -d "$HOME/Applications/SwiftBar.app" ]]; then
    if command -v brew >/dev/null 2>&1; then
      say ""
      say "Installing SwiftBar with Homebrew..."
      brew install --cask swiftbar || brew install swiftbar
    else
      say ""
      say "SwiftBar is not installed. Download it from https://swiftbar.app/"
    fi
  fi

  defaults write com.ameba.SwiftBar pluginDirectoryPath -string "$SWIFTBAR_DIR" || true
  defaults write com.ameba.SwiftBar _pluginDirectoryPath -string "$SWIFTBAR_DIR" || true
  open -a SwiftBar >/dev/null 2>&1 || true
fi

say ""
"$BIN_DIR/ts-mullvad" doctor || true
say ""
say "Try:"
say "  $BIN_DIR/ts-mullvad toggle"
