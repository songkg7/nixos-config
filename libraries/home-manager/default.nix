{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  inherit (pkgs.stdenvNoCC.hostPlatform) isDarwin isLinux;
in {
  home-manager.sharedModules = [
    # home-manager-secrets (nix flake input)
    # inputs.home-manager-secrets.homeManagerModules.home-manager-secrets

    # local programs (local)
    ./programs/1password
    # ./programs/cleanshot
    # ./programs/clop
    # ./programs/defaults
    # ./programs/hammerspoon
    # ./programs/homerow
    # ./programs/jq
    # ./programs/lsd

    # os systems
    (lib.mkIf isDarwin ./systems/darwin)
    (lib.mkIf isLinux ./systems/linux)
  ];
}
