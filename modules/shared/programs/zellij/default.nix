_: {
  programs.zellij = {
    enable = true;

    attachExistingSession = false;
    exitShellOnExit = false;

    enableZshIntegration = true;

    settings = {
      keybinds = {
        unbind = "Ctrl b";
        shared_except = {
          _args = [ "locked" "tmux" ];
          bind = {
            _args = [ "Ctrl a" ];
            SwitchToMode = "Tmux";
          };
        };
        tmux = {
          bind = {
            _args = [ "Ctrl a" ];
            SwitchToMode = "Normal";
          };
        };
      };
    };
  };
}
