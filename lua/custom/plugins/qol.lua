vim.keymap.set('n', 'G', 'Gzz', { noremap = true, silent = true })
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set('x', '<leader>v', [["_dP]])
-- Don't write to register when hitting 'x'
vim.keymap.set('n', 'x', '"_x', { noremap = true, silent = true })

-- Auto resize splits when the terminal's window is resized
vim.api.nvim_create_autocmd('VimResized', {
  command = 'wincmd =',
})

return {
  {
    'folke/snacks.nvim',
    enabled = true,
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = false },
      dashboard = { enabled = false },
      indent = { enabled = true },
      input = { enabled = true },
      lazygit = {},
      picker = {
        -- layout = 'dropdown',
      },
      explorer = {},
      notifier = {
        enabled = true,
        timeout = 3000,
      },
      quickfile = { enabled = true },
      scope = { enabled = false },
      scratch = { enabled = false },
      scroll = {
        enabled = false,
        animate = {
          duration = { step = 15, total = 100 },
        },
      },
      statuscolumn = {
        enabled = true,
        left = { 'mark', 'sign' }, -- priority of signs on the left (high to low)
        right = { 'fold', 'git' }, -- priority of signs on the right (high to low)
        folds = {
          open = false, -- show open fold icons
          git_hl = false, -- use Git Signs hl for fold icons
        },
        git = {
          -- patterns to match Git signs
          enabled = true,
          patterns = { 'GitSign', 'MiniDiffSign' },
        },
        refresh = 50, -- refresh at most every 50ms
      },
      toggle = { enabled = true },
      words = { enabled = true },
      styles = {
        notification = {
          -- wo = { wrap = true } -- Wrap notifications
        },
      },
    },
    keys = {
      {
        '<leader>qn',
        function()
          Snacks.notifier.show_history()
        end,
        desc = '[Q]ol [N]otification History',
      },
      {
        '<leader>gx',
        function()
          Snacks.picker.git_log()
        end,
        desc = '[G]it Log Picker [X]',
      },
      {
        '<leader>fn',
        function()
          Snacks.picker.lines()
        end,
        desc = '[F]ind In L[I]nes',
      },
      {
        '<leader>gb',
        function()
          Snacks.picker.git_branches {
            layout = 'vscode',
          }
        end,
        desc = '[G]it [B]ranches',
      },
      {
        '<leader>fn',
        function()
          Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
        end,
        desc = '[F]ind [N]eovim Config',
      },
      {
        '<leader>ff',
        function()
          Snacks.picker.smart()
        end,
        desc = '[F]ind Smart [F]ind Files',
      },
      {
        '<leader>fl',
        function()
          Snacks.picker.files()
        end,
        desc = '[F]ind Find Fi[L]es',
      },
      {
        '<leader>fo',
        function()
          Snacks.picker.recent { layout = 'dropdown' }
        end,
        desc = '[F]ind [O]ldfiles',
      },
      {
        '<leader>fs',
        function()
          Snacks.picker.pickers()
        end,
        desc = '[F]ind [S]elect Picker',
      },
      {
        '<leader>fw',
        function()
          Snacks.picker.grep_word()
        end,
        desc = '[F]ind Search [W]ord',
      },
      {
        '<leader><leader>',
        function()
          Snacks.picker.buffers()
        end,
        desc = '[F]ind [B]uffers',
      },
      {
        '<leader>fg',
        function()
          Snacks.picker.grep()
        end,
        desc = '[F]ind [G]rep',
      },
      {
        '<leader>fx',
        function()
          Snacks.explorer()
        end,
        desc = '[F]ind E[x]plorer',
      },
      {
        'gd',
        function()
          Snacks.picker.lsp_definitions()
        end,
        desc = '[G]oto [D]efinition',
      },
      {
        'gr',
        function()
          Snacks.picker.lsp_references()
        end,
        nowait = true,
        desc = '[G]oto [R]eferences',
      },
      {
        '<leader>bc',
        function()
          Snacks.bufdelete()
        end,
        desc = '[B]uffer [C]lose',
      },
      -- {
      --   '<leader>cR',
      --   function()
      --     Snacks.rename.rename_file()
      --   end,
      --   desc = 'Rename File',
      -- },
      {
        '<leader>gw',
        function()
          Snacks.gitbrowse()
        end,
        desc = '[G]it Open On [W]eb',
        mode = { 'n', 'v' },
      },
      {
        '<leader>gm',
        function()
          Snacks.git.blame_line()
        end,
        desc = '[G]it Bla[M]e Line',
      },
      {
        '<leader>gf',
        function()
          Snacks.lazygit.log_file()
        end,
        desc = '[G]it Current [F]ile History',
      },
      {
        '<leader>gl',
        function()
          Snacks.lazygit {
            win = {
              style = 'minimal',
            },
          }
        end,
        desc = '[G]it [L]azygit',
      },
      {
        '<leader>gr',
        function()
          Snacks.lazygit.log()
        end,
        desc = '[G]it [R]eflog',
      },
      {
        '<c-/>',
        function()
          Snacks.terminal()
        end,
        desc = 'Toggle Terminal',
      },
      {
        '<c-_>',
        function()
          Snacks.terminal()
        end,
        desc = 'which_key_ignore',
      },
      {
        ']w',
        function()
          Snacks.words.jump(vim.v.count1)
        end,
        desc = 'Next Reference',
        mode = { 'n', 't' },
      },
      {
        '[w',
        function()
          Snacks.words.jump(-vim.v.count1)
        end,
        desc = 'Prev Reference',
        mode = { 'n', 't' },
      },
    },
    init = function()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'VeryLazy',
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command

          Snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>qs'
          Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>qw'
          Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map '<leader>qL'
          Snacks.toggle.diagnostics():map '<leader>qd'
          Snacks.toggle.line_number():map '<leader>ql'
          Snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map '<leader>qc'
          Snacks.toggle.inlay_hints():map '<leader>qh'
          Snacks.toggle.indent():map '<leader>qg'
          Snacks.toggle.dim():map '<leader>qD'
        end,
      })
    end,
  },
}
