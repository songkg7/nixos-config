{ pkgs, ... }:
let
  vpnCommand = pkgs.writeShellApplication {
    name = "vpn";
    runtimeInputs = with pkgs; [
      coreutils
      jq
    ];
    text = builtins.readFile ./vpn.sh;
  };
in
{
  home.packages = [ vpnCommand ];
}
