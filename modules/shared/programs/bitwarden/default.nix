{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.bitwarden-cli;
in
{
  options.programs.bitwarden-cli = {
    enable = lib.mkEnableOption "Bitwarden CLI";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.bitwarden-cli;
      description = "The Bitwarden CLI package to install.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    programs.zsh.initContent = lib.mkAfter ''
      bwlogin() {
        command bw login "$@"
      }

      bwunlock() {
        local session

        session="$(command bw unlock --raw "$@")" || return $?
        export BW_SESSION="$session"
        printf 'BW_SESSION exported for the current shell.\n'
      }

      bwlock() {
        command bw lock "$@"
        unset BW_SESSION
      }

      bwlogout() {
        command bw logout "$@"
        unset BW_SESSION
      }

      bwsync() {
        command bw sync "$@"
      }
    '';
  };
}
