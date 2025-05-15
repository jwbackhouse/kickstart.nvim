return {
  {
    'dgox16/oldworld.nvim',
    name = 'oldworld',
    lazy = true,
  },
  {
    'rmehri01/onenord.nvim',
    name = 'onenord',
    lazy = true,
    -- init = function()
    --   vim.o.termguicolors = true
    --   vim.cmd.colorscheme 'onenord'
    -- end,
  },
  { 'disrupted/one.nvim' },
  {
    'folke/tokyonight.nvim',
    enabled = true,
    lazy = true,
    init = function()
      vim.o.termguicolors = true
      vim.cmd.colorscheme 'tokyonight-storm'
    end,
  },
}
