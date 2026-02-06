{
  pkgs,
  inputs,
  environment,
  user-profile,
  ...
}:
let
  username = user-profile.username;
in
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";
  home-manager.users.${username} =
    { config, ... }:
    {
      home.username = username;
      home.homeDirectory = "/Users/${username}";

      home.file."haril-vault" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Library/Mobile Documents/iCloud~md~obsidian/Documents/haril-vault";
      };

      home.packages =
        with pkgs;
        [
          # Databases / Analytics
          duckdb

          # Development
          jetbrains-toolbox

          uv
          databricks-cli

          # Cloud and DevOps
          gh

          # Utility
          ripgrep
          fd
          fx
          jq
          htop
          glances
          lazydocker
          lsd
          walk
          tldr
          aerospace
          ouch
          parallel
          qsv
          tmux
          trash-cli
          pueue

          age
          chezmoi
          figlet
          gum
          httpie
          lolcat
          m-cli

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
              podman
              podman-compose
              glab
            ]
          else
            [ ]
        )
        ++ (
          if environment == "personal" then
            [
              # NOTE: personal use only
              helix

              # AI
              # mgrep
            ]
          else
            [ ]
        );

      imports = [
        inputs.nixvim.homeModules.nixvim
        inputs.agenix.homeManagerModules.default
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
        ../shared/programs/age
        ../shared/programs/gpg

        ../darwin/programs/aerospace
        ../darwin/programs/ssh
        ../darwin/programs/homerow
      ];

      home.stateVersion = "25.11";
    };
}
