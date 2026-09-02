# REFERENCE DOCUMENTATION & TECH STACK

## Approved Tech Stack (Strictly Enforced)
- **Window Manager:** Hyprland (Wayland)
- **Top Bar:** Waybar (Lightweight, C++)
- **App Launcher:** Rofi-wayland (Fork of Rofi for Wayland)
- **Wallpaper Daemon:** swaybg (Extremely low RAM footprint)
- **Notification Daemon:** Dunst
- **Terminal Emulator:** kitty (or `foot` if extreme memory saving is needed)
- **File Manager:** Thunar
- **Network Manager Applet:** nm-applet
- **Audio Control:** pavucontrol & pamixer / wpctl

## Banned Tech Stack (DO NOT USE due to 4GB RAM constraint)
- AGS (Aylur's GTK Shell) - Too heavy, JS/Node based.
- SwayNC - Too heavy compared to Dunst.
- swww / hyprpaper / mpvpaper - `swaybg` is strictly better for weak systems.
- Heavy Electron apps for system configuration.

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
