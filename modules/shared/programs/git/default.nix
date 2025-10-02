{ pkgs, ... }:
{
  imports = [
    ./delta.nix
    ./gh.nix
    ./git.nix
  ];

  home.packages = with pkgs; [
    git-who
  ];

  home.shellAliases = {
    gaa = "git add .";
    gst = "git status";
    gd = "git diff";
    gsta = "git stash";
    gstc = "git stash clear";
    gstp = "git stash pop";
  };
}
