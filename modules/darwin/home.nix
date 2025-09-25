{
  config,
  pkgs,
  inputs,
  ...
}: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";
  home-manager.users.haril = {config, ...}: {
    home.username = "haril";
    home.homeDirectory = "/Users/haril";

    home.packages = with pkgs; [
      # Development
      # google-cloud-sdk
      # jetbrains.datagrip
      # jetbrains.idea-ultimate
      jetbrains-toolbox

      # Cloud and DevOps
      k9s
      # databricks-cli
      # copilot-cli

      # Utility
      ripgrep
      fd
      fx
      jq
      htop
      neohtop
      lazydocker
      lazygit
      lsd
      alt-tab-macos
      # TODO: find trash-cli alternatives
      walk
      tldr
      ice-bar
      loopwm
      obsidian
      raycast
      slack
      aerospace
      discord

      age
      chezmoi
      figlet
      gum
      httpie
      lolcat
      m-cli
      mas

      # Fonts
      nerd-fonts.jetbrains-mono
      nerd-fonts.monaspace
      nerd-fonts.hack
      rubik
    ];

    # secrets = {
    #   mount = "/tmp/user/$UID/secrets";
    #   identityPaths = ["${config.home.homeDirectory}/.ssh/id_ed25519"];
    #   enableForceReload = true;
    # };

    imports = [
      inputs.nixvim.homeModules.nixvim
      ../shared/programs/vim

      ../shared/programs/1password
      ../shared/programs/ai
      ../shared/programs/git
      ../shared/programs/bat
      ../shared/programs/ranger
      ../shared/programs/shell
      ../shared/programs/nix

      ../darwin/programs/homerow
    ];

    home.stateVersion = "25.05";
  };
}
