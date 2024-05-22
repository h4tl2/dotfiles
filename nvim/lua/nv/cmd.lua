-- https://neovim.discourse.group/t/how-can-i-setup-eslint-to-format-on-save/2570/4
-- vim.api.nvim_create_autocmd('BufWritePre', {
--     pattern = { '*.tsx', '*.ts', '*.jsx', '*.js' },
--     command = 'EslintFixAll',
--     group = vim.api.nvim_create_augroup('ESlintFormatting', {}),
-- })
--
-- vim.api.nvim_create_autocmd('BufWritePre', {
--   pattern = { '*.tsx', '*.ts' },
--   callback = function()
--     vim.lsp.buf.code_action {
--       apply = true,
--       context = {
--         only = { 'source.removeUnusedImports.ts' },
--         diagnostics = {},
--       },
--     }
--   end,
-- })

vim.api.nvim_create_user_command('FormatConform', function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ['end'] = { args.line2, end_line:len() },
    }
  end
  require('conform').format { async = true, lsp_fallback = true, range = range }
end, { range = true })

vim.api.nvim_create_user_command('FormatDisable', function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = 'Disable autoformat-on-save',
  bang = true,
})
vim.api.nvim_create_user_command('FormatEnable', function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = 'Re-enable autoformat-on-save',
})
