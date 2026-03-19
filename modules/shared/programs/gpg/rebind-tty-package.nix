{ pkgs, gpgConnectAgent }:
pkgs.writeShellApplication {
  name = "gpg-personal-rebind-tty";
  text = ''
    set -euo pipefail

    tty_value="''${1:-''${TTY:-}}"
    if [ -z "$tty_value" ]; then
      tty_value="$(tty 2>/dev/null || true)"
    fi

    case "$tty_value" in
      /dev/*) ;;
      *) exit 0 ;;
    esac

    export GPG_TTY="$tty_value"
    ${gpgConnectAgent} --quiet /bye >/dev/null
    ${gpgConnectAgent} --quiet updatestartuptty /bye >/dev/null
  '';
}
