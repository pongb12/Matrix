# Matrix — Hyprland Dotfiles

A clean, lightweight, and modular Hyprland rice, built for low-end hardware and
deployed as plain dotfiles into `~/.config/`.

> **This is a dotfiles repository — not an OS/distribution project.** No installer
> images, no system architecture, no distro building. Just config files and a
> small deployment script.

## Purpose

Matrix is an **experimental Hyprland session** for a machine that runs
**Linux Mint with MATE as the primary desktop environment**. MATE is never
touched, replaced, or disabled — if the Hyprland session breaks, the system
stays fully usable through MATE.

## Target hardware

The rice is tuned for weak machines and verified against:

| Component | Spec |
|---|---|
| CPU | Intel Pentium Silver N5030 |
| GPU | Intel UHD Graphics 605 |
| RAM | 4 GB |

Performance rules baked into the configs:

- **No blur** (`blur { enabled = false }`)
- **No shadows** (`shadow { enabled = false }`)
- Short, snappy animations (duration 2–3) to mask low framerates
- Minimal background daemons
- C/C++/Rust-based tools only — no JS/Electron UI stack (no AGS, no SwayNC,
  no swww/hyprpaper — `swaybg` instead)

## What's inside

```text
Matrix/
├── AGENT.md            # agent directives (persona, constraints, style rules)
├── TASK.md             # mission checklist
├── DOC.md              # approved/banned tech stack reference
├── Struc.md            # directory structure spec (kept up to date)
├── install.sh          # idempotent, non-destructive deployment script
├── hypr/
│   ├── hyprland.conf   # thin entry point, only `source` lines
│   └── configs/
│       ├── env.conf        # Wayland env vars (no locale forcing, no AQ_DRM_DEVICES)
│       ├── monitors.conf   # intentionally minimal — Hyprland auto-detects displays
│       ├── appearance.conf # gaps 4/8, 2px borders, blur+shadows off, fast animations
│       ├── keybinds.conf   # SUPER keybinds, wpctl/brightnessctl/grim+slurp
│       ├── windowrules.conf# float rules for Thunar dialogs, pavucontrol, PiP
│       └── autostart.conf  # exec-once: swaybg, dunst, waybar
├── waybar/
│   ├── config.jsonc    # "Floating Pill" layout
│   └── style.css       # transparent bar, semi-transparent pills, cheap hover
├── rofi/
│   ├── config.rasi     # minimal drun launcher
│   └── colors.rasi     # Nord-based flat theme
└── dunst/
    └── dunstrc         # small top-right notifications, flat look
```

## Localization

- **User-facing strings are in Vietnamese** (Waybar tooltips/labels, Rofi
  placeholder, window rule titles): e.g. *"Tìm kiếm ứng dụng..."*,
  *"Sử dụng RAM"*, *"Âm lượng"*.
- **Code comments, variable names, and logic are in English.**
- The system locale is **not** set from Hyprland — Linux Mint manages `LANG`/
  `LC_*` as usual.

## Installation

```bash
git clone <repo-url> Matrix
cd Matrix
./install.sh
```

The script:

1. Creates any missing target directories under `~/.config/`
2. Copies **only** the 12 managed files listed in `MANAGED_FILES`
3. Never removes, renames, or touches anything else — no MATE config, no
   unrelated user files
4. Is fully idempotent: re-running produces the same result with no
   accumulation

To actually use the session, select **Hyprland** from your display manager at
login (MATE remains the default).

## Dependencies

Required for the Hyprland session:

```text
hyprland  waybar  rofi  dunst  swaybg  kitty
wpctl (wireplumber)  brightnessctl  grim  slurp
```

Notes:

- **Rofi must support Wayland.** Check your installed build with
  `rofi -help | grep -i wayland` before assuming it works. Do **not** add
  third-party PPAs just to get Wayland support.
- `pamixer` is deliberately **not** used — volume control goes through `wpctl`.

Optional (config works fine without them):

```text
thunar  pavucontrol  nm-applet
```

If an optional app is missing, its window rule / keybind simply has no effect.

## Keybinds (default)

| Keys | Action |
|---|---|
| `SUPER + Enter` | Terminal (kitty) |
| `SUPER + D` | App launcher (rofi) |
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
- `DOC.md` — approved and banned tech stack
- `TASK.md` — mission checklist the repo was built from
- `Struc.md` — canonical directory structure (kept in sync automatically)
