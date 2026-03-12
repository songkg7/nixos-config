# shellcheck shell=bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  vpn
  vpn status
  vpn warp [--force]
  vpn tailscale [--force]
  vpn off [warp|tailscale|all]
EOF
}

is_tty() {
  [[ -t 0 && -t 1 ]]
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

warp_present() {
  command_exists warp-cli
}

tailscale_present() {
  command_exists tailscale
}

warp_state() {
  if ! warp_present; then
    printf '%s\n' "missing"
    return 0
  fi

  local status_json raw_status
  if ! status_json="$(warp-cli --json status 2>/dev/null)"; then
    printf '%s\n' "unavailable"
    return 0
  fi

  raw_status="$(jq -r '.status // "unknown"' <<<"$status_json" 2>/dev/null || printf 'unknown')"
  case "$raw_status" in
    Connected)
      printf '%s\n' "connected"
      ;;
    Connecting)
      printf '%s\n' "connecting"
      ;;
    Disconnected)
      printf '%s\n' "disconnected"
      ;;
    *)
      printf '%s\n' "unknown"
      ;;
  esac
}

tailscale_state() {
  if ! tailscale_present; then
    printf '%s\n' "missing"
    return 0
  fi

  local status_json backend_state
  if ! status_json="$(tailscale status --json 2>/dev/null)"; then
    printf '%s\n' "unavailable"
    return 0
  fi

  backend_state="$(jq -r '.BackendState // "unknown"' <<<"$status_json" 2>/dev/null || printf 'unknown')"
  case "$backend_state" in
    Running)
      printf '%s\n' "running"
      ;;
    Starting)
      printf '%s\n' "starting"
      ;;
    Stopped | NoState)
      printf '%s\n' "stopped"
      ;;
    NeedsLogin)
      printf '%s\n' "needs-login"
      ;;
    *)
      printf '%s\n' "unknown"
      ;;
  esac
}

active_vpn() {
  local warp_status tailscale_status
  warp_status="$(warp_state)"
  tailscale_status="$(tailscale_state)"

  if [[ "$warp_status" =~ ^(connected|connecting)$ ]] && [[ "$tailscale_status" =~ ^(running|starting)$ ]]; then
    printf '%s\n' "multiple"
  elif [[ "$warp_status" =~ ^(connected|connecting)$ ]]; then
    printf '%s\n' "warp"
  elif [[ "$tailscale_status" =~ ^(running|starting)$ ]]; then
    printf '%s\n' "tailscale"
  else
    printf '%s\n' "none"
  fi
}

display_state() {
  local service="$1"
  local state="$2"

  case "$state" in
    missing)
      printf '%s\n' "$service: not installed"
      ;;
    unavailable)
      printf '%s\n' "$service: installed, status unavailable"
      ;;
    connected | connecting | disconnected | running | starting | stopped | needs-login | unknown)
      printf '%s\n' "$service: installed, $state"
      ;;
    *)
      printf '%s\n' "$service: $state"
      ;;
  esac
}

print_status() {
  local warp_status tailscale_status active
  warp_status="$(warp_state)"
  tailscale_status="$(tailscale_state)"
  active="$(active_vpn)"

  display_state "WARP" "$warp_status"
  display_state "Tailscale" "$tailscale_status"
  printf '%s\n' "Active VPN: $active"
}

prompt_choice() {
  local prompt="$1"
  shift
  local options=("$@")
  local index
  local choice

  while true; do
    printf '%s\n' "$prompt" >&2
    for index in "${!options[@]}"; do
      printf '  %d) %s\n' "$((index + 1))" "${options[$index]}" >&2
    done
    printf 'Choice: ' >&2
    if ! read -r choice; then
      return 130
    fi

    case "$choice" in
      ""|*[!0-9]*)
        ;;
      *)
        if (( choice >= 1 && choice <= ${#options[@]} )); then
          printf '%s\n' "${options[$((choice - 1))]}"
          return 0
        fi
        ;;
    esac

    printf '%s\n' "Invalid choice." >&2
  done
}

wait_for_warp_active() {
  local attempt state
  for ((attempt = 1; attempt <= 15; attempt += 1)); do
    state="$(warp_state)"
    if [[ "$state" == "connected" ]]; then
      return 0
    fi
    sleep 1
  done

  printf '%s\n' "Timed out waiting for WARP to connect." >&2
  return 1
}

wait_for_warp_inactive() {
  local attempt state
  for ((attempt = 1; attempt <= 15; attempt += 1)); do
    state="$(warp_state)"
    if [[ "$state" != "connected" && "$state" != "connecting" ]]; then
      return 0
    fi
    sleep 1
  done

  printf '%s\n' "Timed out waiting for WARP to disconnect." >&2
  return 1
}

wait_for_tailscale_active() {
  local attempt state
  for ((attempt = 1; attempt <= 15; attempt += 1)); do
    state="$(tailscale_state)"
    if [[ "$state" == "running" ]]; then
      return 0
    fi
    sleep 1
  done

  printf '%s\n' "Timed out waiting for Tailscale to start." >&2
  return 1
}

wait_for_tailscale_inactive() {
  local attempt state
  for ((attempt = 1; attempt <= 15; attempt += 1)); do
    state="$(tailscale_state)"
    if [[ "$state" != "running" && "$state" != "starting" ]]; then
      return 0
    fi
    sleep 1
  done

  printf '%s\n' "Timed out waiting for Tailscale to stop." >&2
  return 1
}

connect_warp() {
  local state
  state="$(warp_state)"

  if [[ "$state" == "missing" ]]; then
    printf '%s\n' "Cloudflare WARP is not installed on this machine." >&2
    return 1
  fi

  if [[ "$state" == "connected" ]]; then
    printf '%s\n' "WARP is already active."
    return 0
  fi

  if [[ "$state" == "connecting" ]]; then
    printf '%s\n' "WARP is already connecting..."
    wait_for_warp_active
    printf '%s\n' "WARP connected."
    return 0
  fi

  printf '%s\n' "Connecting WARP..."
  warp-cli connect
  wait_for_warp_active
  printf '%s\n' "WARP connected."
}

disconnect_warp() {
  local state
  state="$(warp_state)"

  if [[ "$state" == "missing" ]]; then
    printf '%s\n' "Cloudflare WARP is not installed on this machine." >&2
    return 1
  fi

  if [[ "$state" != "connected" && "$state" != "connecting" ]]; then
    printf '%s\n' "WARP is already inactive."
    return 0
  fi

  printf '%s\n' "Disconnecting WARP..."
  warp-cli disconnect
  wait_for_warp_inactive
  printf '%s\n' "WARP disconnected."
}

connect_tailscale() {
  local state
  state="$(tailscale_state)"

  if [[ "$state" == "missing" ]]; then
    printf '%s\n' "Tailscale is not installed on this machine." >&2
    return 1
  fi

  if [[ "$state" == "running" ]]; then
    printf '%s\n' "Tailscale is already active."
    return 0
  fi

  if [[ "$state" == "starting" ]]; then
    printf '%s\n' "Tailscale is already starting..."
    wait_for_tailscale_active
    printf '%s\n' "Tailscale connected."
    return 0
  fi

  printf '%s\n' "Connecting Tailscale..."
  tailscale up
  wait_for_tailscale_active
  printf '%s\n' "Tailscale connected."
}

disconnect_tailscale() {
  local state
  state="$(tailscale_state)"

  if [[ "$state" == "missing" ]]; then
    printf '%s\n' "Tailscale is not installed on this machine." >&2
    return 1
  fi

  if [[ "$state" != "running" && "$state" != "starting" ]]; then
    printf '%s\n' "Tailscale is already inactive."
    return 0
  fi

  printf '%s\n' "Disconnecting Tailscale..."
  tailscale down
  wait_for_tailscale_inactive
  printf '%s\n' "Tailscale disconnected."
}

resolve_conflict() {
  local target="$1"
  local other="$2"
  local prompt choice

  if (( force )); then
    return 0
  fi

  if ! is_tty; then
    printf '%s\n' "Refusing to switch from $other to $target without a TTY. Re-run with --force." >&2
    return 2
  fi

  prompt="$other is active. Switch to $target?"
  choice="$(prompt_choice "$prompt" "switch" "keep-current" "cancel")" || return $?

  case "$choice" in
    switch)
      return 0
      ;;
    keep-current)
      printf '%s\n' "$other left unchanged." >&2
      return 10
      ;;
    cancel)
      printf '%s\n' "Canceled." >&2
      return 130
      ;;
  esac
}

resolve_dual_active() {
  local preferred="$1"
  local other="$2"
  local prompt choice

  if (( force )); then
    return 0
  fi

  if ! is_tty; then
    printf '%s\n' "Both VPNs are active. Re-run with --force to keep only $preferred." >&2
    return 2
  fi

  prompt="Both VPNs are active. Keep only $preferred?"
  choice="$(prompt_choice "$prompt" "disable-$other" "leave-both-active" "cancel")" || return $?

  case "$choice" in
    "disable-$other")
      return 0
      ;;
    leave-both-active)
      printf '%s\n' "Both VPNs left active." >&2
      return 10
      ;;
    cancel)
      printf '%s\n' "Canceled." >&2
      return 130
      ;;
  esac
}

enable_warp() {
  local warp_status tailscale_status resolution
  warp_status="$(warp_state)"
  tailscale_status="$(tailscale_state)"

  if [[ "$warp_status" == "missing" ]]; then
    printf '%s\n' "Cloudflare WARP is not installed on this machine." >&2
    return 1
  fi

  if [[ "$warp_status" =~ ^(connected|connecting)$ ]] && [[ "$tailscale_status" =~ ^(running|starting)$ ]]; then
    if resolve_dual_active "warp" "tailscale"; then
      resolution=0
    else
      resolution=$?
    fi
    if (( resolution != 0 )); then
      case "$resolution" in
        10)
          return 0
          ;;
        *)
          return "$resolution"
          ;;
      esac
    fi
    disconnect_tailscale
    return 0
  fi

  if [[ "$tailscale_status" =~ ^(running|starting)$ ]]; then
    if resolve_conflict "warp" "tailscale"; then
      resolution=0
    else
      resolution=$?
    fi
    if (( resolution != 0 )); then
      case "$resolution" in
        10)
          return 0
          ;;
        *)
          return "$resolution"
          ;;
      esac
    fi
    disconnect_tailscale
  fi

  connect_warp
}

enable_tailscale() {
  local warp_status tailscale_status resolution
  warp_status="$(warp_state)"
  tailscale_status="$(tailscale_state)"

  if [[ "$tailscale_status" == "missing" ]]; then
    printf '%s\n' "Tailscale is not installed on this machine." >&2
    return 1
  fi

  if [[ "$warp_status" =~ ^(connected|connecting)$ ]] && [[ "$tailscale_status" =~ ^(running|starting)$ ]]; then
    if resolve_dual_active "tailscale" "warp"; then
      resolution=0
    else
      resolution=$?
    fi
    if (( resolution != 0 )); then
      case "$resolution" in
        10)
          return 0
          ;;
        *)
          return "$resolution"
          ;;
      esac
    fi
    disconnect_warp
    return 0
  fi

  if [[ "$warp_status" =~ ^(connected|connecting)$ ]]; then
    if resolve_conflict "tailscale" "warp"; then
      resolution=0
    else
      resolution=$?
    fi
    if (( resolution != 0 )); then
      case "$resolution" in
        10)
          return 0
          ;;
        *)
          return "$resolution"
          ;;
      esac
    fi
    disconnect_warp
  fi

  connect_tailscale
}

disable_requested() {
  local target="${1:-all}"
  local result=0

  case "$target" in
    warp)
      disconnect_warp
      ;;
    tailscale)
      disconnect_tailscale
      ;;
    all)
      if warp_present; then
        disconnect_warp || result=$?
      fi
      if tailscale_present; then
        disconnect_tailscale || result=$?
      fi
      return "$result"
      ;;
    *)
      printf '%s\n' "Unknown off target: $target" >&2
      usage >&2
      return 1
      ;;
  esac
}

interactive_menu() {
  local choice
  print_status >&2
  printf '\n' >&2

  choice="$(prompt_choice "Choose a VPN action:" "warp" "tailscale" "off" "status" "cancel")" || return $?
  case "$choice" in
    warp | tailscale | off | status)
      printf '%s\n' "$choice"
      ;;
    cancel)
      printf '%s\n' "Canceled." >&2
      return 130
      ;;
  esac
}

force=0
args=()

for arg in "$@"; do
  case "$arg" in
    --force)
      force=1
      ;;
    --help | -h)
      usage
      exit 0
      ;;
    -*)
      printf '%s\n' "Unknown flag: $arg" >&2
      usage >&2
      exit 1
      ;;
    *)
      args+=("$arg")
      ;;
  esac
done

set -- "${args[@]}"

if (( $# == 0 )); then
  if is_tty; then
    if selection="$(interactive_menu)"; then
      :
    else
      exit $?
    fi
    set -- "$selection"
  else
    print_status
    printf '\n'
    usage
    exit 0
  fi
fi

case "$1" in
  status)
    print_status
    ;;
  warp)
    enable_warp
    ;;
  tailscale)
    enable_tailscale
    ;;
  off)
    disable_requested "${2:-all}"
    ;;
  *)
    printf '%s\n' "Unknown command: $1" >&2
    usage >&2
    exit 1
    ;;
esac
