{
  config,
  lib,
  pkgs,
  profileConfig,
  ...
}:
let
  cfg = config.programs.bitwarden-cli;
  sshAuthSock = profileConfig.passwordManager.sshAuthSock;
  normalizedSshAuthSock =
    if sshAuthSock == null then
      null
    else
      lib.replaceStrings [ "~/" ] [ "${profileConfig.user.homeDirectory}/" ] sshAuthSock;
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

    programs.zsh.initContent = lib.mkMerge [
      (lib.mkAfter ''
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
      '')

      (lib.mkIf (normalizedSshAuthSock != null) (
        lib.mkAfter ''
          bw-ssh-agent-use() {
            export SSH_AUTH_SOCK='${normalizedSshAuthSock}'
            printf 'SSH_AUTH_SOCK=%s\n' "$SSH_AUTH_SOCK"
          }

          bw-ssh-agent-test() {
            SSH_AUTH_SOCK='${normalizedSshAuthSock}' ssh-add -l
          }

          if [[ -z "$SSH_CONNECTION" ]]; then
            export SSH_AUTH_SOCK='${normalizedSshAuthSock}'
          fi
        ''
      ))
    ];
  };
}
