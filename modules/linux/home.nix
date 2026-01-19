{
  pkgs,
  inputs,
  ...
}:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.haril =
    { ... }:
    {
      home.username = "haril";
      home.homeDirectory = "/home/haril";

      home.packages = with pkgs; [
        # Databases / Analytics
        duckdb

        # Development
        # curl
        # jetbrains.datagrip
        # jetbrains.idea-ultimate

        # Utility
        ngrok
        ripgrep
        fd
        # slack
        unzip
        # xdg-utils
      ];

      imports = [
        inputs.nixvim.homeModules.nixvim
        inputs.agenix.homeManagerModules.default

        # ../shared/programs/1password
        ../shared/programs/ai
        ../shared/programs/bat
        ../shared/programs/git
        ../shared/programs/yazi
        ../shared/programs/shell
        ../shared/programs/age
        ../shared/programs/gpg
        # ../shared/programs/jq
        #
        # ../linux/programs/wayland
        # ../linux/programs/zpl-open
      ];

      home.stateVersion = "25.11";
    };
}
