{ pkgs, ... }:
let
  darwinUtils = import ../../utils.nix { inherit pkgs; };
  inherit (darwinUtils) brewPrefix;

  keybindings = import ./keybindings.nix;
  windowRules = import ./window-rules.nix;
in
{
  programs.aerospace = {
    enable = true;
    launchd.enable = true;

    settings = {
      # Startup configuration
      after-login-command = [ ];
      after-startup-command = [ ];
      start-at-login = true;

      # Focus and mouse behavior
      on-focus-changed = [ "move-mouse window-lazy-center" ];

      # Normalizations
      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;

      # Layout configuration
      accordion-padding = 30;
      default-root-container-layout = "tiles";
      default-root-container-orientation = "auto";

      # Key mapping
      key-mapping.preset = "qwerty";

      # Gaps configuration
      gaps = {
        inner = {
          horizontal = 10;
          vertical = 10;
        };
        outer = {
          left = 0;
          bottom = 0;
          top = 0;
          right = 0;
        };
      };

      # Execution environment
      exec = {
        inherit-env-vars = true;
        env-vars = {
          PATH = "${brewPrefix}/bin:${brewPrefix}/sbin:\${PATH}";
        };
      };
    }
    // keybindings
    // windowRules;
  };
}
