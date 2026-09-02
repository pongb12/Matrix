#!/usr/bin/env bash
# Matrix dotfiles installer
# Idempotent and non-destructive:
#   - Creates only the missing target directories.
#   - Deploys ONLY the Matrix-managed files listed in MANAGED_FILES.
#   - Never removes, renames, or touches any other file in ~/.config.
#   - Re-running produces the same result without accumulating changes.

set -euo pipefail

# Repo root = directory containing this script
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_BASE="${HOME}/.config"

# Every file managed by this repo: "repo_relative_path"
MANAGED_FILES=(
    "hypr/hyprland.conf"
    "hypr/configs/env.conf"
    "hypr/configs/monitors.conf"
    "hypr/configs/appearance.conf"
    "hypr/configs/keybinds.conf"
    "hypr/configs/windowrules.conf"
    "hypr/configs/autostart.conf"
    "waybar/config.jsonc"
    "waybar/style.css"
    "rofi/config.rasi"
    "rofi/colors.rasi"
    "dunst/dunstrc"
)

deploy_file() {
    local rel="$1"
    local src="${REPO_ROOT}/${rel}"
    local dest="${TARGET_BASE}/${rel}"

    if [[ ! -f "${src}" ]]; then
        echo "ERROR: missing source file: ${src}" >&2
        exit 1
    fi

    mkdir -p "$(dirname "${dest}")"
    install -m 644 "${src}" "${dest}"
    echo "deployed: ${rel}"
}

echo "Matrix dotfiles -> ${TARGET_BASE}"
for rel in "${MANAGED_FILES[@]}"; do
    deploy_file "${rel}"
done

echo "Done. ${#MANAGED_FILES[@]} files deployed. Nothing else was modified."
