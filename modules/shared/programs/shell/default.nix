{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./atuin.nix
    ./fzf.nix
    ./starship.nix
    ./mise.nix
    ./zoxide.nix
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    AUTHOR = "haril";
    USE_GKE_GCLOUD_AUTH_PLUGIN = "True";
    _ZO_FZF_OPTS = "--height 40% --border";
    LANG = "en_US.UTF-8";
  };

  home.shellAliases = {
    vi = "nvim";
    kc = "kubectl";
    ls = "lsd";
    lt = "ls --tree";
    lg = "lazygit";
    cat = "bat --paging=never";
    ch = "chezmoi";
    rm = "trash";
    rml = "trash-list";
    rmc = "trash-empty";
    ra = "ranger";
    py = "python";
    vc = "warp-cli connect";
    vd = "warp-cli disconnect";
  };

  programs.zsh = {
    enable = true;
    initContent = lib.mkOrder 0 ''
      # For GPG
      export GPG_TTY=$(tty)

      # Custom functions
      lk() {
        cd "$(walk --icons "$@")"
      }

      sd() {
        cd "$(fd . --type d | fzf)"
      }

      prompt_context() {
        if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
          prompt_segment black default "%(!.%{%F{yellow}%}.)$USER"
        fi
      }

      # Direnv hook
      if [ -n "$CLAUDECODE" ]; then
        if command -v direnv >/dev/null 2>&1; then
          eval "$(direnv hook zsh)"
          eval "$(DIRENV_LOG_FORMAT= direnv export zsh)"
        fi
      fi

      # Startup splash
      figlet -f mike "Hello $(echo Haril)" | lolcat

      # Warp terminal integration
      printf '\eP$f{"hook": "SourcedRcFileForWarp", "value": { "shell": "zsh" }}\x9c'
    '';
  };
}
