{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./atuin.nix
    ./fzf.nix
  ];

  # home.file = {
  #   ".hushlogin".text = "";
  # };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    AUTHOR = "haril";
  };

  # home.shellAliases = {
  #   l = "lsd -l";
  #   ls = "lsd -al";
  # };

  # programs.zsh = {
  #   enable = true;
  #   historySize = 1000000;
  #   historyFileSize = 1000000;
  #   initExtra = lib.mkOrder 0 ''
  #     if [ -n "$CLAUDECODE" ]; then
  #       if command -v direnv >/dev/null 2>&1; then
  #         eval "$(direnv hook zsh)"
  #         eval "$(DIRENV_LOG_FORMAT= direnv export zsh)"
  #       fi
  #     fi
  #   '';
  # };
}
