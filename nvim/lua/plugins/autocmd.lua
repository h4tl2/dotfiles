-- local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
-- vim.api.nvim_create_autocmd("BufWritePre", {
--     group = augroup,
--     pattern = { "*" },
--     callback = function()
--         vim.lsp.buf.format { async = true }
--     end,
-- })
