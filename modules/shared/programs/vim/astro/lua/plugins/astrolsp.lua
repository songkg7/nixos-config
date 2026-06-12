-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
-- Configuration documentation can be found with `:h astrolsp`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

local safe_lsp_location = {}

local function jar_uri_to_zipfile_name(name)
  if type(name) ~= "string" or not vim.startswith(name, "jar:") then return name end

  local archive, entry = name:match "^jar:(.-)!/(.+)$"
  if not archive or not entry then return name end

  local archive_path
  if vim.startswith(archive, "file:") then
    archive_path = vim.uri_to_fname(archive)
  elseif vim.startswith(archive, "/") then
    archive_path = vim.uri_to_fname("file:" .. archive)
  else
    archive_path = vim.uri_decode(archive)
  end

  return ("zipfile://%s::%s"):format(archive_path, vim.uri_decode(entry))
end

local function normalize_item(item)
  local normalized = vim.deepcopy(item)
  normalized.filename = jar_uri_to_zipfile_name(normalized.filename)
  return normalized
end

local function open_location_list(opts)
  vim.fn.setloclist(0, {}, " ", {
    title = opts.title or "LSP locations",
    items = opts.items or {},
    context = opts.context,
  })
  vim.cmd.lopen()
end

local function notify_invalid_location(item, line_count)
  local target = item.filename or ("buffer " .. tostring(item.bufnr))
  vim.notify(
    ("LSP returned an invalid location: %s:%s, but the opened buffer has %s lines"):format(
      target,
      tostring(item.lnum),
      tostring(line_count)
    ),
    vim.log.levels.WARN
  )
end

local function jump_to_item(item)
  local bufnr = item.bufnr
  if (not bufnr or bufnr == 0) and item.filename and item.filename ~= "" then
    bufnr = vim.fn.bufadd(item.filename)
  end
  if not bufnr or bufnr == 0 then return false end

  vim.bo[bufnr].buflisted = true
  local loaded = pcall(vim.fn.bufload, bufnr)
  if not loaded then return false end

  local line_count = vim.api.nvim_buf_line_count(bufnr)
  local lnum = tonumber(item.lnum) or 1
  local col = math.max((tonumber(item.col) or 1) - 1, 0)
  if lnum < 1 or lnum > line_count then
    notify_invalid_location(item, line_count)
    return false
  end

  local win = vim.api.nvim_get_current_win()
  local from = { vim.fn.bufnr "%", vim.fn.line ".", vim.fn.col ".", 0 }
  local tagstack = { { tagname = vim.fn.expand "<cword>", from = from } }

  vim.cmd "normal! m'"
  vim.fn.settagstack(vim.fn.win_getid(win), { items = tagstack }, "t")
  vim.api.nvim_win_set_buf(win, bufnr)
  vim.api.nvim_win_set_cursor(win, { lnum, col })
  vim._with({ win = win }, function() vim.cmd "normal! zv" end)
  return true
end

function safe_lsp_location.on_list(opts)
  local items = vim.tbl_map(normalize_item, opts.items or {})
  if vim.tbl_isempty(items) then
    vim.notify("No locations found", vim.log.levels.INFO)
    return
  end

  if #items == 1 and jump_to_item(items[1]) then return end
  open_location_list(vim.tbl_extend("force", opts, { items = items }))
end

function safe_lsp_location.definition()
  vim.lsp.buf.definition { on_list = safe_lsp_location.on_list }
end

function safe_lsp_location.declaration()
  vim.lsp.buf.declaration { on_list = safe_lsp_location.on_list }
end

function safe_lsp_location.type_definition()
  vim.lsp.buf.type_definition { on_list = safe_lsp_location.on_list }
end

function safe_lsp_location.implementation()
  vim.lsp.buf.implementation { on_list = safe_lsp_location.on_list }
end

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    -- Configuration table of features provided by AstroLSP
    features = {
      codelens = true, -- enable/disable codelens refresh on start
      inlay_hints = false, -- enable/disable inlay hints on start
      semantic_tokens = true, -- enable/disable semantic token highlighting
    },
    -- customize lsp formatting options
    formatting = {
      -- control auto formatting on save
      format_on_save = {
        enabled = true, -- enable or disable format on save globally
        allow_filetypes = { -- enable format on save for specified filetypes only
          -- "go",
        },
        ignore_filetypes = { -- disable format on save for specified filetypes
          -- "python",
        },
      },
      disabled = { -- disable formatting capabilities for the listed language servers
        -- disable lua_ls formatting capability if you want to use StyLua to format your lua code
        -- "lua_ls",
      },
      timeout_ms = 1000, -- default format timeout
      -- filter = function(client) -- fully override the default formatting function
      --   return true
      -- end
    },
    -- enable servers that you already have installed without mason
    servers = {
    },
    -- customize language server configuration options passed to `lspconfig`
    ---@diagnostic disable: missing-fields
    config = {
      -- clangd = { capabilities = { offsetEncoding = "utf-8" } },
    },
    -- customize how language servers are attached
    handlers = {
      -- a function without a key is simply the default handler, functions take two parameters, the server name and the configured options table for that server
      -- function(server, opts) require("lspconfig")[server].setup(opts) end

      -- the key is the server that is being setup with `lspconfig`
    },
    -- Configure buffer local auto commands to add when attaching a language server
    autocmds = {
      -- first key is the `augroup` to add the auto commands to (:h augroup)
      lsp_codelens_refresh = {
        -- Optional condition to create/delete auto command group
        -- can either be a string of a client capability or a function of `fun(client, bufnr): boolean`
        -- condition will be resolved for each client on each execution and if it ever fails for all clients,
        -- the auto commands will be deleted for that buffer
        cond = "textDocument/codeLens",
        -- cond = function(client, bufnr) return client.name == "lua_ls" end,
        -- list of auto commands to set
        {
          -- events to trigger
          event = { "InsertLeave", "BufEnter" },
          -- the rest of the autocmd options (:h nvim_create_autocmd)
          desc = "Refresh codelens (buffer)",
          callback = function(args)
            if require("astrolsp").config.features.codelens then vim.lsp.codelens.enable(true, { bufnr = args.buf }) end
          end,
        },
      },
    },
    -- mappings to be set up on attaching of a language server
    mappings = {
      n = {
        -- a `cond` key can provided as the string of a server capability to be required to attach, or a function with `client` and `bufnr` parameters from the `on_attach` that returns a boolean
        gd = {
          function() safe_lsp_location.definition() end,
          desc = "Definition of current symbol",
          cond = "textDocument/definition",
        },
        gD = {
          function() safe_lsp_location.declaration() end,
          desc = "Declaration of current symbol",
          cond = "textDocument/declaration",
        },
        gri = {
          function() safe_lsp_location.implementation() end,
          desc = "Implementation of current symbol",
          cond = "textDocument/implementation",
        },
        grt = {
          function() safe_lsp_location.type_definition() end,
          desc = "Type definition of current symbol",
          cond = "textDocument/typeDefinition",
        },
        ["<Leader>uY"] = {
          function() require("astrolsp.toggles").buffer_semantic_tokens() end,
          desc = "Toggle LSP semantic highlight (buffer)",
          cond = function(client)
            return client:supports_method "textDocument/semanticTokens/full" and vim.lsp.semantic_tokens ~= nil
          end,
        },
      },
    },
    -- A custom `on_attach` function to be run after the default `on_attach` function
    -- takes two parameters `client` and `bufnr`  (`:h lspconfig-setup`)
    on_attach = function(client, bufnr)
      -- this would disable semanticTokensProvider for all clients
      -- client.server_capabilities.semanticTokensProvider = nil
    end,
  },
}
