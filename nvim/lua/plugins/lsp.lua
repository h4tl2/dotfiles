-- vim:fileencoding=utf-8:foldmethod=marker:foldlevel=0
local nvim_lsp = require('lspconfig')
local util = require('lspconfig/util')
local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
    return
end

-- Install LS {{{
local servers = {
    'tsserver',
    'tflint',
    'zk',
    'vimls',
    'pyright',
    -- custom setting
    'rust_analyzer',
    'gopls',
    'yamlls',
    'jsonls',
    'sumneko_lua',
    'eslint',
}

-- TODO: use metatable instead
local can_use_default_setting_servers = {
    'tsserver',
    'tflint',
    'zk',
    'vimls',
    'pyright',
}

-- Completion kinds
lsp_installer.setup({
    ensure_installed = servers,
})

-- }}}

-- LSP setup {{{
---@diagnostic disable-next-line: unused-local
local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

    -- noremap: no recursive mapping
    -- silent: the command will not be echoed in the command line
    local opts = { noremap = true, silent = true }

    -- our first remap
    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    buf_set_keymap('n', '<space>fm', '<cmd>lua vim.lsp.buf.format()<CR>', opts)

    -- formatting
    if client.supports_method("textDocument/formatting") then
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
            -- buffer = bufnr,
            pattern = { "*.py", "*.go", ".md", ".mdx", "*.lua", "*.vim", "*.sh", "*.{yml,yaml}" },
            callback = function() vim.lsp.buf.format() end
        })
    end

    -- if vim.bo[bufnr].buftype ~= "" or vim.bo[bufnr].filetype == "helm" then
    --     vim.diagnostic.disable(bufnr)
    --     vim.defer_fn(function()
    --         vim.diagnostic.reset(nil, bufnr)
    --     end, 1000)
    -- end
    -- highlight references
    -- https://sbulav.github.io/til/til-neovim-highlight-references/
end

-- https://www.getman.io/posts/programming-go-in-neovim/
local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local function config(_config)
    return vim.tbl_deep_extend("force", {
        on_attach = on_attach,
        capabilities = capabilities,
    }, _config or {})
end

nvim_lsp.gopls.setup(config({
    cmd = { 'gopls', 'serve' },
    filetypes = { "go", "gomod" },
    root_dir = util.root_pattern("go.work", "go.mod", ".git"),
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
                unusedwrite = true,
                -- shadow = true,  https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md#shadow
            },
            staticcheck = true,
        },
    },
}))

nvim_lsp.sumneko_lua.setup(config({
    settings = {
        Lua = {
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { "vim" },
            },
        },
    },
}))

nvim_lsp.jsonls.setup(config({
    settings = {
        json = {
            schemas = {
                {
                    description = "ESLint config",
                    fileMatch = { ".eslintrc.json", ".eslintrc" },
                    url = "http://json.schemastore.org/eslintrc",
                },
                {
                    description = "Package config",
                    fileMatch = { "package.json" },
                    url = "https://json.schemastore.org/package",
                },
                {
                    description = "OpenApi config",
                    fileMatch = { "*api*.json" },
                    url = "https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json",
                },
            }
        }
    }
}))

nvim_lsp.yamlls.setup(config({
    -- settings = {
    --     yaml = {
    --         schemas = {
    --             kubernetes = "*.yaml",
    --             ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
    --             ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
    --             -- ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
    --             ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
    --             ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
    --             ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
    --             -- ["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
    --             ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
    --             ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
    --             ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
    --         }
    --     }
    -- }
}))

-- https://github.com/microsoft/vscode-eslint/issues/1382
nvim_lsp.eslint.setup(config({
    settings = {
        useESLintClass = true,
        -- codeActionOnSave = {
        --     enable = true,
        --     mode = "all"
        -- },
    }
}))

nvim_lsp.rust_analyzer.setup(config({
    settings = {
        ["rust-analyzer"] = {
            checkOnSave = {
                command = "clippy"
            },
        }
    }
}))

for _, lsp in ipairs(can_use_default_setting_servers) do
    nvim_lsp[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities,
    }
end

-- }}}

-- cmp setup {{{
local cmp = require('cmp')
local lspkind = require('lspkind')
local luasnip = require('luasnip')
require("luasnip.loaders.from_vscode").lazy_load()
-- better autocompletion experience
vim.o.completeopt = 'menuone,noselect'

cmp.setup {
    -- Format the autocomplete menu
    formatting = {
        format = lspkind.cmp_format()
    },
    mapping = {
        -- Use Tab and shift-Tab to navigate autocomplete menu
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
    },
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end
    },
    -- https://neovim.discourse.group/t/make-nvim-cmp-show-full-function-help-again-instead-of-signature-only/1863
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'path' },
    },
}
-- }}}

-- UI {{{
-- https://github.com/neovim/nvim-lspconfig/wiki/UI-customization
vim.diagnostic.config({
    virtual_text = {
        prefix = '😾', -- Could be '●', '▎', 'x', '■'
    }
})

-- local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
-- for type, icon in pairs(signs) do
--     local hl = "DiagnosticSign" .. type
--     vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
-- end

-- https://github.com/neovim/nvim-lspconfig/wiki/UI-customization#borders
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
