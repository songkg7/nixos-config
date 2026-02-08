{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    mouse = true;
    baseIndex = 1;
    escapeTime = 0;
    terminal = "tmux-256color";
    historyLimit = 10000;
    keyMode = "vi";

    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.tmux-sessionx;
        extraConfig = ''
          set -g @sessionx-bind 'o'
          set -g @sessionx-zoxide-mode 'on'
          set -g @sessionx-filter-current 'false'
          set -g @sessionx-preview-location 'right'
          set -g @sessionx-preview-ratio '55%'
          set -g @sessionx-bind-select-up 'ctrl-p'
          set -g @sessionx-bind-select-down 'ctrl-n'
        '';
      }
    ];

    extraConfig = ''
      # pane split
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      # pane navigation - vim style
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # new window at current path
      bind c new-window -c "#{pane_current_path}"

      # reload config
      bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded"

      # new/attach session
      bind-key C command-prompt -p "New Session:" "new-session -A -s '%%'"
    '';
  };
}
