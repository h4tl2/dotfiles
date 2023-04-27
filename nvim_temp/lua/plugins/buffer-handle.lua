local M = {}

local get_ls = vim.tbl_filter(function(buf)
    return vim.api.nvim_buf_is_valid(buf)
        and vim.api.nvim_buf_get_option(buf, 'buflisted')
end, vim.api.nvim_list_bufs())

function M.close_all_buffers_except_current()
    local bufnrs = get_ls
    for _, bufnr in ipairs(bufnrs) do
        if bufnr ~= vim.api.nvim_get_current_buf() then
            require('bufdelete').bufdelete(bufnr, true)
        end
    end
end

return M
