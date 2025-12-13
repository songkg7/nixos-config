{
  pkgs,
  inputs,
  ...
}:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.haril =
    { config, ... }:
    {
      home.username = "haril";
      home.homeDirectory = "/home/haril";

      home.packages = with pkgs; [
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

      age = {
        identityPaths = [ "${config.home.homeDirectory}/.ssh/agenix" ];
        secrets = {
          gitconfig-work = {
            file = ../../secrets/gitconfig-work.age;
          };
          "mise.work.toml" = {
            file = ../../secrets/mise-work-env.age;
            path = "${config.home.homeDirectory}/.config/mise/conf.d/mise.work.toml";
          };
          "mise.personal.toml" = {
            file = ../../secrets/mise-personal-env.age;
            path = "${config.home.homeDirectory}/.config/mise/conf.d/mise.personal.toml";
          };
        };
      };

      imports = [
        inputs.nixvim.homeModules.nixvim
        inputs.agenix.homeManagerModules.default

        # ../shared/programs/1password
        ../shared/programs/ai
        ../shared/programs/bat
        ../shared/programs/git
        ../shared/programs/yazi
        ../shared/programs/shell
        # ../shared/programs/gpg
        # ../shared/programs/jq
        #
        # ../linux/programs/wayland
        # ../linux/programs/zpl-open
      ];

      home.stateVersion = "25.11";
    };
}
