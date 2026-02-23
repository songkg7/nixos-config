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
- **macOS specific**: AeroSpace, Homebrew, Homerow
- **Security**: 1Password, GPG configuration

## 📋 Prerequisites

Install Nix using the Determinate installer (includes flakes support):

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

**macOS Notes:** `nix-homebrew` manages Homebrew (no manual install required). `masApps` requires being signed into the App Store.

Install Xcode Command Line Tools (macOS):

```sh
xcode-select --install
```

## 🛠 Installation

### Linux (NixOS)

```sh
nixos-rebuild switch --flake '.#linux' --sudo
```

### macOS (Darwin)

```sh
# For Apple Silicon Macs (Work)
nix build '.#darwinConfigurations.work.system'
sudo ./result/sw/bin/darwin-rebuild switch --flake '.#work'

# For Apple Silicon Macs (Personal)
nix build '.#darwinConfigurations.personal.system'
sudo ./result/sw/bin/darwin-rebuild switch --flake '.#personal'

# For Intel Macs (Personal)
nix build '.#darwinConfigurations.personal-intel.system'
sudo ./result/sw/bin/darwin-rebuild switch --flake '.#personal-intel'
```

After switching, initialize dotfiles with Chezmoi:

```sh
chezmoi init songkg7 --apply
```

## 🔄 Updates & Maintenance

### Update Dependencies

```sh
nix flake update
```

### Format Code

```sh
nix fmt .
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

| Command           | Description             |
| ----------------- | ----------------------- |
| `nix develop`     | Enter development shell |
| `nix flake show`  | Show available outputs  |
| `nix flake check` | Validate configuration  |
| `nix fmt .`       | Format Nix files        |
| `deadnix --edit`  | Remove unused code      |

## ⚙️ Additional Configuration

### GPG Setup

- Import GPG keys and enable iCloud sync for secure key management

## 📝 License

This project is [MIT Licensed](./LICENSE).
