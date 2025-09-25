{ config, pkgs, lib, ... }: {
  # Homebrew 모듈 활성화
  homebrew.enable = true;
  
  # 1Password를 Homebrew로 관리
  homebrew.casks = [ "1password" ];
}