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
    la = "lsd -al";
    lt = "ls --tree";
    lg = "lazygit";
    cat = "bat --paging=never";
    ch = "chezmoi";
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

      export PATH="$HOME/.local/bin:$PATH"

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

      # Startup splash
      figlet -f mike "Hello $(echo Haril)" | lolcat

      # Warp terminal integration
      printf '\eP$f{"hook": "SourcedRcFileForWarp", "value": { "shell": "zsh" }}\x9c'
    '';
  };
}
