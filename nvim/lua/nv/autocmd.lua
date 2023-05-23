-- local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
-- vim.api.nvim_create_autocmd("BufWritePre", {
--     group = augroup,
--     pattern = { "*" },
--     callback = function()
--         vim.lsp.buf.format()
--     end,
-- })
--

-- https://neovim.discourse.group/t/how-can-i-setup-eslint-to-format-on-save/2570/4
vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = { '*.tsx', '*.ts', '*.jsx', '*.js' },
    command = 'EslintFixAll',
    group = vim.api.nvim_create_augroup('ESlintFormatting', {}),
})