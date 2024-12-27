return {
  {
    'aaronik/treewalker.nvim',
    -- The following options are the defaults.
    -- Treewalker aims for sane defaults, so these are each individually optional,
    -- and the whole opts block is optional as well.
    opts = {
      -- Whether to briefly highlight the node after jumping to it
      highlight = true,

      -- How long should above highlight last (in ms)
      highlight_duration = 250,

      -- The color of the above highlight. Must be a valid vim highlight group.
      -- (see :h highlight-group for options)
      highlight_group = 'ColorColumn',
    },
  },

  vim.keymap.set({ 'n', 'v' }, '<D-j>', '<cmd>Treewalker Down<CR>', { noremap = true }),
  vim.keymap.set({ 'n', 'v' }, '<D-k>', '<cmd>Treewalker Up<CR>', { noremap = true }),
  vim.keymap.set({ 'n', 'v' }, '<D-h>', '<cmd>Treewalker Left<CR>', { noremap = true }),
  vim.keymap.set({ 'n', 'v' }, '<D-l>', '<cmd>Treewalker Right<CR>', { noremap = true }),
  vim.keymap.set('n', '<D-S-j>', '<cmd>Treewalker SwapDown<CR>', { noremap = true }),
  vim.keymap.set('n', '<D-S-k>', '<cmd>Treewalker SwapUp<CR>', { noremap = true }),
}
