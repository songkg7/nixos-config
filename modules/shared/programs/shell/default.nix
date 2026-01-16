{
  lib,
  ...
}:
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

  home.sessionPath = [
    "$HOME/.local/bin"
    "/Applications/Ghostty.app/Contents/MacOS"
  ];

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
    rm = "trash";
  };

  programs.zsh = {
    enable = true;

    loginExtra = ''
      figlet -f mike "Hello $(echo Haril)" | lolcat
    '';

    initContent = lib.mkOrder 0 ''
      # For GPG
      export GPG_TTY=$(tty)

      # Warp terminal integration
      printf '\eP$f{"hook": "SourcedRcFileForWarp", "value": { "shell": "zsh" }}\x9c'
    '';

    syntaxHighlighting = {
      enable = true;
    };

    autosuggestion = {
      enable = true;
    };

    zsh-abbr = {
      enable = true;
    };

    # TODO: add extra profile
    # profileExtra = ''
    # '';
    siteFunctions = {
      mkcd = ''
        mkdir -p "$1" && cd "$1"
      '';

      lk = ''
        cd "$(walk --icons "$@")"
      '';

      atsearch = ''
        atuin search "$1" --format "{host}\t{command}"
      '';

      sd = ''
        cd "$(fd . --type d | fzf)"
      '';

      prompt_context = ''
        if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
          prompt_segment black default "%(!.%{%F{yellow}%}.)$USER"
        fi
      '';
    };
  };
}
