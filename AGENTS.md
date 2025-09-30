# NixOS Configuration - Agent Guidelines

## Build/Lint/Test Commands
- `nix flake check` - Validate entire configuration
- `nix fmt .` or `alejandra .` - Format all Nix files  
- `nix develop` - Enter development shell with tools
- `deadnix --edit` - Remove unused Nix code
- `nix flake update` - Update dependencies
- `nixos-rebuild switch --flake '.#linux'` - Build Linux config
- `darwin-rebuild switch --flake '.#apple-darwin'` - Build macOS config

## Code Style Guidelines
- **Formatting**: Use `alejandra` (default formatter) for all Nix files
- **Attribute sets**: Use consistent spacing and indentation (2 spaces)
- **Imports**: Place at top, use `_:` for unused parameters
- **Comments**: Use `#` for comments, avoid inline unless necessary
- **Strings**: Use double quotes for strings, prefer interpolation over concatenation
- **Lists**: Use trailing commas for multi-line lists
- **Functions**: Use clear parameter naming, destructure inputs when helpful

## Naming Conventions
- **Files**: Use kebab-case for file/directory names (`default.nix`)
- **Attributes**: Use camelCase for attribute names
- **Variables**: Use descriptive names, avoid abbreviations

## Error Handling
- Always validate inputs in functions using assertions
- Use `lib.mkIf` for conditional configurations
- Prefer explicit error messages over silent failures