{ pkgs, ... }:
let
  workStartCommand = pkgs.writeShellApplication {
    name = "work-start";
    runtimeInputs = with pkgs; [ coreutils ];
    text = builtins.readFile ./work-start.sh;
  };
in
{
  home.packages = [ workStartCommand ];
}
