{
  config,
  environment,
  lib,
  ...
}:
let
  envConfig = (import ../../environments).${environment};
in
{
  homebrew = {
    enable = true;
    user = config.system.primaryUser;
    onActivation.autoUpdate = true;
    onActivation.cleanup = "uninstall";

    taps = lib.mkDefault [ ];

    brews = [
      "mole"
    ]
    ++ envConfig.brews;

    casks = [
      "slack"
      "clop"
      "cursor"
      "font-d2coding-nerd-font"
      "font-noto-sans-kr"
      "font-asta-sans"
      "hammerspoon"
      "input-source-pro"
      "ghostty"
      "karabiner-elements"
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
      "opencode-desktop"
      "shottr"
    ]
    ++ envConfig.passwordManager.desktopCasks
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
