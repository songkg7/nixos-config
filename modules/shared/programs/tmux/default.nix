{ pkgs, ... }:
{
  home.packages = with pkgs; [
    tmuxinator
  ];

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
          set -g @sessionx-tmuxinator-mode 'on'
          set -g @sessionx-fzf-marks-mode 'on'
          set -g @sessionx-filter-current 'true'
          set -g @sessionx-preview-location 'right'
          set -g @sessionx-preview-ratio '55%'
          set -g @sessionx-bind-select-up 'ctrl-p'
          set -g @sessionx-bind-select-down 'ctrl-n'
        '';
      }
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = ''
          set -g @resurrect-capture-pane-contents 'on'
        '';
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '15'
        '';
      }
      {
        plugin = tmuxPlugins."prefix-highlight";
        extraConfig = ''
          # prefix/copy-mode indicator in status line
          set -g @prefix_highlight_fg 'black'
          set -g @prefix_highlight_bg 'yellow'
          set -g @prefix_highlight_copy_mode_attr 'fg=black,bg=green'
          set -g @prefix_highlight_show_copy_mode 'on'
          set -g status-right '#{prefix_highlight}#{?window_bigger,[#{window_offset_x}#,#{window_offset_y}] ,}"#{=21:pane_title}" %H:%M %d-%b-%y'
        '';
      }
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.extrakto
    ];

    extraConfig = ''
      # pane split
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      # new window at current path
      bind c new-window -c "#{pane_current_path}"

      # reload config
      bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded"

      # new/attach session
      bind-key C command-prompt -p "New Session:" "new-session -A -s '%%'"

      # layout shortcuts (avoid Alt key conflicts with Aerospace)
      bind-key H select-layout even-horizontal
      bind-key J select-layout even-vertical
      bind-key K select-layout tiled

      # Prevent vim-tmux-navigator from wrapping at pane edges.
      bind-key -n C-h if-shell "ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+/)?g?\\.?(view|l?n?vim?x?|fzf)(diff)?(-wrapped)?$'" { send-keys C-h } { if-shell -F '#{pane_at_left}' {} { select-pane -L } }
      bind-key -n C-j if-shell "ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+/)?g?\\.?(view|l?n?vim?x?|fzf)(diff)?(-wrapped)?$'" { send-keys C-j } { if-shell -F '#{pane_at_bottom}' {} { select-pane -D } }
      bind-key -n C-k if-shell "ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+/)?g?\\.?(view|l?n?vim?x?|fzf)(diff)?(-wrapped)?$'" { send-keys C-k } { if-shell -F '#{pane_at_top}' {} { select-pane -U } }
      bind-key -n C-l if-shell "ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+/)?g?\\.?(view|l?n?vim?x?|fzf)(diff)?(-wrapped)?$'" { send-keys C-l } { if-shell -F '#{pane_at_right}' {} { select-pane -R } }
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi V send-keys -X select-line
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      bind-key -T copy-mode-vi Escape send-keys -X clear-selection
      bind-key -T copy-mode-vi C-h if-shell -F '#{pane_at_left}' {} { select-pane -L }
      bind-key -T copy-mode-vi C-j if-shell -F '#{pane_at_bottom}' {} { select-pane -D }
      bind-key -T copy-mode-vi C-k if-shell -F '#{pane_at_top}' {} { select-pane -U }
      bind-key -T copy-mode-vi C-l if-shell -F '#{pane_at_right}' {} { select-pane -R }

    '';
  };
}
