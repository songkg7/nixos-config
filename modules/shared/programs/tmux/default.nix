{ pkgs, ... }:
let
  tmuxStatusRightLength = 120;

  tmuxJetpackRightConfig = pkgs.writeText "tmux-jetpack-right.toml" ''
    "$schema" = 'https://starship.rs/config-schema.json'

    right_format = """
    $singularity\
    $kubernetes\
    $directory\
    $vcsh\
    $fossil_branch\
    $git_branch\
    $git_commit\
    $git_state\
    $git_status\
    $hg_branch\
    $pijul_channel\
    $docker_context\
    $package\
    $c\
    $cpp\
    $cmake\
    $cobol\
    $daml\
    $dart\
    $deno\
    $dotnet\
    $elixir\
    $elm\
    $erlang\
    $fennel\
    $fortran\
    $golang\
    $guix_shell\
    $haskell\
    $haxe\
    $helm\
    $java\
    $julia\
    $kotlin\
    $gradle\
    $lua\
    $nim\
    $nodejs\
    $ocaml\
    $opa\
    $perl\
    $php\
    $pulumi\
    $purescript\
    $python\
    $raku\
    $rlang\
    $red\
    $ruby\
    $rust\
    $scala\
    $solidity\
    $swift\
    $terraform\
    $vlang\
    $vagrant\
    $xmake\
    $zig\
    $buf\
    $conda\
    $pixi\
    $meson\
    $spack\
    $memory_usage\
    $aws\
    $gcloud\
    $openstack\
    $azure\
    $crystal\
    $custom\
    $status\
    $os\
    $battery\
    $time"""

    [directory]
    home_symbol = "⌂"
    truncation_length = 2
    truncation_symbol = "□ "
    read_only = " ◈"
    use_os_path_sep = true
    style = "italic blue"
    format = '[$path]($style)[$read_only]($read_only_style)'
    repo_root_style = "bold blue"
    repo_root_format = '[$before_root_path]($before_repo_root_style)[$repo_root]($repo_root_style)[$path]($style)[$read_only]($read_only_style) [△](bold bright-blue)'

    [time]
    disabled = false
    format = "[ $time]($style)"
    time_format = "%R"
    utc_time_offset = "local"
    style = "italic dimmed white"

    [battery]
    format = "[ $percentage $symbol]($style)"
    full_symbol = "█"
    charging_symbol = "[↑](italic bold green)"
    discharging_symbol = "↓"
    unknown_symbol = "░"
    empty_symbol = "▃"

    [[battery.display]]
    threshold = 20
    style = "italic bold red"

    [[battery.display]]
    threshold = 60
    style = "italic dimmed bright-purple"

    [[battery.display]]
    threshold = 70
    style = "italic dimmed yellow"

    [git_branch]
    format = " [$branch(:$remote_branch)]($style)"
    symbol = "[△](bold italic bright-blue)"
    style = "italic bright-blue"
    truncation_symbol = "⋯"
    truncation_length = 11
    ignore_branches = ["main", "master"]
    only_attached = true

    [git_status]
    style = "bold italic bright-blue"
    format = "([⎪$ahead_behind$staged$modified$untracked$renamed$deleted$conflicted$stashed⎥]($style))"
    conflicted = "[◪◦](italic bright-magenta)"
    ahead = "[▴│[''${count}](bold white)│](italic green)"
    behind = "[▿│[''${count}](bold white)│](italic red)"
    diverged = "[◇ ▴┤[''${ahead_count}](regular white)│▿┤[''${behind_count}](regular white)│](italic bright-magenta)"
    untracked = "[◌◦](italic bright-yellow)"
    stashed = "[◃◈](italic white)"
    modified = "[●◦](italic yellow)"
    staged = "[▪┤[$count](bold white)│](italic bright-cyan)"
    renamed = "[◎◦](italic bright-blue)"
    deleted = "[✕](italic red)"

    [nodejs]
    format = " [node](italic) [◫ ($version)](bold bright-green)"
    version_format = "''${raw}"
    detect_files = ["package-lock.json", "yarn.lock"]
    detect_folders = ["node_modules"]
    detect_extensions = []

    [python]
    format = " [py](italic) [''${symbol}''${version}]($style)"
    symbol = "[⌉](bold bright-blue)⌊ "
    version_format = "''${raw}"
    style = "bold bright-yellow"

    [ruby]
    format = " [rb](italic) [''${symbol}''${version}]($style)"
    symbol = "◆ "
    version_format = "''${raw}"
    style = "bold red"

    [rust]
    format = " [rs](italic) [$symbol$version]($style)"
    symbol = "⊃ "
    version_format = "''${raw}"
    style = "bold red"

    [package]
    format = " [pkg](italic dimmed) [$symbol$version]($style)"
    version_format = "''${raw}"
    symbol = "◨ "
    style = "dimmed yellow italic bold"

    [aws]
    disabled = true
    format = " [aws](italic) [$symbol $profile $region]($style)"
    style = "bold blue"
    symbol = "▲ "
  '';

  tmuxJetpackRight = pkgs.writeShellApplication {
    name = "tmux-jetpack-right";
    runtimeInputs = [ pkgs.starship ];
    text = ''
      set -euo pipefail

      path="''${1:-$PWD}"
      width="''${2:-${toString tmuxStatusRightLength}}"

      if [ "$width" -gt ${toString tmuxStatusRightLength} ] 2>/dev/null; then
        width=${toString tmuxStatusRightLength}
      fi

      prompt="$(
        STARSHIP_CONFIG=${tmuxJetpackRightConfig} \
        STARSHIP_SHELL=nu \
        starship prompt --right --path "$path" --terminal-width "$width" 2>/dev/null || true
      )"

      printf '%s' "$prompt" | ${pkgs.perl}/bin/perl -pe 's/\e\[[0-9;]*[[:alpha:]]//g; s/\r?\n//g'
    '';
  };
in
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
          set -g status-interval 5
          set -g status-right-length ${toString tmuxStatusRightLength}
          set -g status-right '#{prefix_highlight}#{?window_bigger,[#{window_offset_x}#,#{window_offset_y}] ,}"#{=21:pane_title}" #(${tmuxJetpackRight}/bin/tmux-jetpack-right "#{pane_current_path}" "#{client_width}")'
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
