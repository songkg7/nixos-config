{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.onepassword-cli = {
    enable = true;
    enableZshIntegration = true;
    enableFHSEnvironment = true;
  };

  home.packages = with pkgs; [_1password-gui];
}
