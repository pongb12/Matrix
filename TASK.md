# PROJECT TASKS & MISSIONS

Branch: `dev` — polished, distro-agnostic rewrite of the original Mint/MATE test version (frozen on `test`).

## Phase 1: Git restructure
- [x] Create `dev` from `main`, set `dev` as the default branch on GitHub.
- [x] Rename `main` to `test` (frozen Mint/MATE snapshot).

## Phase 2: Multi-display feature (Super+P)
- [x] Write `hypr/scripts/multi-display.sh`: rofi menu with 4 modes — PC screen only, Duplicate (mirror), Extend, Second screen only.
- [x] Apply modes live via `hyprctl keyword monitor`; persist choice to `configs/displays.conf` (sourced by `hyprland.conf`).
- [x] Graceful handling: single-screen notification, desktop-PC fallback (no eDP panel), Esc aborts.
- [x] Vietnamese notifications via dunstify/notify-send.
- [x] Rebind `SUPER+P` (was `pseudo`) to the switcher in `keybinds.conf`.

## Phase 3: Caelestia-inspired theme (no added weight)
- [x] Define the Matrix palette in `DOC.md` (deep navy surfaces + sky-blue accent).
- [x] `appearance.conf`: rounded corners (8), accent gradient border; blur/shadows stay off.
- [x] `waybar/style.css` + `config.jsonc`: navy pills, accent dots, tray module.
- [x] `rofi/colors.rasi`: matching flat theme (also styles the Super+P menu).
- [x] `dunst/dunstrc`: matching notification surfaces.

## Phase 4: Distro-agnostic packaging
- [x] Rewrite `install.sh`: deploys 14 managed files + executable script; `--deps` installs packages via pacman (Arch/CachyOS); other distros get a dependency list and config-only deploy.
- [x] Remove all Mint/MATE assumptions from configs (`env.conf`, `autostart.conf`, docs).

## Phase 5: Documentation
- [x] `README.md`: multi-distro positioning, dependencies table, keybinds incl. Super+P, RAM budget (≈500–900 MB idle), tuning knobs.
- [x] `AGENT.md` / `DOC.md`: branch context, banned stack (Quickshell explicitly), palette reference.
- [x] `Struc.md`: regenerated for the new tree.

## Phase 6: Verification
- [x] `bash -n` / shellcheck-style review of `install.sh` and `hypr/scripts/multi-display.sh`.
- [x] No banned components (`swww`, `ags`, `swaync`, Quickshell) anywhere.
- [x] All user-facing strings localized to Vietnamese.
- [x] `Struc.md` matches the final tree.
