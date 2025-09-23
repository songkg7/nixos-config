{
  config,
  pkgs,
  inputs,
  ...
}: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";
  home-manager.users.haril = {config, ...}: {
    home.username = "haril";
    home.homeDirectory = "/Users/haril";

    home.packages = with pkgs; [
      # Development
      # google-cloud-sdk
      # jetbrains.datagrip
      # jetbrains.idea-ultimate
      jetbrains-toolbox

      # Utility
      ripgrep
      fd
      fx
      jq
      htop
      neohtop
      lazydocker
      lazygit
      lsd
      alt-tab-macos
      trash-cli
      walk
      tldr
      ice-bar
      loopwm
      obsidian
      raycast
      # FIXME: slack
      aerospace
      # TODO: lunarvim

      # Fonts
      nerd-fonts.jetbrains-mono
      nerd-fonts.monaspace
      nerd-fonts.hack
      rubik
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
      ../shared/programs/ai
      ../shared/programs/git
      # ../shared/programs/aws
      ../shared/programs/bat
      ../shared/programs/ranger
      ../shared/programs/shell
      ../shared/programs/nix

      ../darwin/programs/homerow
    ];

    home.stateVersion = "25.05";
  };
}
