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
      "mise.work.toml" = {
        file = ./mise-work-env.age;
        # FIXME: Use `config.age.secrest.<name>.path` instead.
        path = "/${homeDir}/${username}/.config/mise/conf.d/mise.work.toml";
        owner = config.users.users.haril.name;
        mode = "770";
      };
    };
  };
}
