{pkgs, ...}: {
  home.packages = with pkgs; [gh];

  programs.gh = {
    enable = true;
    settings = {
      aliases = {};
      editor = "";
      git_protocol = "ssh";
      prompt = "enabled";
      spinner = "enabled";
    };
    # gitCredentialHelper.enable = false;
  };
}
