{
  environment,
  lib,
  ...
}:
let
  envConfig = (import ../../environments).${environment};
  sshRuntime = envConfig.sshRuntime;
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = envConfig.sshIncludes;
    matchBlocks = lib.mkMerge [
      {
        "tailscale" = {
          host = "macbook-pro14-private imac 42dot";
          forwardAgent = true;
        };
      }

      (lib.optionalAttrs (envConfig.passwordManager.sshIdentityAgent != null) {
        "password-manager-agent" = lib.hm.dag.entryAfter [ "tailscale" ] {
          match = ''exec "test -z \"$SSH_CONNECTION\""'';
          identityAgent = envConfig.passwordManager.sshIdentityAgent;
        };
      })

      (lib.optionalAttrs (sshRuntime.identityAgent != null) {
        "github" = lib.hm.dag.entryAfter [ "tailscale" ] {
          host = "github.com";
          identityAgent = sshRuntime.identityAgent;
          identityFile = sshRuntime.identityFile;
          identitiesOnly = true;
          forwardAgent = false;
        };
      })
    ];
  };
}
