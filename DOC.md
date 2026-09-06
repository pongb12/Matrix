# REFERENCE DOCUMENTATION & TECH STACK

## Approved Tech Stack (Strictly Enforced)
- **Window Manager:** Hyprland (Wayland)
- **Top Bar:** Waybar (Lightweight, C++)
- **App Launcher:** Rofi with Wayland support (repo `rofi` ≥ 2.0 on Arch/CachyOS, or `rofi-wayland`)
- **Wallpaper Daemon:** swaybg (Extremely low RAM footprint)
- **Notification Daemon:** Dunst (also reports display-mode changes from Super+P)
- **Terminal Emulator:** kitty (or `foot` if extreme memory saving is needed)
- **File Manager:** Thunar
- **Network Manager Applet:** nm-applet
- **Audio Control:** pavucontrol & wpctl
- **Display Switching:** `hypr/scripts/multi-display.sh` — plain bash + hyprctl, rofi menu, dunst feedback (Super+P)

## Banned Tech Stack (DO NOT USE due to 4GB RAM constraint)
- AGS (Aylur's GTK Shell) - Too heavy, JS/Node based.
- Quickshell / any Qt-QML desktop shell (e.g. the stock caelestia shell) - Too heavy for the target machine. Caelestia is used for **visual inspiration only**, never as a dependency.
- SwayNC - Too heavy compared to Dunst.
- swww / hyprpaper / mpvpaper - `swaybg` is strictly better for weak systems.
- Heavy Electron apps for system configuration.

## Matrix Palette (caelestia-inspired, used across hypr/waybar/rofi/dunst)
```text
bg0      #0e1116   deep navy-black surfaces
bg1      #14181f   notification / pill background
bg2      #1d2430   hover / secondary surfaces
fg       #e6eaf2   primary text
fg-dim   #7d8899   muted text, inactive workspace dots
accent   #7ab3f5   soft sky-blue (active border, selected items)
accent2  #4a6fa5   border gradient tail
red      #ee7b93   muted volume, critical states
yellow   #ecd28b   warning states
```

## Animation Reference (Fast & Snappy)
Use these variables in `appearance.conf` for the `animations` section to ensure fluid feeling on weak GPUs:
```ini
bezier = overshot, 0.05, 0.9, 0.1, 1.05
bezier = smoothOut, 0.36, 0, 0.66, -0.56
bezier = smoothIn, 0.25, 1, 0.5, 1

animation = windows, 1, 3, overshot, slide
animation = windowsOut, 1, 3, smoothOut, slide
animation = border, 1, 3, default
animation = fade, 1, 2, smoothIn
animation = workspaces, 1, 3, overshot, slide
```
