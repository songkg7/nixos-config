# NixOS Config

Personal Nix configuration supporting macOS (Darwin) and Linux systems with comprehensive dotfiles and development tools.

## 🚀 Features

### Core Functionality

- **Multi-platform support**: macOS (Apple Silicon) and Linux
- **Home Manager integration**: Unified user environment configuration
- **Development shell**: Pre-configured environment with formatters and linters

### Included Programs & Tools

- **Shell & Terminal**: Starship, Atuin, Zoxide, FZF
- **Development**: Git with Delta, GitHub CLI, Direnv, Mise
- **Editors**: Neovim with AstroNvim configuration
- **Utilities**: Bat, Yazi, JQ, Fonts configuration
- **macOS specific**: AeroSpace, Homebrew, Homerow
- **Security**: environment-aware 1Password and `gpg-agent` SSH/Git signing configuration
- **Vault CLI**: Bitwarden CLI enabled for `personal` and available for other profiles

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
nix build '.#darwinConfigurations.work.system'
nix build '.#darwinConfigurations.personal.system'
nix eval '.#nixosConfigurations.linux.config.system.stateVersion' # Local fallback when not building Linux on a macOS host
```

### Development Environment

```sh
nix develop
# Provides access to formatters, linters, and development tools
```

## 📁 Project Structure

```
├── flake.nix            # Main entry point + profileConfig normalization
├── modules/
│   ├── shared/
│   │   ├── configuration.nix # Shared system-level imports
│   │   └── programs/         # Cross-platform Home Manager modules
│   ├── darwin/           # macOS-specific settings
│   └── linux/            # Linux-specific settings
├── libraries/
│   ├── home-manager/     # Shared Home Manager wiring via sharedModules
│   ├── nixpkgs/          # Overlays + package policy
│   └── dev-shell/        # Development environment
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

### Password Manager Profiles

- `work` keeps `1password` and `1password-cli` for SSH agent and Git SSH signing.
- `personal` installs Bitwarden Desktop via Homebrew and enables the shared `programs.bitwarden-cli` module.
- `personal` keeps Bitwarden as the password manager, but runtime SSH auth and Git SSH signing go through `gpg-agent` only.
- `personal` shells rebind `GPG_TTY` and `SSH_AUTH_SOCK` to the local `gpg-agent` socket on every interactive zsh session. GUI login is not required for SSH/Git signing.
- `personal` uses `pinentry-curses` with an 8 hour SSH cache TTL. The first SSH/Git signing operation after a cold cache prompts on the current TTY, then stays quiet until the cache expires or `gpgconf --kill gpg-agent` is run.
- `gpg-personal-refresh` is available in `personal` interactive shells as a manual recovery step when a long-lived shell or multiplexer session needs its TTY and `SSH_AUTH_SOCK` rebound.
- If you rotate to a new signing/authentication key, update `flake.nix` and `secrets/allowed-signers.age` together after GitHub authentication/signing keys have been updated.
- `bwlogin`, `bwunlock`, `bwsync`, `bwlock`, and `bwlogout` are available whenever `programs.bitwarden-cli` is enabled.

## 📝 License

This project is [MIT Licensed](./LICENSE).
