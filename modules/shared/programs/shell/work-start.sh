# shellcheck shell=bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  work-start
  work-start --home
  work-start --office
EOF
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

is_tty() {
  [[ -t 0 && -t 1 ]]
}

prompt_location() {
  local choice
  printf '%s\n' "Where are you working?" >&2
  printf '  1) home\n' >&2
  printf '  2) office\n' >&2
  printf 'Choice: ' >&2
  if ! read -r choice; then
    return 130
  fi

  case "$choice" in
    1 | home)
      printf '%s\n' "home"
      ;;
    2 | office)
      printf '%s\n' "office"
      ;;
    *)
      printf '%s\n' "Invalid choice." >&2
      return 1
      ;;
  esac
}

connect_vpn() {
  if ! command_exists vpn; then
    printf '%s\n' "[work] 'vpn' command not found." >&2
    return 1
  fi
  vpn warp --force
}

login_aws_sso() {
  if ! command_exists aws; then
    printf '%s\n' "[work] 'aws' command not found." >&2
    return 1
  fi
  printf '%s\n' "[work] AWS SSO login..."
  if ! aws sso login; then
    printf '%s\n' "[work] Failed: AWS SSO login." >&2
    return 1
  fi
}

login_sdm() {
  if ! command_exists sdm; then
    printf '%s\n' "[work] 'sdm' command not found." >&2
    return 1
  fi
  printf '%s\n' "[work] SDM login..."
  if ! sdm login; then
    printf '%s\n' "[work] Failed: SDM login." >&2
    return 1
  fi
}

connect_sdm() {
  printf '%s\n' "[work] SDM connect all..."
  if ! sdm connect -a; then
    printf '%s\n' "[work] Failed: SDM connect." >&2
    return 1
  fi
}

location=""

for arg in "$@"; do
  case "$arg" in
    --home)
      location="home"
      ;;
    --office)
      location="office"
      ;;
    --help | -h)
      usage
      exit 0
      ;;
    *)
      printf '%s\n' "Unknown argument: $arg" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [[ -z "$location" ]]; then
  if is_tty; then
    location="$(prompt_location)" || exit $?
  else
    printf '%s\n' "Location required. Use --home or --office." >&2
    usage >&2
    exit 1
  fi
fi

if [[ "$location" == "home" ]]; then
  connect_vpn
fi

login_aws_sso
login_sdm
connect_sdm

printf '%s\n' "[work] All done. Ready to work from $location."
