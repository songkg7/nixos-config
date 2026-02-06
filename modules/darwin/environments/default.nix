{
  work = {
    packages = [
      # NOTE: business use only - from home.nix
      "docker"
      "colima"
      "podman"
      "podman-compose"
      "glab"
    ];

    brews = [
      # NOTE: business use only
    ];

    casks = [
      "cloudflare-warp"
      "sdm"
      "mongodb-compass"
      "redis-insight"
    ];

    masApps = { };

    dockApps = [ ];
  };

  personal = {
    packages = [
      # NOTE: personal use only - from home.nix
      "helix"
    ];

    brews = [ ];

    casks = [
      "adguard"
      "discord"
      "elgato-stream-deck"
      "notion"
      "notion-calendar"
      "orbstack"
      "telegram"
    ];

    masApps = {
      "KakaoTalk" = 869223134;
    };

    dockApps = [
      { app = "/Applications/Notion Calendar.app"; }
      { app = "/Applications/KakaoTalk.app"; }
      { app = "/Applications/Discord.app"; }
    ];
  };
}
