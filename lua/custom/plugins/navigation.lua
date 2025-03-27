return {
  {
    'aaronik/treewalker.nvim',
    opts = {
      highlight = true,
      highlight_duration = 250,
      highlight_group = 'ColorColumn',
    },
  },
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {
      jump = {
        nohlsearch = true,
      },
      modes = {
        search = {
          enabled = true,
          highlight = {
            backdrop = true,
          },
        },
        char = {
          jump_labels = true,
        },
      },
    },
  -- stylua: ignore
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
  },

  vim.keymap.set({ 'n', 'v' }, '<D-j>', '<cmd>Treewalker Down<CR>', { noremap = true }),
  vim.keymap.set({ 'n', 'v' }, '<D-k>', '<cmd>Treewalker Up<CR>', { noremap = true }),
  vim.keymap.set({ 'n', 'v' }, '<D-g>', '<cmd>Treewalker Left<CR>', { noremap = true }),
  vim.keymap.set({ 'n', 'v' }, '<D-l>', '<cmd>Treewalker Right<CR>', { noremap = true }),
  vim.keymap.set('n', '<D-S-j>', '<cmd>Treewalker SwapDown<CR>', { noremap = true }),
  vim.keymap.set('n', '<D-S-k>', '<cmd>Treewalker SwapUp<CR>', { noremap = true }),
}
