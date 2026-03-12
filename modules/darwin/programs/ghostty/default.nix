_: {
  programs.ghostty = {
    enable = true;
    package = null;
    enableZshIntegration = true;
    settings = {
      theme = "Dark Pastel";

      # font
      font-family = [
        "MonaspiceKr Nerd Font Propo"
        "D2CodingLigature Nerd Font Propo"
      ];
      font-thicken = true;
      adjust-cell-height = 1;

      # macOS
      macos-option-as-alt = "left";
      macos-titlebar-style = "tabs";
      macos-non-native-fullscreen = true;

      # window
      window-padding-x = 16;
      window-padding-y = 16;
      window-padding-balance = true;
      window-padding-color = "background";
      window-save-state = "always";
      window-colorspace = "display-p3";
      background-opacity = 0.85;
      background-blur-radius = 10;

      # behavior
      mouse-hide-while-typing = true;
      quit-after-last-window-closed = true;
      shell-integration-features = "cursor,sudo,title,ssh-terminfo";

      # quick terminal
      quick-terminal-position = "top";
      quick-terminal-animation-duration = "0.1";

      # keybind
      keybind = [
        "global:cmd+grave_accent=toggle_quick_terminal"
        "alt+left=unbind"
        "alt+right=unbind"
        # tmux window switching: Cmd+N → prefix(Ctrl+A) + N
        "cmd+one=text:\\x01\\x31"
        "cmd+two=text:\\x01\\x32"
        "cmd+three=text:\\x01\\x33"
        "cmd+four=text:\\x01\\x34"
        "cmd+five=text:\\x01\\x35"
      ];
    };
  };
}
