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
    { config, ... }:
    {
      home.username = "haril";
      home.homeDirectory = "/Users/haril";

      home.file."haril-vault" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Library/Mobile Documents/iCloud~md~obsidian/Documents/haril-vault";
      };

      home.packages =
        with pkgs;
        [
          # Development
          jetbrains-toolbox
          databricks-cli

          # Cloud and DevOps
          gh
          glab
          tailscale

          # Utility
          ripgrep
          fd
          fx
          jq
          htop
          glances
          lazydocker
          lazygit
          lsd
          walk
          tldr
          aerospace
          ouch
          parallel
          qsv

          age
          chezmoi
          figlet
          gum
          httpie
          lolcat
          m-cli
          helix

          # GUI Apps
          alt-tab-macos
          # ice-bar
          # loopwm
          # raycast
          # neohtop
          # obsidian
          # discord
          # iina

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
        ../shared/programs/yazi
        ../shared/programs/shell
        ../shared/programs/nix
        ../shared/programs/direnv
        ../shared/programs/kubernetes
        ../shared/programs/aws

        ../darwin/programs/aerospace
        ../darwin/programs/ssh
        ../darwin/programs/homerow
      ];

      home.stateVersion = "25.05";
    };
}
