#!/usr/bin/env bash
# dev - worktree + tmux session automation for parallel agent coding
set -euo pipefail

SCRIPT_NAME="dev"

usage() {
  cat <<EOF
Usage:
  $SCRIPT_NAME <branch-name>       Create worktree + tmux session (3 windows)
  $SCRIPT_NAME -l                  List active dev sessions
  $SCRIPT_NAME -c <branch-name>    Clean up a specific dev session
  $SCRIPT_NAME -c --all            Clean up all dev sessions
EOF
}

get_repo_name() {
  basename "$(git rev-parse --show-toplevel)"
}

get_worktree_path() {
  local repo_root branch
  repo_root="$(git rev-parse --show-toplevel)"
  branch="$1"
  echo "$(dirname "$repo_root")/$(get_repo_name)-${branch}"
}

session_name() {
  echo "dev-$1"
}

cmd_create() {
  local branch="$1"
  local wt_path session

  wt_path="$(get_worktree_path "$branch")"
  session="$(session_name "$branch")"

  # Reattach if session already exists
  if tmux has-session -t "$session" 2>/dev/null; then
    echo "Session '$session' already exists. Attaching..."
    tmux attach-session -t "$session"
    return
  fi

  # Create worktree if it doesn't exist
  if [[ ! -d "$wt_path" ]]; then
    echo "Creating worktree at $wt_path..."
    git worktree add "$wt_path" -b "$branch" 2>/dev/null \
      || git worktree add "$wt_path" "$branch"
  fi

  # Create tmux session with 3 windows
  tmux new-session -d -s "$session" -c "$wt_path" -n "shell"
  tmux new-window -t "$session" -c "$wt_path" -n "lazygit"
  tmux send-keys -t "$session:lazygit" "lazygit" C-m
  tmux new-window -t "$session" -c "$wt_path" -n "editor"

  # Select first window and attach
  tmux select-window -t "$session:shell"
  echo "Created session '$session' with 3 windows: shell, lazygit, editor"
  tmux attach-session -t "$session"
}

cmd_cleanup() {
  local branch="$1"
  local wt_path session

  wt_path="$(get_worktree_path "$branch")"
  session="$(session_name "$branch")"

  # Kill tmux session
  if tmux has-session -t "$session" 2>/dev/null; then
    tmux kill-session -t "$session"
    echo "Killed tmux session '$session'"
  else
    echo "No tmux session '$session' found"
  fi

  # Remove worktree
  if [[ -d "$wt_path" ]]; then
    git worktree remove "$wt_path" --force
    echo "Removed worktree '$wt_path'"
  else
    echo "No worktree at '$wt_path'"
  fi
}

cmd_cleanup_all() {
  local sessions
  sessions="$(tmux list-sessions -F '#{session_name}' 2>/dev/null | grep '^dev-' || true)"

  if [[ -z "$sessions" ]]; then
    echo "No active dev sessions found"
    return
  fi

  while IFS= read -r session; do
    local branch="${session#dev-}"
    cmd_cleanup "$branch"
  done <<< "$sessions"
}

cmd_list() {
  local sessions
  sessions="$(tmux list-sessions -F '#{session_name}: #{session_windows} windows (#{session_attached} attached)' 2>/dev/null | grep '^dev-' || true)"

  if [[ -z "$sessions" ]]; then
    echo "No active dev sessions"
    return
  fi

  echo "Active dev sessions:"
  echo "$sessions"

  echo ""
  echo "Worktrees:"
  git worktree list | grep -v "$(git rev-parse --show-toplevel)$" || echo "  (none)"
}

# --- Main ---

if [[ $# -eq 0 ]]; then
  usage
  exit 1
fi

case "$1" in
  -l | --list)
    cmd_list
    ;;
  -c | --clean)
    shift
    if [[ "${1:-}" == "--all" ]]; then
      cmd_cleanup_all
    elif [[ -n "${1:-}" ]]; then
      cmd_cleanup "$1"
    else
      echo "Error: specify a branch name or --all"
      exit 1
    fi
    ;;
  -h | --help)
    usage
    ;;
  *)
    cmd_create "$1"
    ;;
esac
