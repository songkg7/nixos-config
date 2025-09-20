{
  config,
  pkgs,
  ...
}: {
  # Disable nix-darwin's Nix management to work with Determinate
  security.pam = {
    services.sudo_local.touchIdAuth = true;
  };

  programs.zsh = {
    enable = true;
  };

  users.users.haril = {
    home = "/Users/haril";
  };

  system.primaryUser = "haril";

  system.stateVersion = 6;
}
