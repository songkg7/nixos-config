# LINUX MODULES

**Generated:** 2026-01-30 10:19 KST

## OVERVIEW

Linux (WSL) system configuration and Home Manager entry modules.

## STRUCTURE

```
./
├── configuration.nix     # system-level NixOS/WSL settings
├── home.nix              # Home Manager packages + imports
└── programs/             # Linux-only program modules
    ├── wayland/
    ├── input-method/
    ├── theme/
    └── zpl-open/
```

## WHERE TO LOOK

| Task                  | Location                     | Notes                          |
| --------------------- | ---------------------------- | ------------------------------ |
| WSL/system settings   | configuration.nix            | wsl.enable, docker, tailscale  |
| Home Manager packages | home.nix                     | imports shared program modules |
| Wayland setup         | programs/wayland/default.nix | imports sway/rofi submodules   |
| Linux-only features   | programs/<name>/default.nix  | per-feature modules            |

## CONVENTIONS

- Program modules live under `programs/<name>/default.nix` and are imported from home.nix or configuration.nix.
- `home.nix` is the Home Manager entry point for Linux.

## ANTI-PATTERNS

- None documented here.
