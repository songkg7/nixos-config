{
  ...
}:
{
  # Dock is managed as a fixed list and may overwrite manual changes.
  system.defaults = {
    dock = {
      tilesize = 40;
      autohide = true;
      expose-group-apps = true;
      show-recents = false;
      persistent-apps = [
        { app = "/Applications/Notion Calendar.app"; }
        { app = "/Applications/Spotify.app"; }
        { app = "/Applications/KakaoTalk.app"; }
        { app = "/Applications/Discord.app"; }
        { app = "/Applications/Warp.app"; }
      ];
      persistent-others = [
        { folder = "/Users/haril/Downloads"; }
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
