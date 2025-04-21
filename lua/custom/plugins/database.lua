return {
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod' },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' } },
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    event = 'VeryLazy',
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
  vim.keymap.set('n', '<leader>td', ':DBUI<CR>', { desc = '[T]oggle [D]BUI', noremap = true }),
}
