{ pkgs, ... }:
let
  devCommand = pkgs.writeShellApplication {
    name = "dev";
    runtimeInputs = with pkgs; [
      git
      tmux
      lazygit
    ];
    text = builtins.readFile ./dev.sh;
  };
in
{
  home.packages = [ devCommand ];
}
