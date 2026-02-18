{ lib, ... }:
{
  nixpkgs.overlays = [
    (
      _final: prev:
      let
        catalystOverrides =
          if prev ? llvmPackages_20 then
            {
              llvmPackages_20 = prev.llvmPackages_20.overrideScope (
                _self: super: {
                  compiler-rt-libc = super.compiler-rt-libc.overrideAttrs (old: {
                    cmakeFlags = (old.cmakeFlags or [ ]) ++ [
                      "-DCOMPILER_RT_ENABLE_MACCATALYST=OFF"
                    ];
                  });
                }
              );

            }
          else
            { };
      in
      { } // catalystOverrides
    )
  ];

  nixpkgs.config.allowUnfreePredicate =
    pkg:
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
      "databricks-cli"
      "zsh-abbr"
      "kiro-cli"
    ];

  nixpkgs.config.permittedInsecurePackages = [
    # "figma-linux-0.10.0"
  ];
}
