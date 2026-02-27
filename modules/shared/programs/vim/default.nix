{
  lib,
  pkgs,
  ...
}:
{
  home.sessionVariables = {
    EDITOR = lib.mkDefault "vi";
  };

  home.packages = with pkgs; [
    neovim
    wget
    imagemagick
    ghostscript
    tectonic
    mermaid-cli
    gdu
    tree-sitter
    bottom
    gettext
  ];

  home.file.".config/nvim" = {
    source = ./astro;
    recursive = true;
  };

  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };
}
