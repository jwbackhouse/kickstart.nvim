return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    local cc = require 'codecompanion'
    cc.setup {
      strategies = {
        chat = {
          adapter = 'copilot',
          slash_commands = {
            ['file'] = {
              opts = {
                provider = 'telescope',
              },
            },
          },
        },
        inline = {
          adapter = 'copilot',
        },
      },
      display = {
        chat = {
          window = {
            width = 0.3,
          },
        },
        diff = {
          provider = 'mini_diff',
        },
      },
    }

    vim.keymap.set({ 'n', 'v' }, '<D-i>', '<Cmd>CodeCompanionActions<CR>', { noremap = true, silent = true })
    vim.cmd [[cab cc CodeCompanion]] -- map cc to CodeCompanion in command line
  end,
}
