local null_ls = require "null-ls"
local b = null_ls.builtins

-- local with_root_file = function(builtin, file)
--     return builtin.with {
--         condition = function(utils)
--             return utils.root_has_file(file)
--         end,
--     }
-- end

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

-- eslint_d and prettierd is running in bg
-- use `eslint_d stop` and `prettierd stop`

-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md#using-local-executables
null_ls.setup({
    sources = {
        b.diagnostics.eslint.with({
            prefer_local = "node_modules/.bin",
            -- only_local = "node_modules/.bin",
            diagnostics_format = '[eslint] #{m}\n(#{c})'
        }),
        b.formatting.prettier.with({
            prefer_local = "node_modules/.bin",
        }),

        -- with_root_file(
        --     b.diagnostics.eslint_d.with({
        --         diagnostics_format = '[eslint] #{m}\n(#{c})'
        --     }),
        --     { ".eslintrc.json", ".eslintrc" }
        -- ),
    },
    on_attach = on_attach,
})
