local function config_moody(colors, is_dark)
  local modecolors = {
    normal = is_dark and colors.cyan or colors.bg,
    insert = is_dark and colors.red or colors.diff.delete,
    visual = is_dark and colors.purple or '#e1d8ed',
    command = colors.blue,
    operator = is_dark and colors.orange or '#debe9b',
    replace = colors.red,
    select = colors.purple,
    terminal = colors.cyan,
    terminal_n = colors.cyan,
  }

  local modeblend = is_dark and 0.2 or 0.9
  local alt_modeblend = is_dark and 0.3 or 0.9
  require('moody').setup {
    -- larger number = closer to white, smaller number = closer to black
    blends = {
      normal = is_dark and 0.2 or 0.8,
      insert = is_dark and 0.15 or 0.9,
      visual = alt_modeblend,
      command = modeblend,
      operator = alt_modeblend,
      replace = modeblend,
      select = modeblend,
      terminal = modeblend,
      terminal_n = modeblend,
    },
    colors = modecolors,
    disabled_filetypes = { 'TelescopePrompt', 'alpha', 'snacks_picker_input' },
    disabled_buftypes = {},
    bold_nr = true,
    extend_to_linenr = true,
    extend_to_linenr_visual = false,
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
      end, { desc = 'Add cursor above' })
      set({ 'n', 'v' }, '<down>', function()
        mc.lineAddCursor(1)
      end, { desc = 'Add cursor below' })
      set({ 'n', 'v' }, '<leader><up>', function()
        mc.lineSkipCursor(-1)
      end, { desc = 'Skip cursor above' })
      set({ 'n', 'v' }, '<leader><down>', function()
        mc.lineSkipCursor(1)
      end, { desc = 'Skip cursor below' })

      -- Add or skip adding a new cursor by matching word/selection
      set({ 'n', 'v' }, '<leader>mN', function()
        mc.matchAddCursor(-1)
      end, { desc = '[M]ulticursor Add By Matching Above [N]' })
      set({ 'n', 'v' }, '<leader>mn', function()
        mc.matchAddCursor(1)
      end, { desc = '[M]ulticursor Add By Matching Below [n]' })
      set({ 'n', 'v' }, '<leader>mS', function()
        mc.matchSkipCursor(-1)
      end, { desc = '[M]ulticursor Skip By Matching Above [S]' })
      set({ 'n', 'v' }, '<leader>ms', function()
        mc.matchSkipCursor(1)
      end, { desc = '[M]ulticursor Skip By Matching Below [s]' })

      -- Add all matches in the document
      set({ 'n', 'v' }, '<leader>ma', mc.matchAllAddCursors, { desc = '[M]ulticursor Add [A]ll Matches' })

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
      set('n', '<leader>mr', mc.restoreCursors, { desc = '[M]ulticursor [R]estore All' })

      -- Align cursor columns.
      set('n', '<leader>ml', mc.alignCursors, { desc = '[M]ulticursor [L]ineup' })

      -- Split visual selections by regex.
      set('v', '<leader>ms', mc.splitCursors, { desc = '[M]ulticursor [S]plit by Regex' })

      -- match new cursors within visual selections by regex.
      set('v', '<leader>mm', mc.matchCursors, { desc = '[M]ulticursor [M]atch Multiple by Regex' })

      -- Append/insert for each line of visual selections.
      set('v', 'I', mc.insertVisual)
      set('v', 'A', mc.appendVisual)
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
    enabled = true,
    event = { 'ModeChanged', 'BufWinEnter', 'WinEnter' },
    config = function()
      local colors = require 'tokyonight.colors.storm'
      config_moody(colors, true)
    end,
  },
  update_cursorline_colors = update_cursorline_colors,
}
