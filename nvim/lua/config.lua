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
    local disable = "loaded_" .. plugin
    vim.g[disable] = 1
end
