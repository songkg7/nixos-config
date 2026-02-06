{
  lib,
  pkgs,
  ...
}:
let
  darwinUtils = import ../../../../libraries/darwin-utils.nix { inherit pkgs; };
  inherit (darwinUtils) brewPrefix;
in
{
  imports = [
    ./atuin.nix
    ./fzf.nix
    ./starship
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
  ]
  ++ lib.optionals pkgs.stdenv.isDarwin [
    "${brewPrefix}/bin"
    "${brewPrefix}/sbin"
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

    # loginExtra = ''
    #   figlet -f mike "Hello $(echo Haril)" | lolcat
    # '';

    initContent = lib.mkOrder 0 ''
      # Warp terminal integration
      printf '\eP$f{"hook": "SourcedRcFileForWarp", "value": { "shell": "zsh" }}\x9c'

      figlet -f mike "Hello $(echo Haril)" | lolcat
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

    profileExtra = lib.optionalString pkgs.stdenv.isDarwin ''
      if [[ -r "$HOME/.orbstack/shell/init.zsh" ]]; then
        source "$HOME/.orbstack/shell/init.zsh" 2>/dev/null || :
      fi

      toolboxDir="$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
      if [[ -d "$toolboxDir" ]]; then
        path+=("$toolboxDir")
      fi
    '';
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
