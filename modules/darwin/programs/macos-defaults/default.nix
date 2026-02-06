{
  environment,
  user-profile,
  ...
}:
let
  username = user-profile.username;
  envConfig = (import ../../environments).${environment};
in
{
  system.defaults = {
    dock = {
      tilesize = 40;
      autohide = true;
      expose-group-apps = true;
      show-recents = false;
      persistent-apps = [
        { app = "/Applications/Spotify.app"; }
        { app = "/Applications/Warp.app"; }
      ]
      ++ envConfig.dockApps;
      persistent-others = [
        { folder = "/Users/${username}/Downloads"; }
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
