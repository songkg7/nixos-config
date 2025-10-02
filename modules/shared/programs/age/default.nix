{
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs.stdenvNoCC.hostPlatform) isDarwin isLinux;
in {
  age = {
    identityPaths = [
      (lib.mkIf isDarwin "/Users/haril/.ssh/id_ed25519_agenix")
      (lib.mkIf isLinux "/home/haril/.ssh/id_ed25519_agenix")
    ];
    secrets = {
      test-secret = {
        file = ./secrets/test-secret.age;
        # path = "/run/secrets/test-secret";
        # owner = "haril";
        # group = "staff";
        # mode = "400";
      };
      secret1 = {
        file = ./secrets/secret1.age;
      };
    };
  };
}
