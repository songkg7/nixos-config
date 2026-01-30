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
  # Optional: Add direnv configuration
  # xdg.configFile."direnv/direnvrc".text = ''
  #   # Global direnv configuration
  #
  #   # Load nix-direnv if available
  #   source_env_if_exists ~/.config/direnv/lib/use_nix.sh
  #
  #   # Custom functions can be added here
  #   use_flake_with_cache() {
  #     use flake "$@"
  #     # Additional caching optimization
  #     mkdir -p .direnv
  #     echo "use flake $@" > .direnv/flake-inputs
  #   }
  #
  #   # Logging for debugging (optional)
  #   # export DIRENV_LOG_FORMAT="direnv: %s"
  # '';

  # Create a .envrc template for easy project setup
  # home.file.".local/share/direnv/envrc-template".text = ''
  #   # Basic Nix flake integration
  #   use flake
  #
  #   # Alternative: use specific devShell
  #   # use flake .#dev
  #
  #   # Alternative: use shell.nix
  #   # use nix
  #
  #   # Set additional environment variables if needed
  #   # export SOME_VAR=value
  #
  #   # Layout for specific language environments
  #   # layout python
  #   # layout node
  # '';
}
