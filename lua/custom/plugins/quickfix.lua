return {
  {
    'stevearc/quicker.nvim',
    event = 'FileType qf',
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {},
  },
  vim.keymap.set('n', '<leader>tq', function()
    require('quicker').toggle()
  end, {
    desc = '[T]oggle [Q]uickfix',
  }),
}
