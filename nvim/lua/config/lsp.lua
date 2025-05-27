-- vim:fileencoding=utf-8:foldmethod=marker:foldlevel=0
-- LSP settings.
--
local default_schemas = nil
local status_ok, jsonls_settings = pcall(require, 'nlspsettings.jsonls')
if status_ok then
  default_schemas = jsonls_settings.get_default_schemas()
end

local schemas = {
  {
    description = 'ESLint config',
    fileMatch = { '.eslintrc.json', '.eslintrc' },
    url = 'http://json.schemastore.org/eslintrc',
  },
  {
    description = 'Package config',
    fileMatch = { 'package.json' },
    url = 'https://json.schemastore.org/package',
  },
  {
    description = 'OpenApi config',
    fileMatch = { '*api*.json' },
    url = 'https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json',
  },
}

-- local util = require 'lspconfig/util'
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  ts_ls = {
    -- init_options = {
    --   preferences = {
    --     importModuleSpecifierPreference = 'relative',
    --     importModuleSpecifierEnding = 'minimal',
    --   },
    -- },
    settings = {
      completion = {
        completeFunctionCalls = true,
      },
    },
  },
  tflint = {},
  zk = {},
  vimls = {},
  pyright = {},
  sqlls = {},
  rust_analyzer = {
    settings = {
      ['rust-analyzer'] = {
        checkOnSave = {
          command = 'clippy',
        },
      },
    },
  },
  eslint = {
    settings = {
      useESLintClass = true,
      -- codeActionOnSave = {
      --     enable = true,
      --     mode = "all"
      -- },
    },
  },
  yamlls = {
    settings = {
      yaml = {
        schemas = {
          kubernetes = '*.yaml',
          ['http://json.schemastore.org/github-workflow'] = '.github/workflows/*',
          ['http://json.schemastore.org/github-action'] = '.github/action.{yml,yaml}',
          -- ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
          ['http://json.schemastore.org/prettierrc'] = '.prettierrc.{yml,yaml}',
          ['http://json.schemastore.org/kustomization'] = 'kustomization.{yml,yaml}',
          ['http://json.schemastore.org/chart'] = 'Chart.{yml,yaml}',
          -- ["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
          ['https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json'] = '*api*.{yml,yaml}',
          ['https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json'] = '*docker-compose*.{yml,yaml}',
          ['https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json'] = '*flow*.{yml,yaml}',
        },
      },
    },
  },
  jsonls = {
    -- settings = {
    -- 	json = {
    -- 		schemas = extend(schemas, default_schemas)
    -- 	}
    -- }
  },
  gopls = {
    -- cmd = { 'gopls', 'serve' },
    -- filetypes = { 'go', 'gomod' },
    -- root_dir = util.root_pattern('go.work', 'go.mod', '.git'),
    -- settings = {
    --   gopls = {
    --     analyses = {
    --       unusedparams = true,
    --       unusedwrite = true,
    --       -- shadow = true,  https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md#shadow
    --     },
    --     staticcheck = true,
    --   },
    -- },
  },
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
  automatic_installation = false,
  handlers = {
    function(server_name)
      local server = servers[server_name] or {}
      server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
      require('lspconfig')[server_name].setup(server)
    end,
  },
}

-- UI {{{
-- https://github.com/neovim/nvim-lspconfig/wiki/UI-customization
vim.diagnostic.config {
  virtual_text = {
    prefix = '😾', -- Could be '●', '▎', 'x', '■'
  },
}

-- local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
-- for type, icon in pairs(signs) do
--     local hl = "DiagnosticSign" .. type
--     vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
-- end

-- https://github.com/neovim/nvim-lspconfig/wiki/UI-customization#borders
-- vim.cmd [[autocmd! ColorScheme * highlight NormalFloat guibg=#1f2335]]
-- vim.cmd [[autocmd! ColorScheme * highlight FloatBorder guifg=black guibg=#eeeeee]]

local border = {
  { '╭', 'FloatBorder' },
  { '─', 'FloatBorder' },
  { '╮', 'FloatBorder' },
  { '│', 'FloatBorder' },
  { '╯', 'FloatBorder' },
  { '─', 'FloatBorder' },
  { '╰', 'FloatBorder' },
  { '│', 'FloatBorder' },
}

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or border
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- }}}
