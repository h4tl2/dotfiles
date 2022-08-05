-- https://nuxsh.is-a.dev/blog/custom-nvim-statusline.html
local fn = vim.fn
local api = vim.api
local cmd = vim.cmd

local c = require("tokyonight.colors").setup()
cmd("hi StatusLineAccent guifg=" .. c.black .. " guibg=" .. c.blue)
cmd("hi StatusLineInsertAccent guifg=" .. c.black .. " guibg=" .. c.green)
cmd("hi StatusLineVisualAccent guifg=" .. c.black .. " guibg=" .. c.magenta)
cmd("hi StatusLineReplaceAccent guifg=" .. c.black .. " guibg=" .. c.red)
cmd("hi StatusLineCmdLineAccent guifg=" .. c.black .. " guibg=" .. c.yellow)
cmd("hi StatuslineTerminalAccent guifg=" .. c.black .. " guibg=" .. c.yellow)
cmd("hi StatusLineExtra guifg=" .. c.fg)
cmd "hi StatusLineNC guibg=NONE"

local modes = {
    ["n"] = "NORMAL",
    ["no"] = "NORMAL",
    ["v"] = "VISUAL",
    ["V"] = "V-LINE",
    [""] = "V-BLOCK",
    ["s"] = "SELECT",
    ["S"] = "SELECT LINE",
    [""] = "SELECT BLOCK",
    ["i"] = "INSERT",
    ["ic"] = "INSERT",
    ["R"] = "REPLACE",
    ["Rv"] = "V-REPLACE",
    ["c"] = "COMMAND",
    ["cv"] = "VIM EX",
    ["ce"] = "EX",
    ["r"] = "PROMPT",
    ["rm"] = "MOAR",
    ["r?"] = "CONFIRM",
    ["!"] = "SHELL",
    ["t"] = "TERMINAL",
}

local function mode()
    local current_mode = api.nvim_get_mode().mode
    return string.format(" %s ", modes[current_mode]):upper()
end

local function update_mode_colors()
    local current_mode = api.nvim_get_mode().mode
    local mode_color = "%#StatusLineAccent#"
    if current_mode == "n" then
        mode_color = "%#StatuslineAccent#"
    elseif current_mode == "i" or current_mode == "ic" then
        mode_color = "%#StatuslineInsertAccent#"
    elseif current_mode == "v" or current_mode == "V" or current_mode == "" then
        mode_color = "%#StatuslineVisualAccent#"
    elseif current_mode == "R" then
        mode_color = "%#StatuslineReplaceAccent#"
    elseif current_mode == "c" then
        mode_color = "%#StatuslineCmdLineAccent#"
    elseif current_mode == "t" then
        mode_color = "%#StatuslineTerminalAccent#"
    end
    return mode_color
end

local function filepath()
    local fpath = fn.fnamemodify(fn.expand "%", ":~:.:h")
    if fpath == "" or fpath == "." then
        return " "
    end

    return string.format(" %%<%s/", fpath)
end

local function filename()
    local fname = fn.expand "%:t"
    if fname == "" then
        return ""
    end
    return fname .. " "
end

local function filetype()
    return string.format(" %s ", vim.bo.filetype):lower()
end

local function lineinfo()
    if vim.bo.filetype == "alpha" then
        return ""
    end
    return "%#Normal# %l:%c "
end

local function lsp()
    local count = {}
    local levels = {
        errors = "Error",
        warnings = "Warn",
        info = "Info",
        hints = "Hint",
    }

    for k, level in pairs(levels) do
        count[k] = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
    end

    local errors = ""
    local warnings = ""
    local hints = ""
    local info = ""

    if count["errors"] ~= 0 then
        errors = " %#DiagnosticError# " .. count["errors"]
    end
    if count["warnings"] ~= 0 then
        warnings = " %#DiagnosticWarn# " .. count["warnings"]
    end
    if count["hints"] ~= 0 then
        hints = " %#DiagnosticHint# " .. count["hints"]
    end
    if count["info"] ~= 0 then
        info = " %#DiagnosticInfo# " .. count["info"]
    end

    return errors .. warnings .. hints .. info .. "%#Normal#"
end

local vcs = function()
    local git_info = vim.b.gitsigns_status_dict
    if not git_info or git_info.head == "" then
        return ""
    end
    local added = git_info.added and ("%#GitSignsAdd#+" .. git_info.added .. " ") or ""
    local changed = git_info.changed and ("%#GitSignsChange#~" .. git_info.changed .. " ") or ""
    local removed = git_info.removed and ("%#GitSignsDelete#-" .. git_info.removed .. " ") or ""
    if git_info.added == 0 then
        added = ""
    end
    if git_info.changed == 0 then
        changed = ""
    end
    if git_info.removed == 0 then
        removed = ""
    end
    return table.concat {
        " ",
        "%#Normal#",
        " ",
        git_info.head,
        "%#Normal#",
        " ",
        added,
        changed,
        removed,
    }
end

Statusline = {}

Statusline.active = function()
    return table.concat {
        "%#Statusline#",
        update_mode_colors(),
        mode(),
        "%#Normal# ",
        vcs(),
        lsp(),
        "%#Normal#",
        filepath(),
        filename(),
        "%#Normal#",
        "%=%#StatusLineExtra#",
        filetype(),
        lineinfo(),
    }
end

function Statusline.inactive()
    return " %F"
end

function Statusline.short()
    return "%#StatusLineNC#   NvimTree"
end

vim.api.nvim_exec([[
  augroup Statusline
  au!
  au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline.active()
  au WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline.inactive()
  au WinEnter,BufEnter,FileType NvimTree setlocal statusline=%!v:lua.Statusline.short()
  augroup END
]], false)
