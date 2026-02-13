{
  pkgs,
  inputs,
  environment,
  user-profile,
  ...
}:
let
  username = user-profile.username;
  envConfig = (import ./environments).${environment};
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
          ngrok

          # Utility
          ripgrep
          ast-grep
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

          # Fonts
          nerd-fonts.jetbrains-mono
          nerd-fonts.monaspace
          nerd-fonts.hack
          rubik
        ]
        ++ (map (name: pkgs.${name}) envConfig.packages);

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
        ../shared/programs/tmux
        ../shared/programs/zellij

        ../darwin/programs/aerospace
        ../darwin/programs/ssh
        ../darwin/programs/homerow
      ];

      home.stateVersion = "25.11";
    };
}
