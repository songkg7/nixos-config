{
  inputs,
  pkgs,
  profileConfig,
  ...
}:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
    inputs.agenix.homeManagerModules.default
    ../../modules/shared/programs/vim
    ../../modules/shared/programs/ai
    ../../modules/shared/programs/git
    ../../modules/shared/programs/bat
    ../../modules/shared/programs/yazi
    ../../modules/shared/programs/shell
    ../../modules/shared/programs/nix
    ../../modules/shared/programs/direnv
    ../../modules/shared/programs/kubernetes
    ../../modules/shared/programs/aws
    ../../modules/shared/programs/age
    ../../modules/shared/programs/bitwarden
    ../../modules/shared/programs/gpg
    ../../modules/shared/programs/tmux
    ../../modules/shared/programs/zellij
  ];

  home.username = profileConfig.user.username;
  home.homeDirectory = profileConfig.user.homeDirectory;
  home.stateVersion = profileConfig.home.stateVersion;

  home.packages = with pkgs; [
    duckdb
    ngrok
    ripgrep
    fd
    tokei
    semgrep
    rtk
  ];

  programs.bitwarden-cli.enable = profileConfig.passwordManager.enableBitwardenCli;

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
  };
}
