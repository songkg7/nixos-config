_: {
  programs.zellij = {
    enable = true;
    enableZshIntegration = false;
    attachExistingSession = false;
    exitShellOnExit = false;

    settings = {
      keybinds = {
        unbind = "Ctrl b";
        shared_except = {
          _args = [
            "locked"
            "tmux"
          ];
          bind = {
            _args = [ "Ctrl a" ];
            SwitchToMode = "Tmux";
          };
        };
        locked = {
          bind = {
            _args = [ "Ctrl a" ];
            SwitchToMode = "Tmux";
          };
        };
        tmux = {
          _children = [
            {
              bind = {
                _args = [ "Ctrl a" ];
                SwitchToMode = "Normal";
              };
            }
            {
              bind = {
                _args = [ "g" ];
                SwitchToMode = "Locked";
              };
            }
          ];
        };
      };
    };
  };
}
