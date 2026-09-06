#!/usr/bin/env bash
# Matrix dotfiles - Multi-display switcher (Super+P)
#
# Windows-style display mode picker with four modes:
#   1. PC screen only        - laptop/PC screen on, projector/TV off
#   2. Duplicate             - identical content on both screens (presentations)
#   3. Extend                - second screen becomes an extended workspace
#   4. Second screen only    - laptop screen off, output on projector/TV
#
# Dependencies: hyprland (hyprctl), rofi; optional: dunst (dunstify) or
# libnotify (notify-send), jq (accurate active-mode detection).
#
# The chosen mode is applied live via hyprctl and persisted into
# ~/.config/hypr/configs/displays.conf, which hyprland.conf sources, so the
# mode survives reloads and re-login.

set -euo pipefail

CONF_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/hypr/configs/displays.conf"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

notify() {
    # notify <summary> [body]
    if command -v dunstify >/dev/null 2>&1; then
        dunstify -u normal "$1" "${2:-}" &
    elif command -v notify-send >/dev/null 2>&1; then
        notify-send "$1" "${2:-}" &
    fi
}

die() {
    notify "Matrix: lỗi màn hình" "$1"
    echo "ERROR: $1" >&2
    exit 1
}

# ---------------------------------------------------------------------------
# Detect monitors
# ---------------------------------------------------------------------------

mon_list() {
    # Print all non-headless output names, one per line
    hyprctl monitors | awk '/^Monitor/ {print $2}' | grep -v '^HEADLESS' || true
}

INTERNAL=$(mon_list | grep -m1 '^eDP' || true)
EXTERNAL=$(mon_list | grep -v '^eDP' | head -n1 || true)

# Desktop PCs have no eDP panel: fall back to primary = first output
if [[ -z "$INTERNAL" ]]; then
    INTERNAL=$(mon_list | head -n1 || true)
    EXTERNAL=$(mon_list | grep -v "^${INTERNAL}$" | head -n1 || true)
fi

[[ -n "$INTERNAL" ]] || die "Không phát hiện màn hình nào."
if [[ -z "$EXTERNAL" ]]; then
    notify "Matrix: Màn hình" "Chỉ phát hiện một màn hình (${INTERNAL}). Kết nối projector/TV rồi nhấn Super+P."
    exit 0
fi

# ---------------------------------------------------------------------------
# Detect current mode (best effort; used only for the menu marker)
# ---------------------------------------------------------------------------

MODE="extend"
if command -v jq >/dev/null 2>&1; then
    int_dis=$(hyprctl -j monitors | jq -r --arg n "$INTERNAL" \
        '.[] | select(.name == $n) | .disabled' 2>/dev/null || echo "false")
    ext_dis=$(hyprctl -j monitors | jq -r --arg n "$EXTERNAL" \
        '.[] | select(.name == $n) | .disabled' 2>/dev/null || echo "false")
    ext_mirror=$(hyprctl -j monitors | jq -r --arg n "$EXTERNAL" \
        '.[] | select(.name == $n) | .mirror // "none"' 2>/dev/null || echo "none")

    if [[ "$ext_dis" == "true" ]]; then
        MODE="pc"
    elif [[ "$int_dis" == "true" ]]; then
        MODE="second"
    elif [[ -n "$ext_mirror" && "$ext_mirror" != "none" && "$ext_mirror" != "" ]]; then
        MODE="duplicate"
    fi
fi

# ---------------------------------------------------------------------------
# Rofi menu
# ---------------------------------------------------------------------------

menu_line() {
    # menu_line <mode-key> <text>  -> prefix "●" when the mode is active
    if [[ "$1" == "$MODE" ]]; then
        printf '●  %s\n' "$2"
    else
        printf '   %s\n' "$2"
    fi
}

MENU=$(cat <<EOF
$(menu_line pc       "1 · Chỉ màn hình máy tính  — PC screen only")
$(menu_line duplicate "2 · Nhân bản  — Duplicate (hiển thị giống nhau)")
$(menu_line extend   "3 · Mở rộng  — Extend (kéo thả cửa sổ qua 2 màn hình)")
$(menu_line second   "4 · Chỉ màn hình thứ hai  — Second screen only")
EOF
)

CHOICE=$(printf '%s\n' "$MENU" | rofi -dmenu -i -p "Màn hình (Super+P)") || exit 0

case "$CHOICE" in
    *1\ ·*) MODE="pc" ;;
    *2\ ·*) MODE="duplicate" ;;
    *3\ ·*) MODE="extend" ;;
    *4\ ·*) MODE="second" ;;
    *) exit 0 ;;
esac

# ---------------------------------------------------------------------------
# Apply mode: live via hyprctl, persistent via displays.conf
# ---------------------------------------------------------------------------

set_mon() {
    # set_mon <spec>  e.g. "eDP-1,preferred,auto,1" or "HDMI-A-1,disable"
    hyprctl keyword monitor "$1" >/dev/null
}

persist() {
    mkdir -p "$(dirname "$CONF_FILE")"
    cat > "$CONF_FILE" <<EOF
# Matrix dotfiles - Display state
# Managed automatically by scripts/multi-display.sh (Super+P). Last change:
# mode: $1  date: $(date '+%Y-%m-%d %H:%M')
# Delete this file to return to Hyprland's full auto-detection.
EOF
    case "$1" in
        pc)
            cat >> "$CONF_FILE" <<EOF
monitor = ${INTERNAL},preferred,auto,1
monitor = ${EXTERNAL},disable
EOF
            ;;
        duplicate)
            cat >> "$CONF_FILE" <<EOF
monitor = ${INTERNAL},preferred,0x0,1
monitor = ${EXTERNAL},preferred,0x0,1,mirror,${INTERNAL}
EOF
            ;;
        extend)
            cat >> "$CONF_FILE" <<EOF
monitor = ${INTERNAL},preferred,auto,1
monitor = ${EXTERNAL},preferred,auto,1
EOF
            ;;
        second)
            cat >> "$CONF_FILE" <<EOF
monitor = ${INTERNAL},disable
monitor = ${EXTERNAL},preferred,auto,1
EOF
            ;;
    esac
}

case "$MODE" in
    pc)
        set_mon "${INTERNAL},preferred,auto,1"
        set_mon "${EXTERNAL},disable"
        notify "Màn hình: Chỉ màn hình máy tính" "PC screen only — ${INTERNAL}"
        ;;
    duplicate)
        set_mon "${INTERNAL},preferred,0x0,1"
        set_mon "${EXTERNAL},preferred,0x0,1,mirror,${INTERNAL}"
        notify "Màn hình: Nhân bản (Duplicate)" "Cả hai màn hình hiển thị nội dung giống nhau."
        ;;
    extend)
        set_mon "${INTERNAL},preferred,auto,1"
        set_mon "${EXTERNAL},preferred,auto,1"
        notify "Màn hình: Mở rộng (Extend)" "Màn hình thứ hai là không gian làm việc mở rộng."
        ;;
    second)
        set_mon "${EXTERNAL},preferred,auto,1"
        set_mon "${INTERNAL},disable"
        notify "Màn hình: Chỉ màn hình thứ hai" "Second screen only — ${EXTERNAL}"
        ;;
esac

persist "$MODE"
