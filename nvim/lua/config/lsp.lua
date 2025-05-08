-- vim:fileencoding=utf-8:foldmethod=marker:foldlevel=0
-- LSP settings.
--
local default_schemas = nil
local status_ok, jsonls_settings = pcall(require, 'nlspsettings.jsonls')
if status_ok then
  default_schemas = jsonls_settings.get_default_schemas()
end

local function extend(tab1, tab2)
  for _, value in ipairs(tab2 or {}) do
    table.insert(tab1, value)
  end
  return tab1
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

local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', function()
    require('telescope.builtin').lsp_references { show_line = false }
  end, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>fs', require('telescope.builtin').lsp_document_symbols, '[F]ind Document [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
  nmap('<leader>fm', vim.lsp.buf.format, '[F]or[M]at')
  -- if client.supports_method("textDocument/formatting") then
  --     vim.api.nvim_create_autocmd("BufWritePre", {
  --         group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
  --         -- buffer = bufnr,
  --         pattern = { "*.py", "*.go", ".md", ".mdx", "*.lua", "*.vim", "*.sh", "*.{yml,yaml}" },
  --         callback = function() vim.lsp.buf.format() end
  --     })
  -- end
end

-- local util = require 'lspconfig/util'
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  ts_ls = {
    init_options = {
      preferences = {
        importModuleSpecifierPreference = 'relative',
        importModuleSpecifierEnding = 'minimal',
      },
    },
  },
  tflint = {},
  zk = {},
  vimls = {},
  pyright = {},
  sqlls = {},
  -- 'rust_analyzer',
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
local lspconfig = require 'lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
  handlers = {
    function(server)
      lspconfig[server].setup {
        capabilities = capabilities,
      }
    end,
    ['tsserver'] = function()
      lspconfig.tsserver.setup {
        capabilities = capabilities,
        settings = {
          completions = {
            completeFunctionCalls = true,
          },
        },
      }
    end,
  },
}

-- mason_lspconfig.setup_handlers {
--   function(server)
--     print(server)
--     require('lspconfig').setup {}
--     -- require('lspconfig')[server_name].setup {
--     --   capabilities = capabilities,
--     --   on_attach = on_attach,
--     --   settings = servers[server_name],
--     -- }
--   end,
-- }

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
