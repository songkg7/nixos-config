{ config, pkgs, ... }:
let
  # Determine if this is a Darwin system
  isDarwin = pkgs.stdenv.isDarwin;
  # Determine the home directory and username based on the system type
  homeDir = if isDarwin then "/Users" else "/home";
  username = if isDarwin && config.system ? primaryUser then config.system.primaryUser else "haril";
in
{
  age = {
    identityPaths = [ "${homeDir}/${username}/.ssh/agenix" ];
    secrets = {
      mise-work-env = {
        file = ./mise-work-env.age;
      };
    };
  };
}
