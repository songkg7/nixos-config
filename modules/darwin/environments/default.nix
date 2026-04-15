{
  work = {
    packages = [
      "docker"
      "colima"
      "podman"
      "podman-compose"
      "glab"
      "databricks-cli"
      "acli"
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

    passwordManager = {
      desktopCasks = [
        "1password"
        "1password-cli"
      ];
      enableBitwardenCli = false;
      sshIdentityAgent = "~/Library/Group\\ Containers/2BUA8C4S2C.com.1password/t/agent.sock";
      sshAuthSock = null;
      gitSshProgram = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
    };

    sshRuntime = {
      backend = "password-manager";
      cacheTtlSshSeconds = null;
      identityAgent = null;
      identityFile = null;
      pinentry = null;
    };

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
      # brew bundle + mas 6.x 호환성 문제로 비활성화
      # "KakaoTalk" = 869223134;
    };

    dockApps = [
      { app = "/Applications/Notion Calendar.app"; }
      { app = "/Applications/KakaoTalk.app"; }
      { app = "/Applications/Discord.app"; }
    ];

    sshIncludes = [ "~/.orbstack/ssh/config" ];

    passwordManager = {
      desktopCasks = [ "bitwarden" ];
      enableBitwardenCli = true;
      sshIdentityAgent = null;
      sshAuthSock = null;
      gitSshProgram = null;
    };

    sshRuntime = {
      backend = "ssh-agent";
      cacheTtlSshSeconds = null;
      identityAgent = "$SSH_AUTH_SOCK";
      identityFile = "~/.ssh/personal_github_ed25519";
      pinentry = null;
    };

    ageSecrets = {
      hasAwsConfig = false;
    };
  };
}
