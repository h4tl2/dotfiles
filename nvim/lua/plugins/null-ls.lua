local null_ls = require("null-ls")
local b = null_ls.builtins

local lsp_formatting = function(bufnr)
    vim.lsp.buf.format({
        filter = function(client)
            -- apply whatever logic you want (in this example, we'll only use null-ls)
            return client.name == "null-ls"
        end,
        bufnr = bufnr,
    })
end

-- if you want to set up formatting on save, you can use this as a callback
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- add to your shared on_attach callback
local on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
                lsp_formatting(bufnr)
            end,
        })
    end
end

-- If I decide to go back to running in daemon mode
-- eslint_d and prettierd is running in bg
-- use `eslint_d stop` and `prettierd stop`

-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md#using-local-executables
-- https://github.com/williamboman/nvim-lsp-installer/blob/main/lua/nvim-lsp-installer/servers/eslint/README.md
null_ls.setup({
    sources = {
        -- b.diagnostics.eslint.with({
        --     dynamic_command = function(params)
        --         return command_resolver.from_node_modules(params)
        --             or command_resolver.from_yarn_pnp(params)
        --             or vim.fn.executable(params.command) == 1 and params.command
        --     end,
        --     -- prefer_local = "node_modules/.bin",
        --     -- only_local = "node_modules/.bin",
        --     diagnostics_format = '[eslint] #{m}\n(#{c})'
        -- }),
        -- b.formatting.prettier.with({
        --     prefer_local = "node_modules/.bin",
        -- }),
    },
    on_attach = on_attach,
})
