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

  programs.nixvim = {
    enable = true;

    viAlias = true;
    vimAlias = true;

    # colorscheme = "catppuccin";
    # colorschemes.catppuccin.enable = true;

    # performance.byteCompileLua = {
    #   enable = true;
    #   configs = true;
    #   initLua = true;
    #   nvimRuntime = true;
    #   plugins = true;
    # };

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    # opts = {
    #   number = true;
    #   relativenumber = true;
    #
    #   clipboard = "unnamedplus";
    #
    #   splitbelow = true;
    #   splitright = true;
    #
    #   list = true;
    #   listchars = "trail:⋅,tab:» ,nbsp:␣";
    #
    #   wrap = false;
    #
    #   expandtab = true;
    #   shiftwidth = 4;
    #   tabstop = 4;
    #
    #   scrolloff = 10;
    #   virtualedit = "block";
    #
    #   inccommand = "split";
    #   cursorline = true;
    #   ignorecase = true;
    #   termguicolors = true;
    # };

    # plugins = {
    #   lsp = {
    #     enable = true;
    #     servers = {
    #       nixd.enable = true;
    #       pyright.enable = true;
    #       ruff.enable = true;
    #     };
    #   };
      # mini = {
      #   enable = true;
      #   mockDevIcons = true;
      #   modules = { };
      # };
    # };

    # extraPlugins = {};
    plugins = with pkgs.vimPlugins; [
      astrocore
      astrotheme
      astroui
      astrolsp
      mason-nvim-dap-nvim
    ];
    # extraConfigLuaPre = ''
    #   require("github-theme").setup(${
    #     toLua {
    #       options = {
    #         transparent = true;
    #       };
    #       groups.github_dark_default = {
    #         CursorLine = {
    #           bg = "bg2";
    #         };
    #       };
    #     }
    #   })
    # '';
  };
}
