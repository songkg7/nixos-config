{ lib, pkgs, ... }:
let
  inherit (pkgs.stdenvNoCC.hostPlatform) isDarwin isLinux;
in
{
  nix = {
    optimise = {
      automatic = true;
    };
    settings = {
      substituters = [
        "https://cache.nixos.org"
      ];
      # trusted-public-keys = [
      #   "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      # ];
    };
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      experimental-features = nix-command flakes
    '';
  };

  age = {
    identityPaths = [
      # FIXME: use home directory variable
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
