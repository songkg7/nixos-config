{
  pkgs,
  inputs,
  ...
}: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.haril = {...}: {
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

    # secrets = {
    #   identityPaths = ["${config.home.homeDirectory}/.ssh/id_ed25519"];
    #   enableForceReload = true;
    # };

    imports = [
      inputs.nixvim.homeModules.nixvim

      # ../shared/programs/1password
      ../shared/programs/ai
      ../shared/programs/bat
      ../shared/programs/git
      ../shared/programs/ranger
      ../shared/programs/shell
      # ../shared/programs/gpg
      # ../shared/programs/jq
      #
      # ../linux/programs/wayland
      # ../linux/programs/zpl-open
    ];

    home.stateVersion = "25.05";
  };
}
