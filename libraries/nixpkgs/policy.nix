{ lib }:
let
  overlays = [
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
      {
        # ponytail: skip stale upstream snapshots; remove when nixpkgs updates statix.
        statix = prev.statix.overrideAttrs (_: {
          checkFlags = [
            "--skip=empty_list_concat_676800f4240e26802590a123362636e6_fix"
            "--skip=manual_inherit_2a92c1cb560d2d727373fb3ad10da2b1_fix"
          ];
        });
      }
      // catalystOverrides
    )
  ];
in
{
  inherit overlays;

  config = {
    allowUnfreePredicate =
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
        "acli"
      ];

    permittedInsecurePackages = [
      # "figma-linux-0.10.0"
    ];
  };
}
