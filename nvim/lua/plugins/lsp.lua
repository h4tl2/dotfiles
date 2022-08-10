-- vim:fileencoding=utf-8:foldmethod=marker
local nvim_lsp = require('lspconfig')
local util = require('lspconfig/util')
local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
    return
end

-- Install LS {{{
local servers = {
    'tsserver',
    'gopls',
    'yamlls',
    'sumneko_lua',
    'rust_analyzer',
    'tflint',
    'zk',
    -- 'eslint',
    'vimls',
}

-- Completion kinds
lsp_installer.setup({
    ensure_installed = servers,
})

-- }}}

-- attach function {{{
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
    -- nvim 0.8.x
    buf_set_keymap('n', '<space>fm', '<cmd>lua vim.lsp.buf.format{ async = true }<CR>', opts)
    -- nvim 0.7.x
    -- buf_set_keymap('n', '<space>fm', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

    -- highlight references
    -- https://sbulav.github.io/til/til-neovim-highlight-references/
    -- if client.server_capabilities.documentHighlightProvider then
    --     vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
    --     vim.api.nvim_clear_autocmds { buffer = bufnr, group = "lsp_document_highlight" }
    --     vim.api.nvim_create_autocmd("CursorHold", {
    --         callback = vim.lsp.buf.document_highlight,
    --         buffer = bufnr,
    --         group = "lsp_document_highlight",
    --         desc = "Document Highlight",
    --     })
    --     vim.api.nvim_create_autocmd("CursorMoved", {
    --         callback = vim.lsp.buf.clear_references,
    --         buffer = bufnr,
    --         group = "lsp_document_highlight",
    --         desc = "Clear All the References",
    --     })
    -- end

    -- show hover diagnostic
    -- vim.api.nvim_create_autocmd("CursorHold", {
    --     buffer = bufnr,
    --     callback = function()
    --         local opts = {
    --             focusable = false,
    --             close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
    --             border = 'rounded',
    --             source = 'always',
    --             prefix = ' ',
    --             scope = 'cursor',
    --         }
    --         vim.diagnostic.open_float(nil, opts)
    --     end
    -- })
end

-- https://www.getman.io/posts/programming-go-in-neovim/
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
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
                shadow = true,
            },
            staticcheck = true,
        },
    },
}))

require("lspconfig").sumneko_lua.setup(config({
    settings = {
        Lua = {
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { "vim" },
            },
        },
    },
}))

local can_use_default_setting_servers = {
    'tsserver',
    'yamlls',
    'rust_analyzer',
    'tflint',
    'zk',
    'eslint',
    'vimls',
}

for _, lsp in ipairs(can_use_default_setting_servers) do
    nvim_lsp[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities,
    }
end

-- }}}

-- setup lsp and autocomplete {{{
local cmp = require('cmp')
local lspkind = require('lspkind')
local luasnip = require('luasnip')

-- better autocompletion experience
vim.o.completeopt = 'menuone,noselect'

cmp.setup {
    -- Format the autocomplete menu
    formatting = {
        format = lspkind.cmp_format()
    },
    mapping = {
        -- Use Tab and shift-Tab to navigate autocomplete menu
        ['<Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end,
        ['<S-Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end,
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

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- https://github.com/neovim/nvim-lspconfig/wiki/UI-customization#borders
vim.cmd [[autocmd! ColorScheme * highlight NormalFloat guibg=#1f2335]]
vim.cmd [[autocmd! ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335]]

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
