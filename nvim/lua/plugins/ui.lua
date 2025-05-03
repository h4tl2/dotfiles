return {
  { 'echasnovski/mini.bufremove', version = '*' },
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require("bufferline").setup {
        options = {
          numbers = "ordinal",
          diagnostics = "nvim_lsp", 
          tab_size = 6,
          separator_style = { '', '' },
          ---@diagnostic disable-next-line: unused-local
          diagnostics_indicator = function(count, level, diagnostics_dict, context)
            local icon = level:match("error") and " " or " "
            return "" .. icon .. count
          end,
          always_show_bufferline = true,
          show_buffer_close_icons = false,
          show_buffer_icons = false,
          -- name_formatter = function(buf) -- buf contains a "name", "path" and "bufnr"
          --   -- remove extension from markdown files for example
          --   if buf.name:match('%.md') then
          --     return vim.fn.fnamemodify(buf.name, ':t:r')
          --   end
          -- end,
          -- offsets = {
          --   {
          --     filetype = "NvimTree",
          --     text = "File Explorer", 
          --     text_align = "center"
          --   }
          -- },
        },
        -- https://github.com/akinsho/bufferline.nvim/blob/main/lua/bufferline/config.lua#L208
        highlights = {
          buffer_selected = {
            bold = true,
            italic = false,
            -- bg = "#545c7e" -- dark3
          },
          -- background = {
          --   bg = "#24283b"
          -- },
        },
        -- highlights = highlights,
      }
    end
  }
}
