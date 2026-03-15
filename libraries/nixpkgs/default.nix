{ lib, ... }:
let
  policy = import ./policy.nix { inherit lib; };
in
{
  nixpkgs.overlays = policy.overlays;
  nixpkgs.config.allowUnfreePredicate = policy.config.allowUnfreePredicate;
  nixpkgs.config.permittedInsecurePackages = policy.config.permittedInsecurePackages;
}
