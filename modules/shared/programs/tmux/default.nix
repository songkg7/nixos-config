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
          set -g @sessionx-filter-current 'false'
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

    '';
  };
}
