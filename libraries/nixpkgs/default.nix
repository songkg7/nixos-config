{lib, ...}: {
  nixpkgs.overlays = [
    (final: _prev: {
      # cleanshot = final.callPackage ./programs/cleanshot {};
      # clop = final.callPackage ./programs/clop {};
      # git-spr = final.callPackage ./programs/git-spr {};
      # hammerspoon = final.callPackage ./programs/hammerspoon {};
      homerow = final.callPackage ./programs/homerow {};
      # nix-activate = final.callPackage ./programs/nix-activate {};
    })
  ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      # pkgs
      "1password"
      "1password-cli"
      "obsidian"
      "raycast"
      "discord"
      "slack"
      "claude-code"
      # "cleanshot"
      "cursor"
      # "cursor-cli"
      "jetbrains-toolbox"
      "datagrip"
      "homerow"
      "idea-ultimate"
      "ngrok"
      "onepassword-password-manager"
    ];

  nixpkgs.config.permittedInsecurePackages = [
    # "figma-linux-0.10.0"
  ];
}
