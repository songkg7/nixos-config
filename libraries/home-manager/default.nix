{ pkgs, ... }:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupCommand = "${pkgs.trash-cli}/bin/trash-put";
  home-manager.sharedModules = [ ./shared-user.nix ];
}
