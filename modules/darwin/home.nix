{
  pkgs,
  inputs,
  ...
}: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";
  home-manager.users.haril = {...}: {
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
      awscli2
      # databricks-cli
      # copilot-cli
      gh
      glab
      # TODO: Seperate configration each env. e.g. private and work.
      # colima

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
      aerospace
      discord

      age
      chezmoi
      figlet
      gum
      httpie
      lolcat
      m-cli

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

      ../shared/programs/ai
      ../shared/programs/git
      ../shared/programs/bat
      ../shared/programs/ranger
      ../shared/programs/shell
      ../shared/programs/nix
      ../shared/programs/direnv
      ../darwin/programs/aerospace

      ../darwin/programs/ssh
      ../darwin/programs/homerow
    ];

    home.stateVersion = "25.05";
  };
}
