# AGENTS.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Rebuild Commands

```bash
# Linux (NixOS/WSL)
nixos-rebuild switch --flake '.#linux' --sudo

# macOS - Work (Apple Silicon)
nix build '.#darwinConfigurations.work.system'
sudo ./result/sw/bin/darwin-rebuild switch --flake '.#work'

# macOS - Personal (Apple Silicon)
nix build '.#darwinConfigurations.personal.system'
sudo ./result/sw/bin/darwin-rebuild switch --flake '.#personal'

# macOS - Personal (Intel)
nix build '.#darwinConfigurations.personal-intel.system'
sudo ./result/sw/bin/darwin-rebuild switch --flake '.#personal-intel'
```

## Validation & Development

```bash
nix flake check              # Validate configuration
nix flake check --all-systems # Check all platforms
nix fmt .                     # Format with nixfmt-tree
deadnix --edit .              # Remove unused code
nix develop                   # Enter dev shell with formatters/linters
nix flake update              # Update dependencies
```

## Architecture

Multi-platform Nix flake supporting macOS (Darwin) and Linux with Home Manager integration.

### System Configurations

| Name | Platform | Use Case |
|------|----------|----------|
| `work` | aarch64-darwin | Apple Silicon work environment |
| `personal` | aarch64-darwin | Apple Silicon personal |
| `personal-intel` | x86_64-darwin | Intel Mac personal |
| `linux` | x86_64-linux | NixOS/WSL personal |

### Module Organization

- **`modules/shared/programs/`** - Cross-platform program configs (imported by both Darwin and Linux)
- **`modules/darwin/`** - macOS system settings, homebrew, home.nix
- **`modules/linux/`** - Linux/WSL system settings, home.nix
- **`libraries/home-manager/`** - Reusable Home Manager modules (sharedModules)
- **`libraries/nixpkgs/`** - Overlays and allowUnfree policy
- **`libraries/dev-shell/`** - Development shell definition

### Key Files

| Task | Location |
|------|----------|
| Add shared program | `modules/shared/programs/<name>/default.nix` |
| Darwin system settings | `modules/darwin/configuration.nix` |
| Linux system settings | `modules/linux/configuration.nix` |
| macOS packages & imports | `modules/darwin/home.nix` |
| Linux packages & imports | `modules/linux/home.nix` |
| Custom packages/overlays | `libraries/nixpkgs/default.nix` |
| HM shared modules | `libraries/home-manager/default.nix` |

## Conventions

- **Formatter**: `nixfmt-tree` via `nix fmt .`
- **Module pattern**: Each program gets `programs/<name>/default.nix` which aggregates feature modules
- **Unused args**: Use `_:` for unused function arguments
- **Module flow**: shared → darwin/linux → program-specific
- **Environment split**: Use `lib.optionals (environment == "work")` pattern in home.nix for work/personal differences

## Git Hooks (lefthook)

- **pre-commit**: Runs `deadnix --edit .` with auto-staging
-
