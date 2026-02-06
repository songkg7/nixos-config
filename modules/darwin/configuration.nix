{
  config,
  environment,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  security.pam = {
    services.sudo_local.touchIdAuth = true;
  };

  users.users.haril = {
    home = "/Users/haril";
  };

  system.primaryUser = "haril";

  system.stateVersion = 6;

  nix-homebrew = {
    enable = true;
    user = config.system.primaryUser;
    autoMigrate = true;
    enableRosetta = false;
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
    (import ./programs/homebrew {
      inherit
        config
        environment
        pkgs
        lib
        ;
    })
    (import ./programs/macos-defaults {
      inherit environment lib;
    })
  ];
}
