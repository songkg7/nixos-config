{
  config,
  environment,
  pkgs,
  lib,
  ...
}:
{
  homebrew = {
    enable = true;
    user = config.system.primaryUser;
    onActivation.autoUpdate = true;
    onActivation.cleanup = "none";

    taps = lib.mkDefault [ ];

    # NOTE: pakcages should be installed via nixpkgs whenever possible
    brews = [
      "mole"
    ]
    ++ lib.optionals (environment == "work") [
      # NOTE: business use only
    ];

    casks = [
      # NOTE: common use
      "slack"
      "1password"
      "1password-cli"
      "clop"
      "cursor"
      "font-d2coding-nerd-font"
      "font-noto-sans-kr"
      "font-asta-sans"
      "hammerspoon"
      "input-source-pro"
      "ghostty"
      "karabiner-elements"
      "setapp"
      "warp"
      "jordanbaird-ice"
      "loop"
      "raycast"
      "neohtop"
      "obsidian"
      "iina"
      "antigravity"
      "google-chrome"
      "comet"
      "spotify"
      "tailscale-app"
      "conductor"
    ]
    ++ lib.optionals pkgs.stdenv.isAarch64 [
      # NOTE: Apple Silicon only
      "opencode-desktop"
      # "dayflow"
    ]
    ++ lib.optionals (environment == "work") [
      # NOTE: business use only
      "cloudflare-warp"
      "sdm"
      "mongodb-compass"
      "redis-insight"
    ]
    ++ lib.optionals (environment == "personal") [
      # NOTE: personal use only
      "adguard"
      "discord"
      "elgato-stream-deck"
      "notion"
      "notion-calendar"
      "orbstack"
      "telegram"
    ];

    masApps = {
      "Amphetamine" = 937984704;
      "Bandizip" = 1265704574;
      "Encrypto" = 935235287;
      "RunCat" = 1429033973;
      "ScreenBrush" = 1233965871;
    }
    // lib.optionalAttrs (environment == "personal") {
      "KakaoTalk" = 869223134;
    };
  };
}
