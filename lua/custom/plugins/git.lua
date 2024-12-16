-- Git-related plugins
return {
  {
    'kdheepak/lazygit.nvim',
    lazy = true,
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
    -- optional for floating window border decoration
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { '<leader>gl', '<cmd>LazyGit<cr>', desc = '[G]it [L]azyGit' },
    },
  },
  { 'f-person/git-blame.nvim', event = 'VeryLazy', opts = {
    date_format = '%d-%m-%Y',
  } },
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'sindrets/diffview.nvim', -- optional - Diff integration
      'nvim-telescope/telescope.nvim', -- optional
    },
    config = true,
  },
  {
    'ldelossa/gh.nvim',
    event = 'VeryLazy',
    dependencies = {
      {
        'ldelossa/litee.nvim',
        config = function()
          require('litee.lib').setup()
        end,
      },
    },
    config = function()
      require('litee.gh').setup()
    end,
  },
  { 'ldelossa/litee.nvim', event = 'VeryLazy' },

  -- Here is a more advanced example where we pass configuration
  -- options to `gitsigns.nvim`. This is equivalent to the following Lua:
  --    require('gitsigns').setup({ ... })
  --
  -- See `:help gitsigns` to understand what the configuration keys do
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  -- Keybindings
  vim.keymap.set('n', '<leader>gd', '<cmd>DiffviewOpen<cr>', { noremap = true, silent = true, desc = '[G]it [D]iffview' }),
  -- PRs
  vim.keymap.set('n', '<leader>gpo', '<cmd>GHOpenPR<cr>', { noremap = true, silent = true, desc = '[G]it [P]R [O]pen' }),
  vim.keymap.set('n', '<leader>gpr', '<cmd>GHStartReview<cr>', { noremap = true, silent = true, desc = '[G]it [P]R [R]eview start' }),
  vim.keymap.set('n', '<leader>gpf', '<cmd>GHSubmitReview<cr>', { noremap = true, silent = true, desc = '[G]it [P]R [F]inish review' }),
  vim.keymap.set('n', '<leader>gpc', '<cmd>GHCreateThread<cr>', { noremap = true, silent = true, desc = '[G]it [P]R [C]omment' }),
}
