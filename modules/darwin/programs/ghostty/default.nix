{ lib, ... }:
{
  programs.ghostty = {
    enable = true;
    package = null;
    # Disabled: home-manager's snippet unconditionally sources
    # "$GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration",
    # which ENOENTs inside cmux.app (cmux sets GHOSTTY_RESOURCES_DIR but
    # ships its own integration via ZDOTDIR instead, see cmux PR #1316).
    # Replaced by the guarded source block in programs.zsh.initContent below.
    enableZshIntegration = false;
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
        "super+digit_1=text:\\x01\\x31"
        "super+digit_2=text:\\x01\\x32"
        "super+digit_3=text:\\x01\\x33"
        "super+digit_4=text:\\x01\\x34"
        "super+digit_5=text:\\x01\\x35"
      ];
    };
  };

  programs.zsh.initContent = lib.mkAfter ''
    if [[ -z $CMUX_SHELL_INTEGRATION_DIR && -n $GHOSTTY_RESOURCES_DIR \
          && -r "$GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration" ]]; then
      source "$GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration"
    fi
  '';
}
