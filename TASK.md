# PROJECT TASKS & MISSIONS

## Phase 1: Foundation & Structure
- [ ] Read `Struc.md` and generate the initial folder hierarchy inside `~/.config/`.
- [ ] Create a modular `hyprland.conf` that sources env variables, monitors, window rules, keybinds, and appearance.

## Phase 2: Core Hyprland Config (Low-Spec Focus)
- [ ] Write `configs/env.conf`: Set Wayland/Hyprland environment variables (optimized for general Wayland/Intel).
- [ ] Write `configs/appearance.conf`: Set Gaps (in: 4, out: 8), Borders (2px), and strict optimization (DISABLE blur, disable heavy shadows). Implement snappy Bezier curve animations (time: 2-3).
- [ ] Write `configs/keybinds.conf`: Standard SUPER/Windows keybinds for terminal (`kitty` or `foot`), app launcher, window closing, and workspace switching.
- [ ] Write `configs/windowrules.conf`: Add smart rules (e.g., float Thunar file picker, float pavucontrol, fix picture-in-picture).

## Phase 3: Minimalist Waybar (Vietnamese UI)
- [ ] Create `waybar/config.jsonc`: Implement a "Floating Pill" layout.
    - Modules: Workspaces, Clock/Date, RAM, CPU, Volume.
    - **L10n Task:** All tooltips and custom text must be in Vietnamese (e.g., instead of "Volume", use "Âm lượng", "RAM Usage" -> "Sử dụng RAM").
- [ ] Create `waybar/style.css`: Use transparent backgrounds for the bar, semi-transparent for pills (modules). Add subtle `:hover` effects without heavy GPU usage.

## Phase 4: App Launcher & Notifications
- [ ] Configure `rofi/config.rasi`: Create a lightweight, minimal search menu. Set placeholder text to "Tìm kiếm ứng dụng..." (Vietnamese).
- [ ] Configure `dunst/dunstrc`: Minimalist notification daemon. Set minimal geometry, no heavy shadows.

## Phase 5: Verification
- [ ] Review all generated files to ensure NO heavy components (`swww`, `ags`, `swaync`) were used.
- [ ] Ensure all user-facing strings are correctly localized to Vietnamese.
- [ ] Automatically update `Struc.md` to reflect the final generated project architecture.
