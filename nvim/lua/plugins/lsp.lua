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
    'sqlls',
    -- custom setting
    'rust_analyzer',
    'gopls',
    'yamlls',
    'jsonls',
    'eslint',
}

-- TODO: use metatable instead
local can_use_default_setting_servers = {
    'tsserver',
    'tflint',
    'zk',
    'vimls',
    'pyright',
    'sqlls',
}

-- Completion kinds
lsp_installer.setup({
    ensure_installed = servers,
})

-- }}}

-- LSP setup {{{
---@diagnostic disable-next-line: unused-local

-- diagnostic keymap set
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)

local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end
        -- noremap: no recursive mapping
        -- silent: the command will not be echoed in the command line
        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc, silent = true })
    end
    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    nmap('gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
    nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    nmap('<leader>e', vim.diagnostic.open_float, 'Show Diagnostic Info')
    nmap('<leader>q', vim.diagnostic.setloclist, 'Set loclist')
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

    buf_set_keymap('n', '<space>fm', '<cmd>lua vim.lsp.buf.format()<CR>', { noremap = true, silent = true })

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
