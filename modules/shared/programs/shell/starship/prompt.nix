{
  character = {
    format = "$symbol ";
    success_symbol = "[◎](bold italic bright-yellow)";
    error_symbol = "[○](italic purple)";
    vimcmd_symbol = "[■](italic dimmed green)";
    vimcmd_replace_one_symbol = "◌";
    vimcmd_replace_symbol = "□";
    vimcmd_visual_symbol = "▼";
  };

  env_var = {
    VIMSHELL = {
      format = "[$env_value]($style)";
      style = "green italic";
    };
  };

  sudo = {
    format = "[$symbol]($style)";
    style = "bold italic bright-purple";
    symbol = "⋈┈";
    disabled = false;
  };

  username = {
    style_user = "bright-yellow bold italic";
    style_root = "purple bold italic";
    format = "[ ⭘ $user]($style) ";
    disabled = false;
    show_always = false;
  };

  directory = {
    home_symbol = "⌂";
    truncation_length = 2;
    truncation_symbol = "□ ";
    read_only = " ◈";
    use_os_path_sep = true;
    style = "italic blue";
    format = "[$path]($style)[$read_only]($read_only_style) ";
    repo_root_style = "bold blue";
    repo_root_format = "[$before_root_path]($before_repo_root_style)[$repo_root]($repo_root_style)[$path]($style)[$read_only]($read_only_style) [△](bold bright-blue)";
  };

  cmd_duration = {
    format = "[◄ $duration ](italic white)";
  };

  jobs = {
    format = "[$symbol$number]($style) ";
    style = "white";
    symbol = "[▶](blue italic)";
  };

  localip = {
    ssh_only = true;
    format = " ◯ [$localipv4](bold magenta)";
    disabled = false;
  };

  time = {
    disabled = false;
    format = "[ $time]($style)";
    time_format = "%R";
    utc_time_offset = "local";
    style = "italic dimmed white";
  };

  battery = {
    format = "[ $percentage $symbol]($style)";
    full_symbol = "█";
    charging_symbol = "[↑](italic bold green)";
    discharging_symbol = "↓";
    unknown_symbol = "░";
    empty_symbol = "▃";
    display = [
      {
        threshold = 20;
        style = "italic bold red";
      }
      {
        threshold = 60;
        style = "italic dimmed bright-purple";
      }
      {
        threshold = 70;
        style = "italic dimmed yellow";
      }
    ];
  };

  nix_shell = {
    style = "bold italic dimmed blue";
    symbol = "✶";
    format = "[$symbol nix⎪$state⎪]($style) [$name](italic dimmed white)";
    impure_msg = "[⌽](bold dimmed red)";
    pure_msg = "[⌾](bold dimmed green)";
    unknown_msg = "[◌](bold dimmed yellow)";
  };
}
