-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.jj" },
  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.pack.python" },
  { import = "astrocommunity.pack.python.ruff" },
  { import = "astrocommunity.pack.go" },
  { import = "astrocommunity.pack.golangci-lint" },
  { import = "astrocommunity.pack.bash" },
  { import = "astrocommunity.pack.docker" },
  { import = "astrocommunity.pack.kotlin" },
  { import = "astrocommunity.pack.mdx" },
  { import = "astrocommunity.pack.nix" },
  { import = "astrocommunity.pack.spring-boot" },
  { import = "astrocommunity.pack.toml" },
  { import = "astrocommunity.pack.typescript" },
  -- import/override with your plugins folder
  { import = "astrocommunity.completion.copilot-lua-cmp" },
  { import = "astrocommunity.code-runner.vim-slime" },
  { import = "astrocommunity.utility.live-preview" },

  -- Colorscheme
  { import = "astrocommunity.colorscheme.kanagawa-nvim", enabled = true },
  { import = "astrocommunity.colorscheme.rose-pine" },
  { import = "astrocommunity.colorscheme.oxocarbon-nvim" },
  { import = "astrocommunity.colorscheme.catppuccin", enabled = true },
  { import = "astrocommunity.colorscheme.tokyonight-nvim" },
  { import = "astrocommunity.colorscheme.tokyodark-nvim" },
  { import = "astrocommunity.colorscheme.cyberdream-nvim" },

  -- Motion
  { import = "astrocommunity.motion.leap-nvim" },
  { import = "astrocommunity.motion.flash-nvim" },
  { import = "astrocommunity.motion.nvim-surround" },
  { import = "astrocommunity.lsp.lsp-signature-nvim" },
  { import = "astrocommunity.media.presence-nvim" },

  -- Git
  { import = "astrocommunity.git.git-blame-nvim" },

  -- Editing Support
  { import = "astrocommunity.editing-support.vim-visual-multi" },
  -- { import = "astrocommunity.editing-support.multiple-cursors-nvim" },
  { import = "astrocommunity.editing-support.auto-save-nvim" },
  { import = "astrocommunity.editing-support.neogen" },
}
