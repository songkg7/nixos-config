{
  programs.starship = {
    enable = true;
    presets = [ "pure-preset" ];
    settings.cmd_duration.format = " [$duration]($style) ";
    enableZshIntegration = true;
  };
}

