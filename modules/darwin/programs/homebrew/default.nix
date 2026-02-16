{ config
, environment
, pkgs
, lib
, ...
}:
let
  envConfig = (import ../../environments).${environment};
in
{
  homebrew = {
    enable = true;
    user = config.system.primaryUser;
    onActivation.autoUpdate = true;
    onActivation.cleanup = "none";

    taps = lib.mkDefault [ ];

    brews = [
      "mole"
    ]
    ++ envConfig.brews;

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
      "setapp"
      "warp"
      "thaw"
      "loop"
      "raycast"
      "neohtop"
      "obsidian"
      "iina"
      "antigravity"
      "google-chrome"
      "comet"
      "zen"
      "spotify"
      "tailscale-app"
      "conductor"
      "codex"

      # NOTE: just testing
      "kiro-cli"
    ]
    ++ lib.optionals pkgs.stdenv.isAarch64 [
      "opencode-desktop"
    ]
    ++ envConfig.casks;

    masApps = {
      "Amphetamine" = 937984704;
      "Bandizip" = 1265704574;
      "Encrypto" = 935235287;
      "RunCat" = 1429033973;
      "ScreenBrush" = 1233965871;
    }
    // envConfig.masApps;
  };
}
