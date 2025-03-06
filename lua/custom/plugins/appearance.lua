return {
  {
    'f-person/auto-dark-mode.nvim',
    opts = {
      update_interval = 1000,
      set_dark_mode = function()
        local lualine = require 'custom.plugins.lualine'
        lualine.update_mode_colors(true)

        local cursorline = require 'custom.plugins.cursor'
        cursorline.update_cursorline_colors(true)

        vim.api.nvim_set_option_value('background', 'dark', {})
      end,
      set_light_mode = function()
        local lualine = require 'custom.plugins.lualine'
        lualine.update_mode_colors(false)

        local cursorline = require 'custom.plugins.cursor'
        cursorline.update_cursorline_colors(false)

        vim.api.nvim_set_option_value('background', 'light', {})
      end,
    },
  },
}
