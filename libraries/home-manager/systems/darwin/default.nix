{ config, pkgs, lib, ... }: let
  apps = pkgs.buildEnv {
    name = "home-manager-applications";
    paths = config.home.packages;
    pathsToLink = "/Applications";
  };
in {
  # 1Password만 시스템 Applications에 특별 설치
  home.activation.copy1Password = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ -d "${apps}/Applications/1Password.app" ]; then
      rm -rf "/Applications/1Password.app"
      $DRY_RUN_CMD cp ''$VERBOSE_ARG -fHRL "${apps}/Applications/1Password.app" "/Applications"
      $DRY_RUN_CMD chmod ''$VERBOSE_ARG -R +w "/Applications/1Password.app"
    fi
  '';
}