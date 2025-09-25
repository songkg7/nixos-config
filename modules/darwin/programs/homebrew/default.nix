{...}: {
  homebrew.enable = true;
  homebrew.onActivation.autoUpdate = true;
  homebrew.onActivation.cleanup = "uninstall";

  homebrew.taps = [
  ];

  homebrew.brews = [
    # NOTE: pakcages should be installed via nixpkgs whenever possible
  ];

  homebrew.casks = [
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
    "gureumkim"
    "karabiner-elements"
    "keycastr"
    "notion"
    "setapp"
    "warp"
    "telegram"
  ];

  homebrew.masApps = {
    "Amphetamine" = 937984704;
    "Bandizip" = 1265704574;
    "Encrypto" = 935235287;
    "KakaoTalk" = 869223134;
    "RunCat" = 1429033973;
    "ScreenBrush" = 1233965871;
  };
}
