{
  config,
  pkgs,
  inputs,
  ...
}: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.haril = {config, ...}: {
    home.username = "haril";
    home.homeDirectory = "/Users/haril";

    home.packages = with pkgs; [
      # Development
      gemini-cli
      # google-cloud-sdk
      # jetbrains.datagrip
      # jetbrains.idea-ultimate
      neohtop

      # Utility
      ripgrep
    ];

    # secrets = {
    #   mount = "/tmp/user/$UID/secrets";
    #   identityPaths = ["${config.home.homeDirectory}/.ssh/id_ed25519"];
    #   enableForceReload = true;
    # };

    imports = [
      # inputs.nixvim.homeModules.nixvim

      # ../shared/programs/1password
      # ../shared/programs/act
      # ../shared/programs/ai
      # ../shared/programs/aws
      # ../shared/programs/bat
      # ../darwin/programs/homerow
    ];

    home.stateVersion = "25.05";
  };
}
