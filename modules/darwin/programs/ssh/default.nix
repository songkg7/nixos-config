{
  lib,
  profileConfig,
  ...
}:
let
  sshRuntime = profileConfig.ssh.runtime;
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = profileConfig.ssh.includes;
    settings = lib.mkMerge [
      {
        "tailscale" = {
          host = "macbook-pro14-private imac 42dot";
          forwardAgent = true;
        };
      }

      (lib.optionalAttrs (profileConfig.passwordManager.sshIdentityAgent != null) {
        "password-manager-agent" = lib.hm.dag.entryAfter [ "tailscale" ] {
          match = ''exec "test -z \"$SSH_CONNECTION\""'';
          identityAgent = profileConfig.passwordManager.sshIdentityAgent;
        };

        "github.com" = lib.hm.dag.entryAfter [ "password-manager-agent" ] {
          user = "git";
          identityAgent = profileConfig.passwordManager.sshIdentityAgent;
          forwardAgent = false;
        };
      })

      (lib.optionalAttrs (sshRuntime.identityAgent != null) {
        "github.com" = lib.hm.dag.entryAfter [ "tailscale" ] {
          user = "git";
          addKeysToAgent = "yes";
          identityAgent = sshRuntime.identityAgent;
          identityFile = sshRuntime.identityFile;
          identitiesOnly = true;
          forwardAgent = false;
        };
      })
    ];
  };
}
