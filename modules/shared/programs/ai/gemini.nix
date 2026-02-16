_: {
  programs.gemini-cli = {
    enable = true;

    # https://github.com/google-gemini/gemini-cli/blob/main/docs/cli/configuration.md
    settings = {
      general = {
        checkpointing.enabled = true;
      };
      privacy = {
        usageStatisticsEnabled = false;
      };
      security = {
        auth.selectedType = "oauth-personal";
      };
    };
  };
}
