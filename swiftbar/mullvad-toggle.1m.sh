#!/bin/zsh
# <swiftbar.title>Tailscale Mullvad Toggle</swiftbar.title>
# <swiftbar.version>1.0.0</swiftbar.version>
# <swiftbar.author>0xSero</swiftbar.author>
# <swiftbar.desc>Toggle Tailscale Mullvad exit nodes from the macOS menu bar.</swiftbar.desc>

CLI="${TS_MULLVAD_CLI:-$HOME/.local/bin/ts-mullvad}"
if [[ ! -x "$CLI" ]]; then
  echo "Mullvad Setup"
  echo "---"
  echo "ts-mullvad CLI is not installed."
  echo "Open install docs | href=https://github.com/0xSero/tailscale-mullvad-toggle#quick-start"
  exit 0
fi

exec "$CLI" menubar
