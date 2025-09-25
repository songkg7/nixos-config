{...}: {
  homebrew.enable = true;
  homebrew.onActivation.autoUpdate = true;
  homebrew.onActivation.cleanup = "uninstall";

  homebrew.taps = [
    "homebrew/cask"
    "homebrew/core"
  ];

  homebrew.brews = [
    # NOTE: pakcages should be installed via nixpkgs whenever possible
  ];

  homebrew.casks = [
    "slack"
    "1password"
    "1password-cli"
  ];

  homebrew.masApps = [
    # TODO: Amphetamine (ID: 937984704)
  ];
}
