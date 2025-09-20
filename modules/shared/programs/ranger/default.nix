{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.ranger = {
    enable = true;
  };
}
