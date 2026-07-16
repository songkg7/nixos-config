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
      "agent-browser"
      "mole"
      "getagentseal/codeburn/codeburn"
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
      # "iina"
      "antigravity"
      "google-chrome"
      "zen"
      "spotify"
      "codex"
      "stablyai/orca/orca"
      "shottr"
      "cmux"
    ]
    ++ profileConfig.darwin.homebrew.desktopCasks
    ++ profileConfig.darwin.homebrew.casks;

    masApps = {
      "Amphetamine" = 937984704;
      "Bandizip" = 1265704574;
      "Encrypto" = 935235287;
      "RunCat Neo" = 6757801838;
      "ScreenBrush" = 1233965871;
    }
    // profileConfig.darwin.homebrew.masApps;
  };
}
