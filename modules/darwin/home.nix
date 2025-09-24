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

      # Cloud and DevOps
      k9s
      # databricks-cli
      # copilot-cli

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
      # TODO: find trash-cli alternatives
      walk
      tldr
      ice-bar
      loopwm
      obsidian
      raycast
      # FIXME: slack
      aerospace
      # NOTE: astronvim requirements
      neovim
      gdu
      tree-sitter
      bottom
      # TODO: astronvim
      # vimPlugins.astrocore
      # vimPlugins.astrolsp
      # vimPlugins.astrotheme
      # vimPlugins.astroui
      # vimPlugins.mason-null-ls-nvim
      # vimPlugins.mason-nvim-dap-nvim

      age
      chezmoi
      figlet
      gum
      httpie
      lolcat
      m-cli
      mas

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
      inputs.nixvim.homeModules.nixvim

      # ../shared/programs/1password
      # ../shared/programs/act
      ../shared/programs/ai
      ../shared/programs/git
      # ../shared/programs/aws
      ../shared/programs/bat
      ../shared/programs/ranger
      ../shared/programs/shell
      ../shared/programs/nix
      ../shared/programs/vim

      ../darwin/programs/homerow
    ];

    home.stateVersion = "25.05";
  };
}
