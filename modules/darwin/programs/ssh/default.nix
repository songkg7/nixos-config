{
  environment,
  lib,
  ...
}:
let
  envConfig = (import ../../environments).${environment};
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = envConfig.sshIncludes;
    matchBlocks = {
      "tailscale" = {
        host = "macbook-pro14-private imac 42dot";
        forwardAgent = true;
      };

      "password-manager-agent" = lib.hm.dag.entryAfter [ "tailscale" ] {
        match = ''exec "test -z \"$SSH_CONNECTION\""'';
        identityAgent = envConfig.passwordManager.sshIdentityAgent;
      };
    };
  };
}
