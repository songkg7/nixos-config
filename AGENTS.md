# NixOS Configuration - Agent Guidelines

## Build/Lint/Test Commands
- `nix flake check` - Validate entire configuration (single "test" for flakes)
- `nix flake check --all-systems` - Validate for all supported systems
- `nix fmt .` - Format all Nix files (uses `nixfmt-tree` as default formatter)
- `alejandra .` - Alternative formatter (available in dev shell)
- `deadnix --edit` - Remove unused Nix code automatically
- `nix develop` - Enter development shell with tools
- `nix flake update` - Update all dependencies
- `nix flake show` - Show available configurations and outputs
- `nixos-rebuild switch --flake '.#linux'` - Build/apply Linux config
- `darwin-rebuild switch --flake '.#work'` or `'.#personal'` - Build/apply macOS configs
- `nix build .#darwinConfigurations.work.system` - Build without applying (test build)

## Git Hooks & Automation
- Pre-commit hooks automatically run `nix flake check --all-systems` and `deadnix --edit`
- Hooks configured via lefthook (lefthook.yml)

## Code Style Guidelines
- **Formatting**: Use `nixfmt-tree` (default formatter set in flake.nix)
- **Indentation**: 2 spaces, no tabs
- **Imports**: Place at top, group logically, use `_:` for unused function parameters  
- **Attribute sets**: Use consistent spacing, prefer `{ }` over `rec { }` when possible
- **Functions**: Use destructured inputs `{ pkgs, ... }:`, clear parameter names
- **Strings**: Use double quotes, prefer interpolation `"${var}"` over concatenation
- **Lists**: Use trailing commas for multi-line lists, align items vertically
- **Comments**: Use `#` for comments, document complex logic, avoid inline comments

## Naming Conventions & Structure
- **Files**: Use kebab-case (`default.nix`, `ssh-config.nix`)
- **Directories**: Follow kebab-case pattern (`home-manager/`, `dev-shell/`)
- **Attributes**: Use camelCase for Nix attributes
- **Variables**: Use descriptive names, avoid abbreviations
- **Module structure**: Use `default.nix` files to aggregate related modules

## Error Handling & Best Practices
- Use `lib.mkIf` for conditional configurations
- Validate inputs with assertions when needed
- Prefer explicit over implicit configurations
- Follow the existing module pattern: shared → darwin/linux → specific programs