-- credit to elianiva
-- https://elianiva.my.id/post/neovim-lua-statusline
local fn = vim.fn
local api = vim.api
local cmd = vim.cmd

local c = require("tokyonight.colors").setup()
cmd("hi StatusLineAccent guifg=" .. c.black .. " guibg=" .. c.blue)
local M = {}

M.modes = setmetatable({
    ['n']  = 'Normal';
    ['no'] = 'N·Pending';
    ['v']  = 'Visual';
    ['V']  = 'V·Line';
    ['']  = 'V·Block'; -- this is not ^V, but it's , they're different
    ['s']  = 'Select';
    ['S']  = 'S·Line';
    ['']  = 'S·Block'; -- same with this one, it's not ^S but it's 
    ['i']  = 'Insert';
    ['ic'] = 'Insert';
    ['R']  = 'Replace';
    ['Rv'] = 'V·Replace';
    ['c']  = 'Command';
    ['cv'] = 'Vim·Ex';
    ['ce'] = 'Ex';
    ['r']  = 'Prompt';
    ['rm'] = 'More';
    ['r?'] = 'Confirm';
    ['!']  = 'Shell';
    ['t']  = 'Terminal';
}, {
    __index = function()
        return { 'Unknown' } -- handle edge cases
    end
})

M.get_current_mode = function(self)
    local current_mode = api.nvim_get_mode().mode
    return string.format(' %s ', self.modes[current_mode]):upper()
end

M.get_git_status = function()
    -- use fallback because it doesn't set this variable on the initial `BufEnter`
    local signs = vim.b.gitsigns_status_dict or { head = '', added = 0, changed = 0, removed = 0 }
    local is_head_empty = signs.head ~= ''

    return is_head_empty and string.format(
        '  %s | [+%s ~%s -%s] ',
        signs.head, signs.added, signs.changed, signs.removed
    ) or ''
end

M.get_filepath = function()
    local fpath = fn.fnamemodify(fn.expand "%", ":~:.:h")
    if fpath == "" or fpath == "." then
        return " "
    end

    return string.format(" %%<%s/", fpath)
end

M.get_filename = function()
    local filename = fn.expand "%:t"
    return filename == "" and "" or filename
end

M.get_filetype = function()
    local file_name, file_ext = fn.expand("%:t"), fn.expand("%:e")
    local icon = require 'nvim-web-devicons'.get_icon(file_name, file_ext, { default = true })
    local filetype = vim.bo.filetype

    if filetype == '' then return '' end
    return string.format(' %s %s ', icon, filetype):lower()
end

M.get_line_col = function()
    return ' %l:%c '
end

M.get_lsp = function()
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

M.set_active = function(self)
    return table.concat {
        "%#StatusLineAccent#",
        self:get_current_mode(),
        "%#StatusLine#",
        self:get_git_status(),
        "%=",
        self:get_filepath(),
        self:get_filename(),
        "%=",
        self:get_lsp(),
        self:get_filetype(),
        self:get_line_col(),
    }
end

M.set_inactive = function()
    return '%= %F %='
end

M.set_explorer = function()
    return "  "
end

Statusline = setmetatable(M, {
    __call = function(self, mode)
        return self["set_" .. mode](self)
    end,
})

vim.api.nvim_exec([[
  augroup Statusline
  au!
  au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline('active')
  au WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline('inactive')
  au WinEnter,BufEnter,FileType neo-tree setlocal statusline=%!v:lua.Statusline('explorer')
  augroup END
]], false)
