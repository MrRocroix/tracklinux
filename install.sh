#!/usr/bin/env bash
set -euo pipefail

# Track Linux v0.1 post-install bootstrap
#
# Assumptions:
#   1. Arch Linux is already installed and booted.
#   2. Run this script as your normal user, not root.
#   3. Your user has sudo access.
#
# This script intentionally does NOT:
#   - partition disks
#   - install/configure a bootloader
#   - create users/passwords
#   - install a display manager
#   - enable Bluetooth
#   - start a panel, dock, widget shell, or wallpaper daemon

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

die() {
    printf 'ERROR: %s\n' "$*" >&2
    exit 1
}

if [[ ! -f /etc/arch-release ]]; then
    die "This bootstrap is intended to run from an installed Arch Linux system."
fi

if [[ "${EUID}" -eq 0 ]]; then
    die "Run ./install.sh as your normal user. The script will use sudo when needed."
fi

command -v sudo >/dev/null 2>&1 || die "sudo is required."
command -v pacman >/dev/null 2>&1 || die "pacman was not found."

read_package_file() {
    local file="$1"

    [[ -f "$file" ]] || die "Missing package file: $file"

    # Remove comments, blank lines and surrounding whitespace.
    sed -e 's/[[:space:]]*#.*$//' \
        -e 's/^[[:space:]]*//' \
        -e 's/[[:space:]]*$//' \
        -e '/^$/d' "$file"
}

mapfile -t BASE_PACKAGES < <(read_package_file "$REPO_ROOT/packages/base.txt")
mapfile -t WORKSTATION_PACKAGES < <(read_package_file "$REPO_ROOT/packages/workstation.txt")

printf '\nTrack Linux v0.1\n'
printf '================\n'
printf 'Base packages:        %d\n' "${#BASE_PACKAGES[@]}"
printf 'Workstation packages: %d\n\n' "${#WORKSTATION_PACKAGES[@]}"

printf 'Updating Arch and installing required packages...\n'
sudo pacman -Syu --needed "${BASE_PACKAGES[@]}" "${WORKSTATION_PACKAGES[@]}"

printf '\nEnabling NetworkManager...\n'
sudo systemctl enable --now NetworkManager.service

install_config_dir() {
    local name="$1"
    local source="$REPO_ROOT/dotfiles/$name"
    local destination="$HOME/.config/$name"

    if [[ ! -d "$source" ]]; then
        return
    fi

    mkdir -p "$destination"

    # Copy only files that exist in the repo. This keeps the repo as the
    # reproducible source while avoiding symlinks that break if the repo moves.
    cp -a "$source/." "$destination/"
    printf 'Installed config: %s -> %s\n' "$source" "$destination"
}

printf '\nInstalling user configuration...\n'
install_config_dir hypr
install_config_dir fuzzel
install_config_dir mako
install_config_dir foot

if [[ ! -f "$HOME/.config/hypr/hyprland.lua" ]]; then
    die "Hyprland config is missing after installation."
fi

printf '\nBootstrap complete.\n\n'
printf 'No display manager was installed by design.\n'
printf 'From a TTY, start the session with:\n\n'
printf '    start-hyprland\n\n'
printf 'Network management is available with:\n\n'
printf '    nmcli\n'
printf '    nmtui\n\n'
printf 'Optional packages are listed in packages/optional.txt and are not installed.\n'
