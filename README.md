# Matrix — Hyprland Dotfiles

A clean, lightweight, and modular Hyprland rice with a caelestia-inspired look,
built for low-end hardware and deployable as plain dotfiles into `~/.config/`
on **any distribution that can run Hyprland** (Arch Linux, CachyOS, EndeavourOS,
…). Tuned for 4 GB RAM-class machines with weak integrated graphics.

> **Branches:** `dev` is the active development branch (this one, the default).
> `test` preserves the old Linux Mint (MATE) test version and is frozen.

## Performance rules (baked into the configs)

- **No blur** and **no shadows** — the two most expensive compositor effects.
- Short, snappy animations (duration 2–3) to mask low framerates.
- Minimal background daemons; every autostart entry is optional at runtime.
- C/C++/Rust-based tools only — no JS/Qt-heavy UI stack (no AGS, no SwayNC,
  no Quickshell; no swww/hyprpaper — `swaybg` instead).

Expected idle RAM of the full GUI stack (Hyprland + waybar + dunst + swaybg):

| Component | Approx. RAM |
|---|---|
| Hyprland (compositor) | 250–450 MB |
| waybar | 30–60 MB |
| swaybg | ~10 MB |
| dunst | ~5 MB |
| **Total idle** | **≈ 500–900 MB** |

Tuning knobs if you need to go lower: `foot` instead of `kitty`, remove
`nm-applet` from `autostart.conf`, raise waybar module `interval` values.

## The headline feature: Multi-display (Super+P)

A Windows-style display mode picker. Press **Super+P** and choose from a rofi
menu (UI strings in Vietnamese):

| Mode | What it does |
|---|---|
| **1 · Chỉ màn hình máy tính** (PC screen only) | Laptop/PC screen on; projector/TV off. |
| **2 · Nhân bản** (Duplicate) | Identical content on both screens — the presentation mode. |
| **3 · Mở rộng** (Extend) | Second screen becomes an extended workspace; drag windows between screens — ideal for slides + notes. |
| **4 · Chỉ màn hình thứ hai** (Second screen only) | Laptop screen off; output only on projector/TV. |

The active mode is marked with `●` in the menu. The choice is applied live via
`hyprctl` and persisted to `~/.config/hypr/configs/displays.conf`, so it
survives reloads and re-login. Delete that file to return to full
auto-detection. If no second screen is connected, a notification tells you so.

Implementation: [hypr/scripts/multi-display.sh](hypr/scripts/multi-display.sh) — plain
bash + `hyprctl`, no daemons, nothing runs except while the menu is open.

## What's inside

```text
Matrix/
├── AGENT.md            # agent directives (persona, constraints, style rules)
├── TASK.md             # mission checklist
├── DOC.md              # approved/banned tech stack + palette reference
├── Struc.md            # directory structure spec (kept up to date)
├── install.sh          # distro-aware, idempotent, non-destructive installer
├── hypr/
│   ├── hyprland.conf   # thin entry point, only `source` lines
│   ├── scripts/
│   │   └── multi-display.sh    # Super+P display mode switcher
│   └── configs/
│       ├── env.conf        # Wayland env vars
│       ├── monitors.conf   # intentionally minimal — Hyprland auto-detects
│       ├── displays.conf   # display state written by Super+P switcher
│       ├── appearance.conf # gaps 4/8, 2px borders, rounding 8, blur+shadows off
│       ├── keybinds.conf   # SUPER keybinds incl. Super+P display picker
│       ├── windowrules.conf# float rules for Thunar dialogs, pavucontrol, PiP
│       └── autostart.conf  # exec-once: swaybg, dunst, waybar, nm-applet
├── waybar/
│   ├── config.jsonc    # "Floating Pill" layout + tray
│   └── style.css       # deep navy pills, sky-blue accent
├── rofi/
│   ├── config.rasi     # minimal drun launcher
│   └── colors.rasi     # caelestia-inspired flat theme
└── dunst/
    └── dunstrc         # small top-right notifications, flat look
```

## Localization

- **User-facing strings are in Vietnamese** (waybar tooltips/labels, rofi
  placeholder, display-mode menu and notifications, window rule titles):
  e.g. *"Tìm kiếm ứng dụng..."*, *"Sử dụng RAM"*, *"Âm lượng"*,
  *"Nhân bản"*.
- **Code comments, variable names, and logic are in English.**
- The system locale is **not** set from Hyprland — your distro manages
  `LANG`/`LC_*` as usual (set it once with `localectl`).

## Installation

### Arch Linux / CachyOS / other pacman distros

```bash
git clone https://github.com/pongb12/Matrix
cd Matrix
./install.sh --deps   # installs all packages via pacman (asks for sudo)
./install.sh          # deploys the 14 config files into ~/.config
```

### Any other Hyprland-capable distro

Install the dependencies listed below with your package manager, then run
`./install.sh` (config deployment works everywhere; only `--deps` is
pacman-specific).

To start the session, select **Hyprland** in your display manager at login.

## Dependencies

| Package | Role | Notes |
|---|---|---|
| `hyprland` | Window manager | |
| `waybar` | Status bar | |
| `rofi` | Launcher + display-mode menu | Needs Wayland support: `rofi -help \| grep -i wayland`. On Arch/CachyOS the repo `rofi` (≥ 2.0) or `rofi-wayland` both work. |
| `dunst` | Notifications | Also reports display-mode changes. |
| `swaybg` | Wallpaper daemon | |
| `kitty` | Terminal | `foot` works too (lighter) — edit `$terminal` in keybinds.conf. |
| `brightnessctl` `grim` `slurp` `wl-clipboard` | Brightness, screenshots, clipboard | |
| `jq` | Optional | Improves active-mode detection in the Super+P menu. |
| `pipewire` `wireplumber` | Audio | `wpctl` volume control. |

Optional: `thunar`, `pavucontrol`, `network-manager-applet`, a Nerd Font
(JetBrainsMono recommended), `noto-fonts`. If an optional app is missing, its
window rule / keybind simply has no effect.

## Keybinds (default)

| Keys | Action |
|---|---|
| `SUPER + Enter` | Terminal (kitty) |
| `SUPER + D` | App launcher (rofi) |
| `SUPER + P` | **Multi-display mode picker** |
| `SUPER + E` | File manager (Thunar, if installed) |
| `SUPER + Q` | Close window |
| `SUPER + F` | Fullscreen |
| `SUPER + Space` | Toggle floating |
| `SUPER + 1..9` | Switch workspace (`SHIFT` moves the window) |
| `SUPER + arrows` | Focus direction |
| `SUPER + M` | Exit Hyprland |
| `Print` / `Shift + Print` | Screenshot (full screen / selection via grim+slurp) |
| Volume / brightness keys | wpctl / brightnessctl |

## Wallpapers

`autostart.conf` launches `swaybg` with `~/Pictures/wallpaper.jpg` (fill mode).
Change the path there, or drop your own image at that location.

## Documentation map

- `AGENT.md` — role and hard constraints (performance, localization, style)
- `DOC.md` — approved and banned tech stack, caelestia-inspired palette
- `TASK.md` — mission checklist the repo was built from
- `Struc.md` — canonical directory structure (kept in sync automatically)
