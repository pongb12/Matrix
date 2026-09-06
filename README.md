<div align="center">

# Matrix

**A lightweight, caelestia-inspired Hyprland desktop — built for low-end hardware.**

*Plain dotfiles, no shell framework, no hidden daemons. Every running component is a small, auditable process.*

[![Hyprland](https://img.shields.io/badge/Hyprland-0.56%2B-7ab3f5)](https://hypr.land)
[![Branch](https://img.shields.io/badge/branch-dev-blue)](../../tree/dev)
[![Installer](https://img.shields.io/badge/install-bash%20%2B%20pacman-green)](install.sh)
[![Idle RAM](https://img.shields.io/badge/idle%20RAM-%E2%89%88500%E2%80%93900%20MB-important)](#performance)

**English** · [Tiếng Việt](README.vi.md)

</div>

---

## Overview

Matrix is a complete Hyprland session assembled from a deliberately small set of
C/C++/Rust components. It follows three engineering rules:

1. **Nothing heavy.** No blur, no shadows, no Qt/QML shell, no Electron. The
   compositor and the bar are the only long-running graphical processes.
2. **Nothing hidden.** The desktop is 14 plain config files and one bash script,
   deployed into `~/.config/`. What you read is what runs.
3. **Nothing that can brick your session.** The installer never deletes or
   overwrites anything except its own 14 managed files, and every autostart
   entry degrades gracefully if its binary is missing.

## Features

- **Hyprland** session with a modular config (`hyprland.conf` only sources
  `configs/*.conf`), rounded corners, 2 px accent borders, and short
  animations tuned for weak iGPUs.
- **Multi-display switching (`Super+P`)** — a Windows-style mode picker with
  four modes: *PC screen only*, *Duplicate*, *Extend*, *Second screen only*.
  Implemented in plain bash + `hyprctl`; the selected mode is persisted and
  restored on the next login.
- **Waybar** floating-pill status bar with tray, workspaces, clock, RAM/CPU and
  volume modules.
- **rofi** launcher and display-mode menu (rofi ≥ 2.0 includes native Wayland
  support).
- **dunst** notifications — also used for display-mode feedback.
- **swaybg** wallpaper, `wpctl` volume, `brightnessctl` backlight,
  `grim`+`slurp` screenshots.
- All user-facing strings are localized in **Vietnamese**.

## Requirements

| Package | Role |
|---|---|
| `hyprland` | Wayland compositor (≥ 0.56 recommended; config verified against 0.56.2) |
| `waybar` | Status bar |
| `rofi` | Launcher + display-mode menu (Wayland build required: rofi ≥ 2.0 or `rofi-wayland`) |
| `dunst` | Notification daemon |
| `swaybg` | Wallpaper daemon |
| `kitty` | Terminal (`foot` works as a lighter alternative — edit `$terminal` in `keybinds.conf`) |
| `brightnessctl`, `grim`, `slurp`, `wl-clipboard` | Backlight, screenshots, clipboard |
| `jq` | Optional — improves active-mode detection in the Super+P menu |
| `pipewire`, `wireplumber` | Audio (`wpctl`) |

Optional: `thunar`, `pavucontrol`, `network-manager-applet`, a Nerd Font
(JetBrainsMono recommended), `noto-fonts`. Missing optional packages only mean
the related keybind or window rule has no effect.

A Wayland-capable GPU and a display manager (SDDM, greetd, …) are assumed.

## Installation

### CachyOS

CachyOS supports Hyprland natively. Two paths, both ending with the same
Matrix deployment.

#### Path A — fresh CachyOS install (recommended)

1. Boot the CachyOS ISO and start the installer.
2. In the desktop-environment step either:
   - choose **Hyprland** (CachyOS ships its own shell on top of it — Matrix
     will replace the compositor config in step 4; the extra CachyOS shell
     packages such as `cachyos-hypr-noctalia` can be removed afterwards with
     `pacman -R cachyos-hypr-noctalia` if you want a pure Matrix setup), **or**
   - choose **No Desktop** for the cleanest, Matrix-only session.
3. Finish the install, reboot, and log in to a TTY (`Ctrl+Alt+F2`) if you
   chose "No Desktop".
4. Install the session stack:

   ```bash
   sudo pacman -S --needed hyprland waybar rofi dunst swaybg kitty \
     brightnessctl grim slurp wl-clipboard jq \
     pipewire wireplumber pipewire-pulse thunar pavucontrol \
     network-manager-applet ttf-jetbrainsmono-nerd noto-fonts
   ```

5. If you chose "No Desktop", enable a display manager (skip if CachyOS
   already installed one):

   ```bash
   sudo pacman -S --needed sddm
   sudo systemctl enable sddm
   ```

6. Deploy Matrix:

   ```bash
   git clone https://github.com/pongb12/Matrix.git
   cd Matrix
   ./install.sh
   ```

7. Put a wallpaper at `~/Pictures/wallpaper.jpg` (or change the path in
   `hypr/configs/autostart.conf`), then reboot — **Hyprland** appears as a
   session in SDDM.

#### Path B — existing CachyOS with another desktop

```bash
sudo pacman -S --needed hyprland waybar rofi dunst swaybg kitty \
  brightnessctl grim slurp wl-clipboard jq pipewire wireplumber
git clone https://github.com/pongb12/Matrix.git
cd Matrix
./install.sh
```

Log out and pick **Hyprland** in your display manager. Your existing desktop
is untouched — Matrix only writes its own 14 files.

#### One-command variant

On any pacman-based system (CachyOS, Arch, EndeavourOS), `--deps` performs
step 4 automatically before deploying:

```bash
git clone https://github.com/pongb12/Matrix.git && cd Matrix
./install.sh --deps   # installs the packages via pacman (asks for sudo)
./install.sh          # deploys the configs
```

### Other Arch-based distributions

Same as Path B. The only Arch-specific assumption is the `pacman` package
names; every config file is distro-agnostic.

### Other distributions (non-pacman)

Install the packages from [Requirements](#requirements) with your package
manager, then run `./install.sh` (config deployment works everywhere; only
`--deps` is pacman-specific).

### Uninstall

Remove the deployed files — nothing else was ever written:

```bash
rm -rf ~/.config/hypr ~/.config/waybar ~/.config/rofi ~/.config/dunst
rm -rf ~/.local/state/matrix   # display-mode state, if present
```

## Usage

### Keybinds

| Keys | Action |
|---|---|
| `SUPER + Enter` | Terminal |
| `SUPER + D` | App launcher |
| `SUPER + P` | **Display-mode picker** |
| `SUPER + E` | File manager (if installed) |
| `SUPER + Q` | Close window |
| `SUPER + F` | Fullscreen |
| `SUPER + Space` | Toggle floating |
| `SUPER + J` | Toggle split |
| `SUPER + 1..9` | Workspace (`SHIFT` moves the focused window) |
| `SUPER + arrows` | Move focus |
| `SUPER + mouse buttons` | Move / resize windows |
| `Print` / `Shift + Print` | Screenshot (full / selection) |
| Volume / brightness keys | `wpctl` / `brightnessctl` |
| `SUPER + M` | Exit Hyprland |

### Multi-display (Super+P)

| Mode | Effect |
|---|---|
| **1 · Chỉ màn hình máy tính** | PC screen only — external display off |
| **2 · Nhân bản** | Duplicate — identical picture on both screens (presentations) |
| **3 · Mở rộng** | Extend — the second display becomes additional workspace |
| **4 · Chỉ màn hình thứ hai** | Second screen only — laptop panel off |

The active mode is marked with `●`. The choice is applied live and persisted
to `~/.config/hypr/configs/displays.conf`; delete that file to return to
auto-detection. With no second display connected, a notification says so.

## Performance

Idle RAM of the full GUI stack (compositor + bar + notifications + wallpaper):

| Component | Approx. RAM |
|---|---|
| Hyprland | 250–450 MB |
| waybar | 30–60 MB |
| swaybg | ~10 MB |
| dunst | ~5 MB |
| **Total idle** | **≈ 500–900 MB** |

Baked-in rules: `blur` and `shadows` disabled, animation durations 2–3,
minimal autostart. To go lower: use `foot` instead of `kitty`, remove
`nm-applet` from `autostart.conf`, raise the waybar `interval` values.

## Troubleshooting

- **Launcher or Super+P menu does not open** — your rofi has no Wayland
  support. Check with `rofi -help | grep -i wayland`; on Arch/CachyOS install
  `rofi` (≥ 2.0) or `rofi-wayland`.
- **Where are the logs?** Hyprland writes to
  `/run/user/$UID/hypr/*/hyprland.log`. A crashed session leaves a report in
  `~/.cache/hyprland/`.
- **A config line is invalid after a Hyprland update** — Hyprland keeps
  running and draws an error overlay instead of failing to start. Check the
  log line beginning with `ERR` and adjust; the session is otherwise usable.
- **Display-mode changes did not persist** — verify
  `~/.config/hypr/configs/displays.conf` exists; it is rewritten on every
  Super+P selection.
- **Wrong monitor name in the picker** — names are detected at runtime from
  `hyprctl monitors` (`eDP-*` = internal panel, everything non-`HEADLESS` is
  treated as external), so there is nothing to configure.

## Branches

| Branch | Purpose |
|---|---|
| [`dev`](../../tree/dev) | Active development; the release configuration (this branch) |
| [`test`](../../tree/test) | Historical snapshot of the original Mint/MATE test version — frozen, do not use |
