{
  lib,
  profileConfig,
  ...
}:
let
  passwordManager = profileConfig.passwordManager;
  sshRuntime = profileConfig.ssh.runtime;
  passwordManagerSshHostSettings = builtins.listToAttrs (
    map (host: {
      name = host;
      value = lib.hm.dag.entryAfter [ "password-manager-agent" ] {
        user = "git";
        identityAgent = passwordManager.sshIdentityAgent;
        forwardAgent = false;
      };
    }) passwordManager.sshHosts
  );
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

      (lib.optionalAttrs (passwordManager.sshIdentityAgent != null) (
        {
          "password-manager-agent" = lib.hm.dag.entryAfter [ "tailscale" ] {
            match = ''exec "test -z \"$SSH_CONNECTION\""'';
            identityAgent = passwordManager.sshIdentityAgent;
          };
        }
        // passwordManagerSshHostSettings
      ))

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
