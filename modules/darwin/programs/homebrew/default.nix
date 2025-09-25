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
  ];

  homebrew.masApps = {
    # TODO: Amphetamine (ID: 937984704)
  };
}
