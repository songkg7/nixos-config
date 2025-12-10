{ config, pkgs, ... }:
let
  # Determine if this is a Darwin system
  isDarwin = pkgs.stdenv.isDarwin;
  # Determine the home directory and username based on the system type
  homeDir = if isDarwin then "/Users" else "/home";
  username = if isDarwin && config.system ? primaryUser then config.system.primaryUser else "haril";
in
{
  nix = {
    optimise = {
      automatic = true;
    };
    settings = {
      substituters = [
        "https://cache.nixos.org"
      ];
      # trusted-public-keys = [
      #   "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      # ];
    };
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      experimental-features = nix-command flakes
    '';
  };

  age = {
    identityPaths = [ "${homeDir}/${username}/.ssh/agenix" ];
    secrets = {
      "mise.work.toml" = {
        file = ./secrets/mise-work-env.age;
        # FIXME: Use `config.age.secret.<name>.path` instead.
        path = "/${homeDir}/${username}/.config/mise/conf.d/mise.work.toml";
        owner = config.users.users.haril.name;
      };
      "mise.personal.toml" = {
        file = ./secrets/mise-personal-env.age;
        path = "/${homeDir}/${username}/.config/mise/conf.d/mise.personal.toml";
        owner = config.users.users.haril.name;
      };
    };
  };
}
