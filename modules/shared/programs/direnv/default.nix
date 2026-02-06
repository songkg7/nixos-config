{
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    nix-direnv = {
      enable = true;
    };
  };

  home.file."nixos-config/.envrc".text = ''
    use flake
  '';
}
