{
  environment,
  pkgs,
  lib,
  ...
}:
{
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.cleanup = "uninstall";

    taps = [
    ];

    # NOTE: pakcages should be installed via nixpkgs whenever possible
    brews = [
      # https://tailscale.com/kb/1065/macos-variants
    ]
    ++ lib.optionals (environment == "work") [
      # NOTE: business use only
    ]
    ++ lib.optionals (environment == "personal") [
      # NOTE: personal use only
      "tailscale"
    ];

    casks = [
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
      "notion"
      "setapp"
      "warp"
      "telegram"
      "jordanbaird-ice"
      "loop"
      "raycast"
      "neohtop"
      "obsidian"
      "discord"
      "iina"
      "antigravity"
      "google-chrome"
    ]
    ++ lib.optionals pkgs.stdenv.isAarch64 [
      # NOTE: Apple Silicon only
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
      "elgato-stream-deck"
      "orbstack"
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
