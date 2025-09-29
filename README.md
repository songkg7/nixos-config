# NixOS Config

Personal nix files, installs some dotfiles and softwares.

## Installation

```sh
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)
```

```sh
# Linux
$ nixos-rebuild switch --flake '.#linux' --sudo

# Darwin
$ nix --experimental-features 'nix-command flakes' build '.#darwinConfigurations.darwin.system'
$ sudo ./result/sw/bin/darwin-rebuild switch --flake '.#darwin'
```

## Update (flake lock, custom packages)

```sh
$ nix flake update --flake .
fetching ...
```

## Additional steps

- Enable iCloud configuration for gpg

## License

NixOS Config is [MIT Licensed](./LICENSE).

