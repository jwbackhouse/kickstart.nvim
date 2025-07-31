-- Git-related plugins
return {
  {
    'pwntester/octo.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'folke/snacks.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('octo').setup {
        picker = 'snacks',
      }
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    enabled = true,
    opts = {
      numhl = false,
      signcolumn = true,
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'right_align',
        delay = 500,
      },
      signs = {
        add = { text = '┃' },
        change = { text = '┃' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
      },
    },
  },

  -- Keybindings
  vim.keymap.set('n', '<leader>gd', '<cmd>DiffviewOpen<cr>', { noremap = true, silent = true, desc = '[G]it [D]iffview' }),
  vim.keymap.set('n', ']h', '<cmd>Gitsigns next_hunk<cr><cr>', { noremap = true, silent = true, desc = '[G]it next hunk' }),
  vim.keymap.set('n', '[h', '<cmd>Gitsigns prev_hunk<cr><cr>', { noremap = true, silent = true, desc = '[G]it previous hunk' }),
  vim.keymap.set('n', '<leader>gu', '<cmd>Gitsigns reset_hunk<cr>', { noremap = true, silent = true, desc = '[G]it [U]ndo hunk' }),
  vim.keymap.set('n', '<leader>gh', '<cmd>Gitsigns preview_hunk<cr>', { noremap = true, silent = true, desc = '[G]it Review [H]unk' }),
  vim.keymap.set('n', '<leader>tb', '<cmd>Gitsigns toggle_current_line_blame<cr>', { noremap = true, silent = true, desc = '[T]oggle [B]lame' }),
  -- PRs
  vim.keymap.set('n', '<leader>gps', '<cmd>Octo review<cr>', { noremap = true, silent = true, desc = '[G]it [P]R [S]tart review' }),
  vim.keymap.set('n', '<leader>gpf', '<cmd>Octo review submit<cr>', { noremap = true, silent = true, desc = '[G]it [P]R [F]inish review' }),
  vim.keymap.set('n', '<leader>gpc', '<cmd>Octo comment<cr>', { noremap = true, silent = true, desc = '[G]it [P]R [C]omment' }),
}
