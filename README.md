# Track Linux v0.1

A minimal, application-centric Arch + Hyprland workstation configuration for the ThinkPad X9.

## Philosophy

- Persistent = infrastructure
- On-demand = interface
- No desktop environment
- No panel or dock by default
- No widget shell
- No wallpaper daemon
- No graphical control center
- Add features only when they earn their place

## Installation model

This repository is currently a **post-install bootstrap**, not a disk installer.

1. Install a minimal Arch Linux system on the X9.
2. Create your normal user and give it sudo access.
3. Boot into that installed Arch system.
4. Clone this repository.
5. Run:

```bash
chmod +x install.sh
./install.sh
```

6. Start Hyprland from the TTY:

```bash
start-hyprland
```

## Package layout

- `packages/base.txt` — Arch + X9 platform essentials (using the default firmware set for a reliable first build)
- `packages/workstation.txt` — required Wayland/workstation stack
- `packages/optional.txt` — deliberately excluded features you can add later

## Hyprland layout

- `dotfiles/hypr/hyprland.lua` — main orchestration file
- `dotfiles/hypr/autostart.lua` — minimal required graphical-session startup
- `dotfiles/hypr/keybindings.lua` — keyboard/mouse controls

## Networking

NetworkManager is enabled by the installer.

Use either:

```bash
nmcli
```

or:

```bash
nmtui
```

## Deliberately not installed/enabled

Bluetooth, Thunderbolt authorization helpers, a power-profile daemon, firmware-update tooling,
and system monitors are listed in `packages/optional.txt`. They can be added after testing the
actual X9 workflow rather than being assumed necessary.
