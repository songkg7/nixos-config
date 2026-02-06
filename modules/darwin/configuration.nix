{
  config,
  inputs,
  pkgs,
  user-profile,
  ...
}:
let
  username = user-profile.username;
in
{
  security.pam = {
    services.sudo_local.touchIdAuth = true;
  };

  users.users.${username} = {
    home = "/Users/${username}";
  };

  system.primaryUser = username;

  system.stateVersion = 6;

  nix-homebrew = {
    enable = true;
    user = config.system.primaryUser;
    autoMigrate = true;
    enableRosetta = pkgs.stdenv.isAarch64;
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
      "steipete/tap" = inputs.homebrew-steipete;
      "antoniorodr/memo" = inputs.homebrew-antoniorodr;
      "yakitrak/yakitrak" = inputs.homebrew-yakitrak;
      "openhue/cli" = inputs.homebrew-openhue;
    };
    mutableTaps = true;
  };

  homebrew.taps = builtins.attrNames config.nix-homebrew.taps;

  imports = [
    ./programs/homebrew
    ./programs/macos-defaults
  ];
}
