{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nil
    nixfmt-tree
    nixVersions.stable
  ];
}
