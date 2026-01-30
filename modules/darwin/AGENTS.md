# DARWIN MODULES

**Generated:** 2026-01-30 10:19 KST

## OVERVIEW

macOS system (nix-darwin) and Home Manager entry modules.

## STRUCTURE

```
./
├── configuration.nix     # system-level nix-darwin settings
├── home.nix              # Home Manager packages + imports
└── programs/             # macOS-only program modules
    ├── homebrew/
    ├── macos-defaults/
    ├── aerospace/
    └── ssh/
```

## WHERE TO LOOK

| Task                  | Location                            | Notes                               |
| --------------------- | ----------------------------------- | ----------------------------------- |
| System defaults       | configuration.nix                   | includes nix-homebrew + PAM TouchID |
| Home Manager packages | home.nix                            | imports shared program modules      |
| Homebrew setup        | programs/homebrew/default.nix       | invoked from configuration.nix      |
| macOS defaults        | programs/macos-defaults/default.nix | system defaults tweaks              |
| macOS app config      | programs/<name>/default.nix         | per-app settings                    |

## CONVENTIONS

- Program modules live under `programs/<name>/default.nix` and are imported from configuration.nix.
- `home.nix` is the entry point for Home Manager on macOS.

## ANTI-PATTERNS

- None documented here.
