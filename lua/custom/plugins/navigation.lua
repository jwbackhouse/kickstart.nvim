return {
  {
    'chrisgrieser/nvim-spider',
    lazy = true,
    opts = {
      skipInsignificantPunctuation = false,
    },
    keys = {
      { 'w', "<cmd>lua require('spider').motion('w')<CR>", mode = { 'n', 'o', 'x' } },
      { 'e', "<cmd>lua require('spider').motion('e')<CR>", mode = { 'n', 'o', 'x' } },
      { 'b', "<cmd>lua require('spider').motion('b')<CR>", mode = { 'n', 'o', 'x' } },
    },
  },
  {
    'chrisgrieser/nvim-various-textobjs',
    event = 'VeryLazy',
    opts = {
      keymaps = {
        useDefaults = true,
      },
    },
    config = function()
      -- Delete surrounding indentation
      -- See plugin README
      vim.keymap.set('n', 'dsi', function()
        -- select outer indentation
        require('various-textobjs').indentation('outer', 'outer')

        -- plugin only switches to visual mode when a textobj has been found
        local indentationFound = vim.fn.mode():find 'V'
        if not indentationFound then
          return
        end

        -- dedent indentation
        vim.cmd.normal { '<', bang = true }

        -- delete surrounding lines
        local endBorderLn = vim.api.nvim_buf_get_mark(0, '>')[1]
        local startBorderLn = vim.api.nvim_buf_get_mark(0, '<')[1]
        vim.cmd(tostring(endBorderLn) .. ' delete') -- delete end first so line index is not shifted
        vim.cmd(tostring(startBorderLn) .. ' delete')
      end, { desc = '[D]elete [S]urrounding [I]ndentation' })
    end,
  },
  {
    'aaronik/treewalker.nvim',
    opts = {
      highlight = false,
      highlight_duration = 250,
      highlight_group = 'ColorColumn',
    },
    keys = {
      { '<D-j>', '<cmd>Treewalker Down<CR>zz', mode = { 'n', 'v' }, noremap = true, desc = 'Move Down with Treewalker' },
      { '<D-k>', '<cmd>Treewalker Up<CR>zz', mode = { 'n', 'v' }, noremap = true, desc = 'Move Up with Treewalker' },
      { '<D-g>', '<cmd>Treewalker Left<CR>zz', mode = { 'n', 'v' }, noremap = true, desc = 'Move Left with Treewalker' },
      { '<D-l>', '<cmd>Treewalker Right<CR>zz', mode = { 'n', 'v' }, noremap = true, desc = 'Move Right with Treewalker' },
      { '<D-S-j>', '<cmd>Treewalker SwapDown<CR>', mode = 'n', noremap = true, desc = 'Swap Down with Treewalker' },
      { '<D-S-k>', '<cmd>Treewalker SwapUp<CR>', mode = 'n', noremap = true, desc = 'Swap Up with Treewalker' },
    },
  },
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    config = function()
      require('flash').setup {
        labels = 'wqzvk1234567890[]()',
        jump = {
          nohlsearch = true,
        },
        modes = {
          search = {
            enabled = false,
            highlight = {
              backdrop = false,
            },
          },
          char = {
            jump_labels = true,
            highlight = {
              backdrop = false,
            },
          },
        },
      }

      -- Jump label - only set when system color scheme is light
      if vim.o.background == 'light' then
        vim.api.nvim_set_hl(0, 'FlashLabel', { bg = '#ffffff' })
      end
    end,
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
}
