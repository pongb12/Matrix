#!/usr/bin/env bash
# Matrix dotfiles installer (distro-agnostic)
#
# Usage:
#   ./install.sh            Deploy configs into ~/.config (always safe)
#   ./install.sh --deps     Also install system packages (Arch/CachyOS only)
#
# Design rules (unchanged from the original Matrix installer):
#   - Idempotent: re-running produces the same result, no accumulation.
#   - Non-destructive: only writes the Matrix-managed files listed in
#     MANAGED_FILES; never removes, renames, or touches anything else
#     in ~/.config (other DEs' configs, user files, etc. stay untouched).

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_BASE="${XDG_CONFIG_HOME:-$HOME/.config}"

# Every file managed by this repo: "repo_relative_path" (scripts get 0755)
MANAGED_FILES=(
    "hypr/hyprland.conf"
    "hypr/configs/env.conf"
    "hypr/configs/monitors.conf"
    "hypr/configs/displays.conf"
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
MANAGED_SCRIPTS=(
    "hypr/scripts/multi-display.sh"
)

# ---------------------------------------------------------------------------
# Dependency installation (Arch / CachyOS via pacman)
# ---------------------------------------------------------------------------

# Core packages required for the session to be fully usable
PACMAN_CORE=(
    hyprland waybar rofi dunst swaybg kitty
    brightnessctl grim slurp wl-clipboard jq
    pipewire wireplumber
)
# Recommended extras (optional; configs work without them)
PACMAN_EXTRA=(
    thunar pavucontrol network-manager-applet
    ttf-jetbrainsmono-nerd noto-fonts papirus-icon-theme
)

install_deps() {
    if ! command -v pacman >/dev/null 2>&1; then
        cat >&2 <<'EOF'
--deps is only implemented for pacman-based distros (Arch, CachyOS).
On other distros install the equivalents of these packages manually:

  hyprland waybar rofi (Wayland build) dunst swaybg kitty brightnessctl
  grim slurp wl-clipboard jq pipewire wireplumber thunar pavucontrol
  network-manager-applet + a Nerd Font (JetBrainsMono) and noto-fonts

Config deployment still works on any distro: run ./install.sh
EOF
        exit 1
    fi

    echo "==> Installing core packages (pacman)"
    sudo pacman -S --needed -- "${PACMAN_CORE[@]}"
    echo "==> Installing recommended extras"
    sudo pacman -S --needed -- "${PACMAN_EXTRA[@]}" || \
        echo "WARN: some optional packages failed; the session works without them." >&2
}

# ---------------------------------------------------------------------------
# Deployment
# ---------------------------------------------------------------------------

deploy_file() {
    local rel="$1" mode="$2"
    local src="${REPO_ROOT}/${rel}"
    local dest="${TARGET_BASE}/${rel}"

    if [[ ! -f "${src}" ]]; then
        echo "ERROR: missing source file: ${src}" >&2
        exit 1
    fi

    mkdir -p "$(dirname "${dest}")"
    install -m "${mode}" "${src}" "${dest}"
    echo "deployed: ${rel}"
}

case "${1:-}" in
    --deps) install_deps ;;
    "") ;;
    *) echo "Usage: $0 [--deps]" >&2; exit 64 ;;
esac

echo "Matrix dotfiles -> ${TARGET_BASE}"
for rel in "${MANAGED_FILES[@]}"; do
    deploy_file "${rel}" 644
done
for rel in "${MANAGED_SCRIPTS[@]}"; do
    deploy_file "${rel}" 755
done

COUNT=$(( ${#MANAGED_FILES[@]} + ${#MANAGED_SCRIPTS[@]} ))
echo "Done. ${COUNT} files deployed. Nothing else was modified."
echo
echo "Next steps:"
echo "  1. Put a wallpaper at ~/Pictures/wallpaper.jpg (or edit autostart.conf)."
echo "  2. Log out and pick 'Hyprland' in your display manager."
echo "  3. Super+P switches display mode (PC only / Duplicate / Extend / Second screen only)."
