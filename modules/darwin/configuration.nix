{
  environment,
  lib,
  pkgs,
  ...
}:
{
  security.pam = {
    services.sudo_local.touchIdAuth = true;
  };

  users.users.haril = {
    home = "/Users/haril";
  };

  system.primaryUser = "haril";

  system.stateVersion = 6;

  imports = [
    (import ./programs/homebrew { inherit environment pkgs lib; })
  ];
}
