{ config, pkgs, lib, ... }: let
  apps = pkgs.buildEnv {
    name = "home-manager-applications";
    paths = config.home.packages;
    pathsToLink = "/Applications";
  };
in {
  # Enable spotlight application
  home.activation.copyApplications = lib.hm.dag.entryAfter ["writeBoundary"] ''
    BASE_DIR="${config.home.homeDirectory}/Applications/Home Manager Apps"
    mkdir -p "$BASE_DIR"

    declare -a applications

    for app_dir in "$BASE_DIR/"*; do
      applications+=("$(basename "$app_dir")")
    done

    for app_dir in "${apps}/Applications/"*; do
      applications+=("$(basename "$app_dir")")
    done

    for ((i = 0; i < ''${#applications[@]}; i++)); do
      app="''${applications[$i]}"
      rm -rf "$BASE_DIR/$app"

      if [ -d "${apps}/Applications/$app" ]; then
        if [[ "$app" = "1Password.app" ]]; then
          # 1Password는 시스템 Applications에 설치
          rm -rf "/Applications/$app"
          $DRY_RUN_CMD cp ''$VERBOSE_ARG -fHRL "${apps}/Applications/$app" "/Applications"
          $DRY_RUN_CMD chmod ''$VERBOSE_ARG -R +w "/Applications/$app"
        else
          # 다른 앱들은 사용자 Applications에 설치
          $DRY_RUN_CMD cp ''$VERBOSE_ARG -fHRL "${apps}/Applications/$app" "$BASE_DIR"
          $DRY_RUN_CMD chmod ''$VERBOSE_ARG -R +w "$BASE_DIR/$app"
        fi
      fi
    done
  '';

  # disabledModules = ["targets/darwin/linkapps.nix"];  # 기본 linkapps 모듈 사용
}