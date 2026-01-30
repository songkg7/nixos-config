# PROJECT KNOWLEDGE BASE

**Generated:** 2026-01-30 10:19 KST
**Commit:** efb4554
**Branch:** main

## OVERVIEW

Personal Nix flake for Darwin + Linux with Home Manager, shared program modules, and custom nixpkgs overlays.

## STRUCTURE

```
./
├── flake.nix                 # Entry point: systems + dev shell
├── modules/                  # shared + OS-specific modules
│   ├── shared/programs/      # shared Home Manager program modules
│   ├── darwin/               # macOS system + home modules
│   └── linux/                # Linux (WSL) system + home modules
├── libraries/                # reusable module libraries
│   ├── home-manager/         # shared HM modules + OS split
│   ├── nixpkgs/              # overlays + allowUnfree policy
│   └── dev-shell/            # devShell definition
├── lefthook.yml              # git hooks automation
└── secrets/                  # agenix-managed secrets
```

## WHERE TO LOOK

| Task                      | Location                                        | Notes                                      |
| ------------------------- | ----------------------------------------------- | ------------------------------------------ |
| Add shared program config | modules/shared/programs/<name>/default.nix      | default.nix aggregates per-program modules |
| Darwin system settings    | modules/darwin/configuration.nix                | nix-darwin module list in flake.nix        |
| Linux system settings     | modules/linux/configuration.nix                 | WSL settings + system services             |
| Home Manager packages     | modules/darwin/home.nix, modules/linux/home.nix | imports shared program modules             |
| Home Manager library      | libraries/home-manager/default.nix              | sharedModules + OS-specific modules        |
| Overlays/unfree policy    | libraries/nixpkgs/default.nix                   | overlays + allowUnfree list                |
| Dev shell tools           | libraries/dev-shell/default.nix                 | devShells.default in flake.nix             |
| Hook automation           | lefthook.yml                                    | pre-commit/pre-push commands               |

## CONVENTIONS (PROJECT-SPECIFIC)

- Formatter: `nixfmt-tree` via `nix fmt .` (flake formatter).
- Use `{ pkgs, ... }:` destructured inputs; `_:` for unused args.
- Prefer `default.nix` as module aggregator in program directories.
- Module flow: shared → darwin/linux → program-specific.

## ANTI-PATTERNS (THIS PROJECT)

- None explicitly documented in source comments.

## UNIQUE STYLES

- Home Manager shared modules live in `libraries/home-manager/` (not in `modules/`).
- Custom nixpkgs overlays live in `libraries/nixpkgs/`.
- Home Manager entry modules are `modules/darwin/home.nix` and `modules/linux/home.nix`.
- Git hooks enforced by lefthook (no CI workflows in repo).

## COMMANDS

```bash
nix flake check
nix flake check --all-systems
nix fmt .
alejandra .
deadnix --edit
nix develop
nix flake update
nix flake show
nixos-rebuild switch --flake '.#linux'
darwin-rebuild switch --flake '.#work'
darwin-rebuild switch --flake '.#personal'
nix build .#darwinConfigurations.work.system
```

## NOTES

- Pre-commit runs `deadnix --edit .` with auto-staging (lefthook).
- Pre-push runs `nix flake check --all-systems` + `deadnix .`.
