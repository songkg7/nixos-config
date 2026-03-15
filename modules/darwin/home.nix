{
  pkgs,
  profileConfig,
  ...
}:
let
  username = profileConfig.user.username;
in
{
  home-manager.users.${username} =
    { config, ... }:
    {
      home.file."haril-vault" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Library/Mobile Documents/iCloud~md~obsidian/Documents/haril-vault";
      };

      home.packages =
        with pkgs;
        [
          # Databases / Analytics
          rainfrog

          # Development
          jetbrains-toolbox
          uv
          databricks-cli

          # Cloud and DevOps
          gh

          # Utility
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
          nmap

          age
          chezmoi
          figlet
          gum
          httpie
          lolcat
          m-cli
          hyperfine

          # GUI Apps
          alt-tab-macos

          # Fonts
          nerd-fonts.jetbrains-mono
          nerd-fonts.monaspace
          nerd-fonts.hack
          rubik
        ]
        ++ profileConfig.home.extraPackages;

      imports = [
        ../darwin/programs/aerospace
        ../darwin/programs/ssh
        ../darwin/programs/homerow
        ../darwin/programs/ghostty
      ];
    };
}
