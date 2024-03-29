-- https://github.com/neovim/nvim-lspconfig/issues/115#issuecomment-1026971597
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.go" },
    callback = function()
        local params = vim.lsp.util.make_range_params(nil, vim.lsp.util._get_offset_encoding())
        params.context = { only = { "source.organizeImports" } }

        local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
        for _, res in pairs(result or {}) do
            for _, r in pairs(res.result or {}) do
                if r.edit then
                    vim.lsp.util.apply_workspace_edit(r.edit, vim.lsp.util._get_offset_encoding())
                else
                    vim.lsp.buf.execute_command(r.command)
                end
            end
        end
    end,
})

-- https://github.com/abenz1267/gomvp
vim.api.nvim_create_user_command('GoMvp',
    function(...)
        local args = { ... }
        local Job = require 'plenary.job'
        local job = Job:new {
            command = 'gomvp',
            args = args[1].fargs
        }

        job:sync()
    end,
    { nargs = '+', range = true }
)
