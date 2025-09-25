{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenvNoCC.hostPlatform) isLinux;
  toLua = lib.generators.toLua {};
in {
  home.sessionVariables = {
    EDITOR = lib.mkDefault "vi";
  };

  home.packages = with pkgs; [
    neovim
    gdu
    tree-sitter
    bottom
  ];

  # 로컬 astro 파일들을 ~/.config/nvim에 복사
  home.file.".config/nvim" = {
    source = ./astro;
    recursive = true;
  };

  programs.nixvim = {
    enable = true;

    viAlias = true;
    vimAlias = true;

    # AstroNvim 설정을 사용하므로 기본 설정은 비활성화
    # globals = {
    #   mapleader = " ";
    #   maplocalleader = " ";
    # };

    # TODO: 적용 방법을 알아내면 다시 활성화
    # extraPlugins = with pkgs.vimPlugins; [
    #   astrocore
    #   astrotheme
    #   astroui
    #   astrolsp
    #   mason-nvim-dap-nvim
    #   mason-null-ls-nvim
    # ];
  };
}
