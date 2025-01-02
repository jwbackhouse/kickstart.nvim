return {
  'sethen/line-number-change-mode.nvim',
  config = function()
    local colors = require 'tokyonight.colors.storm'

    if colors == nil then
      return nil
    end

    require('line-number-change-mode').setup {
      mode = {
        i = {
          fg = colors.red,
          bold = true,
        },
        n = {
          fg = colors.teal,
          bold = true,
        },
        R = {
          fg = colors.green,
          bold = true,
        },
        v = {
          bg = '#313540',
          fg = colors.purple,
          bold = true,
        },
        V = {
          bg = '#313540',
          fg = colors.purple,
          bold = true,
        },
      },
    }
  end,
}
