{ config, pkgs, lib, ... }: {
  # 1Password를 Homebrew로 관리
  homebrew.casks = [ "1password" ];
}