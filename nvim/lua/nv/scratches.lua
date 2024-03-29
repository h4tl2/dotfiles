-- original one contains git push while saving the scratches too
-- https://github.com/crivotz/nv-ide/blob/master/lua/plugins/scratches.lua
-- Credits to https://github.com/GustavoKatel/

local M = {
    _state = {
        last_floating_window = nil,
    },
}

function M.get_scratch_filename(filename)
    if filename == nil then
        filename = "sc"
    end
    if filename == "vim" then
        return "~/code/dotfiles/nvim/lua/nv/keymaps.lua"
    end
    return "~/code/scratches/" .. filename .. ".md"
end

function M.open_scratch_file(opts)
    vim.api.nvim_command("!mkdir -p ~/code/scratches")
    vim.api.nvim_command("vsplit " .. M.get_scratch_filename(opts.filename))
end

function M.open_scratch_file_floating(opts)
    if M._state.last_floating_window ~= nil then
        vim.api.nvim_win_close(M._state.last_floating_window, false)
        M._state.last_floating_window = nil
    end

    opts = vim.tbl_deep_extend("force", { percentWidth = 0.8, percentHeight = 0.8 }, opts or {})

    -- Get the current UI
    local ui = vim.api.nvim_list_uis()[1]

    local width = math.floor(ui.width * opts.percentWidth)
    local height = math.floor(ui.height * opts.percentHeight)

    -- Create the floating window
    local win_opts = {
        relative = "editor",
        width = width,
        height = height,
        col = (ui.width / 2) - (width / 2),
        row = (ui.height / 2) - (height / 2),
        anchor = "NW",
        style = "minimal",
        border = { "┏", "━", "┓", "┃", "┛", "━", "┗", "┃" },
    }
    local winnr = vim.api.nvim_open_win(0, true, win_opts)
    M._state.last_floating_window = winnr

    vim.api.nvim_command("edit " .. M.get_scratch_filename(opts.filename))

    local bufnr = vim.api.nvim_get_current_buf()

    local closing_keys = { "q", "<ESC>" }

    for _, key in ipairs(closing_keys) do
        vim.keymap.set({ "n" }, key, function()
            vim.api.nvim_command(":silent !mkdir -p ~/code/scratches")
            vim.api.nvim_command(":w")
            -- local buffer_id = vim.api.nvim_win_get_buf(0)
            -- vim.api.nvim_win_close(0, false)
            vim.api.nvim_command(":bd " .. vim.api.nvim_win_get_buf(0))
            M._state.last_floating_window = nil
        end, { buffer = bufnr })
    end
end

vim.api.nvim_create_user_command("ScratchOpenFloat", M.open_scratch_file_floating, {})
vim.api.nvim_create_user_command("ScratchOpenSplit", M.open_scratch_file, {})

return M
