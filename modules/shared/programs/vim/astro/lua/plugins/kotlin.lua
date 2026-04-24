local function remove_values(list, values)
  local remove = {}
  for _, value in ipairs(values) do
    remove[value] = true
  end

  local result = {}
  for _, value in ipairs(list or {}) do
    if not remove[value] then table.insert(result, value) end
  end
  return result
end

local function prefer_kotlin_lsp(opts)
  local astrocore = require "astrocore"

  opts.ensure_installed = remove_values(opts.ensure_installed, { "kotlin_language_server" })
  opts.ensure_installed = astrocore.list_insert_unique(opts.ensure_installed, { "kotlin_lsp" })

  if opts.automatic_enable == false then return end

  if type(opts.automatic_enable) == "table" and opts.automatic_enable.exclude then
    opts.automatic_enable.exclude =
      astrocore.list_insert_unique(opts.automatic_enable.exclude, { "kotlin_language_server" })
  elseif type(opts.automatic_enable) == "table" then
    opts.automatic_enable = remove_values(opts.automatic_enable, { "kotlin_language_server" })
    opts.automatic_enable = astrocore.list_insert_unique(opts.automatic_enable, { "kotlin_lsp" })
  else
    opts.automatic_enable = { exclude = { "kotlin_language_server" } }
  end
end

---@type LazySpec
return {
  {
    "AstroNvim/astrolsp",
    optional = true,
    opts = function(_, opts)
      opts.handlers = opts.handlers or {}
      opts.handlers.kotlin_language_server = function() end
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    optional = true,
    opts = prefer_kotlin_lsp,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = remove_values(opts.ensure_installed, { "kotlin-language-server" })
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "kotlin-lsp" })
    end,
  },
}
