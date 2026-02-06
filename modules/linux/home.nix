{
  pkgs,
  inputs,
  user-profile,
  ...
}:
let
  username = user-profile.username;
in
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.${username} =
    { ... }:
    {
      home.username = username;
      home.homeDirectory = "/home/${username}";

      home.packages = with pkgs; [
        duckdb
        ngrok
        ripgrep
        fd
        unzip
      ];

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
      ];

      home.stateVersion = "25.11";
    };
}
