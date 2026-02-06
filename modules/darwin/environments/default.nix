{
  work = {
    packages = [
      "docker"
      "colima"
      "podman"
      "podman-compose"
      "glab"
    ];

    brews = [ ];

    casks = [
      "cloudflare-warp"
      "sdm"
      "mongodb-compass"
      "redis-insight"
    ];

    masApps = { };

    dockApps = [ ];

    sshIncludes = [ "~/.colima/ssh_config" ];

    # Additional agenix secrets for work environment
    ageSecrets = {
      hasAwsConfig = true;
    };
  };

  personal = {
    packages = [
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

    sshIncludes = [ "~/.orbstack/ssh/config" ];

    ageSecrets = {
      hasAwsConfig = false;
    };
  };
}
