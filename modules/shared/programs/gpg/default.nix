{
  config,
  environment,
  lib,
  pkgs,
  user-profile,
  ...
}:
let
  isDarwin = pkgs.stdenv.isDarwin;
  darwinEnvConfig = if isDarwin then (import ../../../darwin/environments).${environment} else null;
  sshRuntime = if isDarwin then darwinEnvConfig.sshRuntime else null;
  isPersonalDarwinGpgAgent = isDarwin && sshRuntime.backend == "gpg-agent";
  gpgPkg = config.programs.gpg.package;
  gpgConf = lib.getExe' gpgPkg "gpgconf";
  gpgConnectAgent = lib.getExe' gpgPkg "gpg-connect-agent";
  pinentryCurses = pkgs.pinentry-curses;
  homeDir = config.home.homeDirectory;
  bootstrapKeyFile =
    if isPersonalDarwinGpgAgent then
      lib.replaceStrings [ "~" ] [ homeDir ] sshRuntime.bootstrapKeyFile
    else
      null;
  bootstrapPublicKeyFile = if bootstrapKeyFile != null then "${bootstrapKeyFile}.pub" else null;
in
{
  config = lib.mkMerge [
    {
      programs.gpg = {
        enable = true;
      };
    }

    (lib.mkIf isPersonalDarwinGpgAgent {
      home.packages = [ pinentryCurses ];

      home.file.".gnupg/gpg-agent.conf".text = ''
        enable-ssh-support
        pinentry-program ${lib.getExe pinentryCurses}
        default-cache-ttl-ssh ${toString sshRuntime.cacheTtlSshSeconds}
        max-cache-ttl-ssh ${toString sshRuntime.cacheTtlSshSeconds}
        no-allow-external-cache
        disable-scdaemon
      '';

      programs.zsh.initContent = lib.mkAfter ''
        gpg-personal-refresh() {
          local tty_value

          tty_value="''${TTY:-$(tty)}" || return $?
          export GPG_TTY="$tty_value"
          ${gpgConnectAgent} --quiet /bye >/dev/null
          ${gpgConnectAgent} --quiet updatestartuptty /bye >/dev/null
          export SSH_AUTH_SOCK="$(${gpgConf} --list-dirs agent-ssh-socket)"
        }

        gpg-personal-status() {
          local pub="${bootstrapPublicKeyFile}"

          gpg-personal-refresh || return $?
          printf 'GPG_TTY=%s\n' "$GPG_TTY"
          printf 'SSH_AUTH_SOCK=%s\n' "$SSH_AUTH_SOCK"

          if ! SSH_AUTH_SOCK="$SSH_AUTH_SOCK" ssh-add -l; then
            printf 'No SSH identities are currently loaded.\n'
          fi

          if [[ -f "$pub" ]]; then
            SSH_AUTH_SOCK="$SSH_AUTH_SOCK" ssh-add -T "$pub"
          fi
        }

        gpg-personal-reset() {
          ${gpgConf} --kill gpg-agent
          gpg-personal-refresh
        }

        gpg-personal-bootstrap() {
          local key="${bootstrapKeyFile}"
          local pub="${bootstrapPublicKeyFile}"
          local comment=${lib.escapeShellArg user-profile.personal.email}

          gpg-personal-refresh || return $?
          mkdir -p "$HOME/.ssh"
          chmod 700 "$HOME/.ssh"
          umask 077

          if [[ ! -f "$key" ]]; then
            ssh-keygen -q -t ed25519 -C "$comment" -f "$key" || return $?
          fi

          if [[ ! -f "$pub" ]]; then
            ssh-keygen -y -f "$key" > "$pub" || return $?
          fi

          SSH_AUTH_SOCK="$SSH_AUTH_SOCK" ssh-add "$key" || return $?
          SSH_AUTH_SOCK="$SSH_AUTH_SOCK" ssh-add -T "$pub" || return $?

          printf 'Imported %s into gpg-agent.\n' "$key"
          printf 'Public key:\n'
          cat "$pub"
          printf '\n'
          printf 'Keep recovery material in Bitwarden before deleting %s after verification.\n' "$key"
          printf 'Update GitHub authentication/signing keys and rotate flake/secrets if you switch away from the current public key.\n'
        }

        gpg-personal-refresh >/dev/null 2>&1 || true
      '';
    })
  ];
}
