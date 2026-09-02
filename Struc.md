# PROJECT DIRECTORY STRUCTURE

*Attention Agent: You MUST update this file whenever you create, move, or delete files within the project to keep the tree accurate.*

## Current Tree
```text
Matrix/                      # dotfiles repository (deployed to ~/.config/ by install.sh)
├── AGENT.md
├── TASK.md
├── DOC.md
├── Struc.md
├── install.sh
├── hypr/
│   ├── hyprland.conf
│   └── configs/
│       ├── env.conf
│       ├── monitors.conf
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
`install.sh` copies the files above into `~/.config/` mirroring this layout. It is idempotent and non-destructive: it only creates missing directories and writes the 12 managed files; it never touches unrelated user files or MATE configuration.
