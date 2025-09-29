{pkgs, ...}: let
  inherit (pkgs.stdenvNoCC) isAarch64 isAarch32;
in {
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.cleanup = "uninstall";

    taps = [
    ];

    brews = [
      # NOTE: pakcages should be installed via nixpkgs whenever possible
    ];

    casks = [
      "slack"
      "1password"
      "1password-cli"
      "adguard"
      "clop"
      "cursor"
      "font-d2coding-nerd-font"
      "font-noto-sans-kr"
      "font-asta-sans"
      "hammerspoon"
      "input-source-pro"
      "ghostty"
      "karabiner-elements"
      "notion"
      "setapp"
      "warp"

      # TODO: for work only
      "cloudflare-warp"
      "telegram"
      "mongodb-compass"
      "sdm"

      # TODO: personal use only
      "elgato-stream-deck"
    ];

    masApps = {
      "Amphetamine" = 937984704;
      "Bandizip" = 1265704574;
      "Encrypto" = 935235287;
      "KakaoTalk" = 869223134;
      "RunCat" = 1429033973;
      "ScreenBrush" = 1233965871;
    };
  };
}
