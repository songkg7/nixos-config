{
  profileConfig,
  ...
}:
{
  system.defaults = {
    dock = {
      tilesize = 40;
      autohide = true;
      expose-group-apps = true;
      show-recents = false;
      persistent-apps = [
        { app = "/Applications/Spotify.app"; }
        # { app = "/Applications/Warp.app"; }
      ]
      ++ profileConfig.darwin.dockApps;
      persistent-others = [
        { folder = "${profileConfig.user.homeDirectory}/Downloads"; }
      ];
    };
    spaces = {
      spans-displays = true;
    };
    NSGlobalDomain = {
      ApplePressAndHoldEnabled = false;
      "com.apple.keyboard.fnState" = true;
      KeyRepeat = 1;
    };
    CustomUserPreferences = {
      "kCFPreferencesAnyApplication" = {
        TSMLanguageIndicatorEnabled = 0;
      };
    };
  };
}
