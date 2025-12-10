{ lib, ... }:
{
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

    GUM_FILTER_REVERSE = "true";
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
    py = "python";
    vc = "warp-cli connect";
    vd = "warp-cli disconnect";
    h = "atsearch";
    hh = "atuin search -i";
  };

  programs.zsh = {
    enable = true;
    initContent = lib.mkOrder 0 ''
      # For GPG
      export GPG_TTY=$(tty)

      export PATH="$HOME/.local/bin:$PATH"
      export PATH="/Applications/Ghostty.app/Contents/MacOS:$PATH"

      # Custom functions
      lk() {
        cd "$(walk --icons "$@")"
      }

      sd() {
        cd "$(fd . --type d | fzf)"
      }

      atsearch() {
        atuin search "$1" --format "{host}\t{command}"
      }

      prompt_context() {
        if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
          prompt_segment black default "%(!.%{%F{yellow}%}.)$USER"
        fi
      }

      # Warp terminal integration
      printf '\eP$f{"hook": "SourcedRcFileForWarp", "value": { "shell": "zsh" }}\x9c'

      # Startup splash
      figlet -f mike "Hello $(echo Haril)" | lolcat
    '';

    syntaxHighlighting = {
      enable = true;
    };

    autosuggestion = {
      enable = true;
    };
  };
}
