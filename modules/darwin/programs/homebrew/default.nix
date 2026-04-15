{
  config,
  lib,
  profileConfig,
  ...
}:
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
    ++ profileConfig.darwin.homebrew.brews;

    casks = [
      "slack"
      "clop"
      "font-d2coding-nerd-font"
      "font-noto-sans-kr"
      "font-asta-sans"
      "hammerspoon"
      "input-source-pro"
      "ghostty"
      "karabiner-elements"
      "thaw"
      "loop"
      "raycast"
      "obsidian"
      "iina"
      "antigravity"
      "google-chrome"
      "zen"
      "spotify"
      "tailscale-app"
      "codex"
      "shottr"
      "cmux"
    ]
    ++ profileConfig.darwin.homebrew.desktopCasks
    ++ profileConfig.darwin.homebrew.casks;

    masApps = {
      # brew bundle + mas 6.x 호환성 문제로 전체 비활성화
      # "Amphetamine" = 937984704;
      # "Bandizip" = 1265704574;
      # "Encrypto" = 935235287;
      # "RunCat" = 1429033973;
      # "ScreenBrush" = 1233965871;
    }
    // profileConfig.darwin.homebrew.masApps;
  };
}
