{
  pkgs,
  inputs,
  environment,
  ...
}:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";
  home-manager.users.haril =
    { ... }:
    {
      home.username = "haril";
      home.homeDirectory = "/Users/haril";

      home.packages =
        with pkgs;
        [
          # Development
          jetbrains-toolbox

          # Cloud and DevOps
          gh
          glab
          awscli2

          # Utility
          ripgrep
          fd
          fx
          jq
          htop
          lazydocker
          lazygit
          lsd
          alt-tab-macos
          walk
          tldr
          aerospace

          age
          chezmoi
          figlet
          gum
          httpie
          lolcat
          m-cli

          # GUI Apps
          ice-bar
          loopwm
          raycast
          neohtop
          obsidian
          discord

          # Fonts
          nerd-fonts.jetbrains-mono
          nerd-fonts.monaspace
          nerd-fonts.hack
          rubik
        ]
        ++ (
          if environment == "work" then
            [
              # NOTE: business use only
              docker
              colima
            ]
          else
            [ ]
        )
        ++ (
          if environment == "personal" then
            [
              # NOTE: personal use only
            ]
          else
            [ ]
        );

      # secrets = {
      #   mount = "/tmp/user/$UID/secrets";
      #   identityPaths = [ "${config.home.homeDirectory}/.ssh/agenix" ];
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
        ../shared/programs/kubernetes

        ../darwin/programs/aerospace
        ../darwin/programs/ssh
        ../darwin/programs/homerow
      ];

      home.stateVersion = "25.05";
    };
}
