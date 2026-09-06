# PROJECT DIRECTORY STRUCTURE

*Attention Agent: You MUST update this file whenever you create, move, or delete files within the project to keep the tree accurate.*

## Current Tree (dev branch)
```text
Matrix/                      # dotfiles repository (deployed to ~/.config/ by install.sh)
├── AGENT.md
├── TASK.md
├── DOC.md
├── Struc.md
├── install.sh               # distro-aware installer (--deps installs packages on Arch/CachyOS)
├── hypr/
│   ├── hyprland.conf
│   ├── scripts/
│   │   └── multi-display.sh # Super+P display mode switcher (PC only / Duplicate / Extend / Second screen only)
│   └── configs/
│       ├── env.conf
│       ├── monitors.conf
│       ├── displays.conf    # display state written by multi-display.sh (deployed default = auto-detect)
│       ├── keybinds.conf
│       ├── windowrules.conf
│       ├── appearance.conf
│       └── autostart.conf
├── waybar/
│   ├── config.jsonc
│   └── style.css
├── rofi/
│   ├── config.rasi
│   └── colors.rasi
└── dunst/
    └── dunstrc
```

## Deployment
`install.sh` copies the files above into `~/.config/` mirroring this layout (scripts get the executable bit). It is idempotent and non-destructive: it only creates missing directories and writes the 14 managed files; it never touches unrelated user files or other desktop environments' configuration. `--deps` additionally installs the required packages via pacman (Arch/CachyOS).

## Branches
- `dev` (default): this tree — polished, distro-agnostic release.
- `test`: frozen Linux Mint (MATE) test version; kept for reference only.
