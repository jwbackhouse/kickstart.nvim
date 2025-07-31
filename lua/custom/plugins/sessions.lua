return {
  {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    opts = {
      dir = vim.fn.stdpath 'state' .. '/sessions/',
      options = { 'buffers', 'curdir', 'tabpages', 'winsize' },
      need = 0,
      branch = true,
      pre_save = function()
        -- Save the current buffer before saving the session
        vim.cmd 'silent! write'
      end,
    },
  },
  {
    'cbochs/grapple.nvim',
    dependencies = {
      { 'nvim-tree/nvim-web-devicons', lazy = true },
    },
    opts = {
      scope = 'git_branch',
      win_opts = {
        width = 120,
      },
    },
    event = { 'BufReadPost', 'BufNewFile' },
    cmd = 'Grapple',
    keys = {
      { '<leader>st', '<cmd>Grapple toggle<cr>', desc = '[S]ession [T]ag File' },
      { '<leader>sw', '<cmd>Grapple toggle_tags<cr>', desc = '[S]ession Toggle [W]indow' },
      { '<leader>sl', '<cmd>Grapple toggle scope=global<cr>', desc = '[S]ession Tag File G[L]obal' },
      { '<leader>sg', '<cmd>Grapple toggle_tags scope=global<cr>', desc = '[S]ession Toggle [G]lobal Window' },
      { '<leader>so', '<cmd>Grapple cycle_tags next<cr>', desc = '[S]ession cycle previous tag [p]' },
      { '<leader>si', '<cmd>Grapple cycle_tags prev<cr>', desc = '[S]ession cycle next tag [i]' },

      { '<leader>1', '<cmd>Grapple select index=1<cr>', desc = 'Session [1]' },
      { '<leader>2', '<cmd>Grapple select index=2<cr>', desc = 'Session [2]' },
      { '<leader>3', '<cmd>Grapple select index=3<cr>', desc = 'Session [3]' },
      { '<leader>4', '<cmd>Grapple select index=4<cr>', desc = 'Session [4]' },
      { '<leader>5', '<cmd>Grapple select index=5<cr>', desc = 'Session [5]' },

      { '<leader>6', '<cmd>Grapple select index=1 scope=global <cr>', desc = 'Session Global [1]' },
      { '<leader>7', '<cmd>Grapple select index=2 scope=global <cr>', desc = 'Session Global [2]' },
      { '<leader>8', '<cmd>Grapple select index=3 scope=global <cr>', desc = 'Session Global [3]' },
      { '<leader>9', '<cmd>Grapple select index=4 scope=global <cr>', desc = 'Session Global [4]' },
      { '<leader>0', '<cmd>Grapple select index=5 scope=global <cr>', desc = 'Session Global [5]' },
    },
  },
}
