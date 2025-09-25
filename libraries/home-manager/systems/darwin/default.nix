{ config, pkgs, lib, ... }: let
  # 1Password를 제외한 패키지들로 apps 환경 구성
  appsWithout1Password = pkgs.buildEnv {
    name = "home-manager-applications-without-1password";
    paths = lib.filter (pkg: lib.getName pkg != "1password") config.home.packages;
    pathsToLink = "/Applications";
  };
  
  # 전체 패키지들로 apps 환경 구성 (1Password 포함)
  apps = pkgs.buildEnv {
    name = "home-manager-applications";
    paths = config.home.packages;
    pathsToLink = "/Applications";
  };
in {
  # 1Password를 기본 링크에서 제거하고 시스템 Applications에 설치
  home.activation.copy1Password = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # 기본 Home Manager 링크에서 1Password 제거
    if [ -L "${config.home.homeDirectory}/Applications/1Password.app" ]; then
      rm -f "${config.home.homeDirectory}/Applications/1Password.app"
    fi
    
    # 시스템 Applications에 1Password 설치
    if [ -d "${apps}/Applications/1Password.app" ]; then
      rm -rf "/Applications/1Password.app"
      $DRY_RUN_CMD cp ''$VERBOSE_ARG -fHRL "${apps}/Applications/1Password.app" "/Applications"
      $DRY_RUN_CMD chmod ''$VERBOSE_ARG -R +w "/Applications/1Password.app"
    fi
  '';
}