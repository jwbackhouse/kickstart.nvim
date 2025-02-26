-- Git-related plugins
return {
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'sindrets/diffview.nvim', -- optional - Diff integration
      'nvim-telescope/telescope.nvim', -- optional
    },
    config = true,
    opts = {
      kind = 'floating',
      integrations = {
        diffview = true,
        telescope = true,
      },
    },
  },
  {
    'pwntester/octo.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'folke/snacks.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('octo').setup()
    end,
  },

  -- Here is a more advanced example where we pass configuration
  -- options to `gitsigns.nvim`. This is equivalent to the following Lua:
  --    require('gitsigns').setup({ ... })
  --
  -- See `:help gitsigns` to understand what the configuration keys do
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    enabled = true,
    opts = {
      numhl = true,
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
  vim.keymap.set('n', ']h', '<cmd>Gitsigns next_hunk<cr>', { noremap = true, silent = true, desc = '[G]it next hunk' }),
  vim.keymap.set('n', '[h', '<cmd>Gitsigns prev_hunk<cr>', { noremap = true, silent = true, desc = '[G]it previous hunk' }),
  vim.keymap.set('n', '<leader>gu', '<cmd>Gitsigns reset_hunk<cr>', { noremap = true, silent = true, desc = '[G]it [U]ndo hunk' }),
  vim.keymap.set('n', '<leader>gw', '<cmd>Gitsigns preview_hunk<cr>', { noremap = true, silent = true, desc = '[G]it Revie[W] hunk' }),
  -- PRs
  -- vim.keymap.set('n', '<leader>gpo', '<cmd>GHOpenPR<cr>', { noremap = true, silent = true, desc = '[G]it [P]R [O]pen' }),
  -- vim.keymap.set('n', '<leader>gpr', '<cmd>GHStartReview<cr>', { noremap = true, silent = true, desc = '[G]it [P]R [R]eview start' }),
  -- vim.keymap.set('n', '<leader>gpf', '<cmd>GHSubmitReview<cr>', { noremap = true, silent = true, desc = '[G]it [P]R [F]inish review' }),
  -- vim.keymap.set('n', '<leader>gpc', '<cmd>GHCreateThread<cr>', { noremap = true, silent = true, desc = '[G]it [P]R [C]omment' }),
}
