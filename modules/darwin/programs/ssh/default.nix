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

      "1password-agent" = lib.hm.dag.entryAfter [ "tailscale" ] {
        match = ''exec "test -z \"$SSH_CONNECTION\""'';
        identityAgent = "~/Library/Group\\ Containers/2BUA8C4S2C.com.1password/t/agent.sock";
      };
    };
  };
}
