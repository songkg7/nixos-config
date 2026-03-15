{
  config,
  lib,
  pkgs,
  profileConfig,
  ...
}:
let
  sshRuntime = profileConfig.ssh.runtime;
  isPersonalDarwinGpgAgent = profileConfig.platform.isDarwin && sshRuntime.backend == "gpg-agent";
  gpgPkg = config.programs.gpg.package;
  gpgConf = lib.getExe' gpgPkg "gpgconf";
  gpgConnectAgent = lib.getExe' gpgPkg "gpg-connect-agent";
  pinentryCurses = pkgs.pinentry-curses;
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

        gpg-personal-refresh >/dev/null 2>&1 || true
      '';
    })
  ];
}
