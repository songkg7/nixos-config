{
  config,
  inputs,
  pkgs,
  profileConfig,
  ...
}:
let
  username = profileConfig.user.username;
in
{
  security.pam = {
    services.sudo_local.touchIdAuth = true;
  };

  security.sudo.extraConfig = ''
    Defaults timestamp_timeout=60
  '';

  users.users.${username} = {
    home = profileConfig.user.homeDirectory;
  };

  system.primaryUser = username;

  system.stateVersion = 6;

  nix-homebrew = {
    enable = true;
    user = config.system.primaryUser;
    package = inputs.brew-src // {
      name = "brew-6.0.9";
      version = "6.0.9";
    };
    autoMigrate = true;
    enableRosetta = pkgs.stdenv.isAarch64;
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
      "steipete/homebrew-tap" = inputs.homebrew-steipete;
      "antoniorodr/homebrew-memo" = inputs.homebrew-antoniorodr;
      "yakitrak/homebrew-yakitrak" = inputs.homebrew-yakitrak;
      "openhue/homebrew-cli" = inputs.homebrew-openhue;
      "getagentseal/homebrew-codeburn" = inputs.homebrew-codeburn;
      "stablyai/homebrew-orca" = inputs.homebrew-orca;
    };
    mutableTaps = true;
  };

  homebrew.taps = builtins.attrNames config.nix-homebrew.taps;

  determinateNix.customSettings = {
    keep-outputs = true;
    keep-derivations = true;
    download-buffer-size = "524288000";
  };

  imports = [
    ./programs/homebrew
    ./programs/macos-defaults
  ];
}
