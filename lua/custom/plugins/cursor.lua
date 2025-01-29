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

  {
    'jake-stewart/multicursor.nvim',
    branch = '1.0',
    config = function()
      local mc = require 'multicursor-nvim'

      mc.setup()

      local set = vim.keymap.set

      -- Add or skip cursor above/below the main cursor.
      set({ 'n', 'v' }, '<up>', function()
        mc.lineAddCursor(-1)
      end)
      set({ 'n', 'v' }, '<down>', function()
        mc.lineAddCursor(1)
      end)
      set({ 'n', 'v' }, '<leader><up>', function()
        mc.lineSkipCursor(-1)
      end)
      set({ 'n', 'v' }, '<leader><down>', function()
        mc.lineSkipCursor(1)
      end)

      -- Add or skip adding a new cursor by matching word/selection
      set({ 'n', 'v' }, '<leader>n', function()
        mc.matchAddCursor(1)
      end)
      set({ 'n', 'v' }, '<leader>s', function()
        mc.matchSkipCursor(1)
      end)
      set({ 'n', 'v' }, '<leader>N', function()
        mc.matchAddCursor(-1)
      end)
      set({ 'n', 'v' }, '<leader>S', function()
        mc.matchSkipCursor(-1)
      end)

      -- Add all matches in the document
      set({ 'n', 'v' }, '<leader>A', mc.matchAllAddCursors)

      -- You can also add cursors with any motion you prefer:
      -- set("n", "<right>", function()
      --     mc.addCursor("w")
      -- end)
      -- set("n", "<leader><right>", function()
      --     mc.skipCursor("w")
      -- end)

      -- Rotate the main cursor.
      set({ 'n', 'v' }, '<left>', mc.nextCursor)
      set({ 'n', 'v' }, '<right>', mc.prevCursor)

      -- Delete the main cursor.
      set({ 'n', 'v' }, '<leader>x', mc.deleteCursor)

      -- Add and remove cursors with control + left click.
      set('n', '<c-leftmouse>', mc.handleMouse)

      -- Easy way to add and remove cursors using the main cursor.
      set({ 'n', 'v' }, '<c-q>', mc.toggleCursor)

      -- Clone every cursor and disable the originals.
      set({ 'n', 'v' }, '<leader><c-q>', mc.duplicateCursors)

      set('n', '<esc>', function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        elseif mc.hasCursors() then
          mc.clearCursors()
        else
          -- Default <esc> handler.
        end
      end)

      -- bring back cursors if you accidentally clear them
      set('n', '<leader>gv', mc.restoreCursors)

      -- Align cursor columns.
      set('n', '<leader>a', mc.alignCursors)

      -- Split visual selections by regex.
      set('v', 'S', mc.splitCursors)

      -- Append/insert for each line of visual selections.
      set('v', 'I', mc.insertVisual)
      set('v', 'A', mc.appendVisual)

      -- match new cursors within visual selections by regex.
      set('v', 'M', mc.matchCursors)

      -- Rotate visual selection contents.
      set('v', '<leader>t', function()
        mc.transposeCursors(1)
      end)
      set('v', '<leader>T', function()
        mc.transposeCursors(-1)
      end)

      -- Jumplist support
      set({ 'v', 'n' }, '<c-i>', mc.jumpForward)
      set({ 'v', 'n' }, '<c-o>', mc.jumpBackward)

      -- Customize how cursors look.
      local hl = vim.api.nvim_set_hl
      hl(0, 'MultiCursorCursor', { link = 'Cursor' })
      hl(0, 'MultiCursorVisual', { link = 'Visual' })
      hl(0, 'MultiCursorSign', { link = 'SignColumn' })
      hl(0, 'MultiCursorDisabledCursor', { link = 'Visual' })
      hl(0, 'MultiCursorDisabledVisual', { link = 'Visual' })
      hl(0, 'MultiCursorDisabledSign', { link = 'SignColumn' })
    end,
  },
  {
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
  },
}
