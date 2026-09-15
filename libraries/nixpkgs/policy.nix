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
        # statix tests invoke cargo recursively; run them serially to avoid
        # flaky snapshots caused by concurrent cargo invocations.
        statix = prev.statix.overrideAttrs (_: {
          checkFlags = [
            "--skip=empty_list_concat_676800f4240e26802590a123362636e6_fix"
            "--skip=manual_inherit_2a92c1cb560d2d727373fb3ad10da2b1_fix"
          ];
          dontUseCargoParallelTests = true;
        });

        # aiohttp's websocket shutdown test is timing-sensitive when its
        # upstream pytest-xdist suite runs in parallel on Darwin.
        python313Packages =
          if prev.stdenv.isDarwin then
            prev.python313Packages.overrideScope (
              _self: pythonPrev: {
                aiohttp = pythonPrev.aiohttp.overrideAttrs (old: {
                  pytestFlags = (old.pytestFlags or [ ]) ++ [ "-n" "0" ];
                });
              }
            )
          else
            prev.python313Packages;
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
