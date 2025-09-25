{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./programs/homebrew
  ];

  # Disable nix-darwin's Nix management to work with Determinate
  security.pam = {
    services.sudo_local.touchIdAuth = true;
  };

  users.users.haril = {
    home = "/Users/haril";
  };

  system.primaryUser = "haril";

  system.stateVersion = 6;
}
