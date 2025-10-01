# NixOS Config

Personal Nix configuration supporting macOS (Darwin) and Linux systems with comprehensive dotfiles and development tools.

## 🚀 Features

### Core Functionality
- **Multi-platform support**: macOS (Intel/Apple Silicon) and Linux
- **Home Manager integration**: Unified user environment configuration
- **Development shell**: Pre-configured environment with formatters and linters

### Included Programs & Tools
- **Shell & Terminal**: Starship, Atuin, Zoxide, FZF
- **Development**: Git with Delta, GitHub CLI, Direnv, Mise
- **Editors**: Neovim with AstroNvim configuration
- **Utilities**: Bat, Ranger, JQ, Fonts configuration
- **AI Tools**: OpenCode with custom agents, Gemini CLI
- **macOS specific**: AeroSpace, Homebrew, Homerow
- **Security**: 1Password, GPG configuration

## 📋 Prerequisites

Install Nix with flakes support:

```sh
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)
```

## 🛠 Installation

### Linux (NixOS)
```sh
nixos-rebuild switch --flake '.#linux' --sudo
```

### macOS (Darwin)
```sh
# For Apple Silicon Macs (Work)
nix --experimental-features 'nix-command flakes' build '.#darwinConfigurations.work.system'
sudo ./result/sw/bin/darwin-rebuild switch --flake '.#work'

# For Intel Macs (Personal)
nix --experimental-features 'nix-command flakes' build '.#darwinConfigurations.personal.system'
sudo ./result/sw/bin/darwin-rebuild switch --flake '.#personal'
```

## 🔄 Updates & Maintenance

### Update Dependencies
```sh
nix flake update
```

### Format Code
```sh
nix fmt .
# or use alejandra directly
alejandra .
```

### Validate Configuration
```sh
nix flake check
```

### Development Environment
```sh
nix develop
# Provides access to formatters, linters, and development tools
```

## 📁 Project Structure

```
├── modules/
│   ├── shared/           # Cross-platform configurations
│   │   └── programs/     # Application configurations
│   ├── darwin/           # macOS-specific settings
│   └── linux/            # Linux-specific settings
├── libraries/
│   ├── home-manager/     # Home Manager modules
│   ├── nixpkgs/          # Custom packages
│   └── dev-shell/        # Development environment
└── flake.nix            # Main configuration entry point
```

## 🎯 Key Commands

| Command | Description |
|---------|-------------|
| `nix develop` | Enter development shell |
| `nix flake show` | Show available outputs |
| `nix flake check` | Validate configuration |
| `nix fmt .` | Format Nix files |
| `deadnix --edit` | Remove unused code |

## ⚙️ Additional Configuration

### GPG Setup
- Import GPG keys and enable iCloud sync for secure key management

### OpenCode AI Agents
This configuration includes custom AI agents:
- **Code Reviewer**: Specialized in code quality and security reviews
- **Documentation**: Focused on creating clear, comprehensive documentation

## 📝 License

This project is [MIT Licensed](./LICENSE).

