-- go up/down when set wrapline
-- vim.keymap.set("n", "k", "v:count == 0 ? \"gk\" : \"k\"", { expr = true, silent = true })
-- vim.keymap.set("n", "j", "v:count == 0 ? \"gj\" : \"j\"", { expr = true, silent = true })

local disabled_built_ins = {
    "2html_plugin",
    "getscript",
    "getscriptPlugin",
    "gzip",
    "logipat",
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    -- "matchit",
    -- "matchparen",
    "tar",
    "tarPlugin",
    "rrhelper",
    -- "vimball",
    -- "vimballPlugin",
    "zip",
    "zipPlugin",
}

for _, plugin in pairs(disabled_built_ins) do
    vim.g["loaded_" .. plugin] = 1
end

-- https://www.reddit.com/r/neovim/comments/11qz6w1/dynamically_resize_nvimtree/
function NvimTree_width_ratio(percentage)
    local ratio = percentage / 100
    local width = math.floor(vim.go.columns * ratio)
    return width
end

-- resize nvimtree if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
    group = vim.api.nvim_create_augroup("NvimTreeResize", { clear = true }),
    callback = function()
        local width = NvimTree_width_ratio(20)
        vim.cmd("tabdo NvimTreeResize " .. width)
    end,
})
-- local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
-- vim.api.nvim_create_autocmd('TextYankPost', {
--     callback = function()
--         vim.highlight.on_yank()
--     end,
--     group = highlight_group,
--     pattern = '*',
-- })
