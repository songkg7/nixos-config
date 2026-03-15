{
  config,
  lib,
  pkgs,
  profileConfig,
  ...
}:
{
  imports = [
  ];
  wsl.enable = true;

  wsl.defaultUser = profileConfig.user.username;

  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 524288;
  };

  time.timeZone = "Asia/Seoul";

  networking = {
    # networking.hostName = "nixos";
    nameservers = lib.mkIf (!config.wsl.enable) [
      "1.1.1.1"
      "1.0.0.1"
    ];
  };

  services.pulseaudio.enable = true;
  services.tailscale.enable = true;

  security.sudo.enable = true;
  programs.dconf.enable = true;

  users.users.${profileConfig.user.username} = {
    shell = pkgs.bashInteractive;
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
    ];
  };

  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };

  programs.ssh.startAgent = true;
  programs.nix-ld.enable = true;

  environment.systemPackages = [
    pkgs.ghostty.terminfo
  ];

  nix.settings = {
    keep-outputs = true;
    keep-derivations = true;
    download-buffer-size = 524288000;
  };

  system.stateVersion = "25.11";
}
