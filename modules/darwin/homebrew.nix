{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  caskPresent = cask: lib.any (x: x.name == cask) config.homebrew.casks;
in {
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

  # Configuration related to casks
  home-manager.users.${config.users.primaryUser.username} =
    mkIf (caskPresent "1password" && config ? home-manager)
    {
      # https://developer.1password.com/docs/ssh/get-started
      programs.ssh.enable = true;
      programs.ssh.extraConfig = ''
        # Only set `IdentityAgent` not connected remotely via SSH.
        # This allows using agent forwarding when connecting remotely.
        Match host * exec "test -z $SSH_TTY"
          IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
      '';
    };
}
