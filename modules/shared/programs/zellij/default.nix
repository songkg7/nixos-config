_: {
  programs.zellij = {
    enable = true;
    enableZshIntegration = false;
    attachExistingSession = false;
    exitShellOnExit = false;

    settings = {
      # Unlock-first workflow: start locked, then use Ctrl-g to unlock and issue Zellij commands.
      default_mode = "locked";
    };
  };
}
