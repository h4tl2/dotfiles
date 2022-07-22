vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*" },
  callback = function()
	  vim.lsp.buf.formatting_sync(nil, 1000)
  end,
})
