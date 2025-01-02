local function config_moody(colors, is_dark)
  local modecolors = {
    -- normal = is_dark and colors.teal or colors.bg,
    normal = colors.bg,
    insert = is_dark and colors.red or colors.diff.delete,
    visual = is_dark and colors.purple or colors.diff.add,
    command = colors.blue,
    operator = colors.orange,
    replace = colors.red,
    select = colors.purple,
    terminal = colors.cyan,
    terminal_n = colors.cyan,
  }

  -- local modeblend = is_dark and 0.2 or 0.95
  local modeblend = 0.2
  require('moody').setup {
    -- larger number = closer to white, smaller number = closer to black
    blends = {
      normal = modeblend,
      insert = modeblend,
      visual = is_dark and 0.25 or 0.95,
      command = modeblend,
      operator = modeblend,
      replace = modeblend,
      select = modeblend,
      terminal = modeblend,
      terminal_n = modeblend,
    },
    colors = modecolors,
    disabled_filetypes = { 'TelescopePrompt', 'alpha' },
    disabled_buftypes = {},
    bold_nr = true,
    recording = {
      enabled = false,
      icon = '󰑋',
      pre_registry_text = '[',
      post_registry_text = ']',
      right_padding = 2,
    },
    extend_to_linenr = false,
    extend_to_linenr_visual = false,
    reduce_cursorline = true,
    fold_options = {
      enabled = false,
      start_color = '#C1C1C1',
      end_color = '#2F2F2F',
    },
  }
end

local function update_cursorline_colors(is_dark_mode)
  local colors = is_dark_mode and require 'tokyonight.colors.storm' or require('tokyonight.colors').setup { style = 'day' }

  config_moody(colors, is_dark_mode)
end

return {
  'svampkorg/moody.nvim',
  enabled = false,
  event = { 'ModeChanged', 'BufWinEnter', 'WinEnter' },
  dependencies = {
    -- for seeing Moody's take on folds
    'kevinhwang91/nvim-ufo',
  },
  config = function()
    local colors = require 'tokyonight.colors.storm'
    config_moody(colors, true)
  end,
  update_cursorline_colors = update_cursorline_colors,
}
