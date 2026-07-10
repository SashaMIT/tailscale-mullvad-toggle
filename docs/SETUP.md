# Setup Flow

## If Tailscale Is Missing

Install Tailscale:

<https://tailscale.com/download>

Then sign in and run:

```sh
ts-mullvad doctor
```

## If Mullvad Is Missing

Mullvad exit nodes are a Tailscale add-on. A tailnet admin must enable them and grant your device access.

Start here:

<https://login.tailscale.com/admin/settings/general>

Docs:

<https://tailscale.com/docs/features/exit-nodes/mullvad-exit-nodes>

After enabling access, run:

```sh
ts-mullvad list --country any
```

## If SwiftBar Complains About Too Many Files

Choose a plugin folder that only contains SwiftBar plugin files.

The default installer uses:

```sh
~/Library/Application Support/SwiftBar/Plugins
```

That folder should contain `mullvad-toggle.1m.sh`, not the entire repository.
