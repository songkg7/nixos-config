{...}: {
  imports = [
    ./programs/homebrew
  ];

  system.defaults.dock = {
    autohide = true;
    tilesize = 40;
    show-recents = false;
    persistent-apps = [
      "/System/Applications/Calendar.app"
      "/System/Applications/Music.app"
      "/Applications/Slack.app"
      "/Applications/Telegram.app"
      "/Applications/Warp.app"
      "/Applications/KakaoTalk.app"
    ];
    persistent-others = [
      {
        path = "/Users/a14530/Downloads";
        options = {
          "show-as" = "fan";
          "display-as" = "stack";
        };
      }
    ];
  };

  # Disable nix-darwin's Nix management to work with Determinate
  security.pam = {
    services.sudo_local.touchIdAuth = true;
  };

  users.users.haril = {
    home = "/Users/haril";
  };

  system.primaryUser = "haril";

  system.stateVersion = 6;
}
