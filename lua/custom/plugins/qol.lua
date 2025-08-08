vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set('x', '<leader>v', [["_dP]])
-- vim.keymap.set('n', '/', function()
--   return ':normal! /\\v' .. vim.fn.input 'Search: ' .. '<CR>zz'
-- end, { expr = true })
-- Don't write to register when hitting 'x'
vim.keymap.set('n', 'x', '"_x', { noremap = true, silent = true })
-- Select all :)
vim.keymap.set('n', '<D-a>', 'ggVG', { noremap = true, silent = true })
-- Clear contents of line
vim.keymap.set('n', '<leader>dd', '0"_d$', { noremap = true, silent = true })

-- Auto resize splits when the terminal's window is resized
vim.api.nvim_create_autocmd('VimResized', {
  command = 'wincmd =',
})

local function pick_cmd_result(picker_opts)
  local git_root = Snacks.git.get_root()
  vim.print(git_root)
  local function finder(opts, ctx)
    return require('snacks.picker.source.proc').proc({
      opts,
      {
        cmd = picker_opts.cmd,
        args = picker_opts.args,
        transform = function(item)
          item.cwd = picker_opts.cwd or git_root
          item.file = item.text
        end,
      },
    }, ctx)
  end

  Snacks.picker.pick {
    source = picker_opts.name,
    finder = finder,
    preview = picker_opts.preview,
    title = picker_opts.title,
  }
end

-- Custom Pickers
local custom_pickers = {}

function custom_pickers.git_show()
  pick_cmd_result {
    cmd = 'git',
    args = { 'diff-tree', '--no-commit-id', '--name-only', '--diff-filter=d', 'HEAD', '-r' },
    name = 'git_show',
    title = 'Git Last Commit',
    preview = 'git_show',
  }
end

function custom_pickers.git_diff_upstream()
  pick_cmd_result {
    cmd = 'git',
    -- args = { 'diff-tree', '--no-commit-id', '--name-only', '--diff-filter=d', 'HEAD@{u}..HEAD', '-r' },
    args = { 'diff-tree', '--no-commit-id', '--name-only', '--diff-filter=d', '--first-parent', 'origin/develop..HEAD', '-r' },
    name = 'git_diff_upstream',
    title = 'Git Branch Changed Files',
    preview = 'file',
  }
end

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
      indent = { enabled = false },
      input = { enabled = true },
      lazygit = {
        config = {
          os = {
            edit = 'nvim --server "$NVIM" --remote {{filename}}',
            editAtLine = 'nvim --server "$NVIM" --remote {{filename}}; [ -z "$NVIM" ] || nvim --server "$NVIM" --remote-send ":{{line}}<CR>"',
            editAtLineAndWait = 'nvim +{{line}} {{filename}}',
            editTemplate = "nvim --server '$NVIM' --remote {{filename}}",
          },
        },
      },
      picker = {
        ui_select = true,
        matcher = {
          frecency = true,
          cwd_bonus = true,
        },
        formatters = {
          file = {
            truncate = 90,
          },
        },
        sources = {
          files = {
            hidden = true,
          },
          grep = {
            hidden = true,
          },
        },
      },
      explorer = { enabled = false },
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
        enabled = false,
        left = { 'mark', 'sign' }, -- priority of signs on the left (high to low)
        right = { 'fold', 'git' }, -- priority of signs on the right (high to low)
        folds = {
          open = false, -- show open fold icons
          git_hl = false, -- use Git Signs hl for fold icons
        },
        git = {
          -- patterns to match Git signs
          enabled = false,
          patterns = { 'GitSign', 'MiniDiffSign' },
        },
        refresh = 50, -- refresh at most every 50ms
      },
      toggle = { enabled = true },
      zen = {
        win = {
          backdrop = {
            transparent = false,
          },
        },
        toggles = {
          dim = false,
        },
      },
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
        '<leader>gb',
        function()
          Snacks.picker.git_branches {
            layout = 'vscode',
            all = true,
          }
        end,
        desc = '[G]it [B]ranches',
      },
      {
        '<leader>fi',
        function()
          Snacks.picker.lines()
        end,
        desc = '[F]ind In L[I]nes',
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
          -- This copies the default config in order to change a few widths
          -- There should be a better way...
          Snacks.picker.smart {
            layout = {
              preset = 'default',
              layout = {
                box = 'horizontal',
                width = 0.9,
                min_width = 120,
                height = 0.8,
                {
                  box = 'vertical',
                  border = 'rounded',
                  title = '{title} {live} {flags}',
                  { win = 'input', height = 1, border = 'bottom' },
                  { win = 'list', border = 'none' },
                },
                { win = 'preview', title = '{preview}', border = 'rounded', width = 0.4 },
              },
            },
          }
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
          Snacks.picker.recent {
            formatters = {
              file = {
                truncate = 100,
              },
            },
            preview = 'none',
            layout = {
              preset = 'dropdown',
              layout = {
                width = 0.5,
              },
            },
          }
        end,
        desc = '[F]ind [O]ldfiles',
      },
      {
        '<leader>fr',
        function()
          Snacks.picker.resume()
        end,
        desc = '[F]ind [R]esume',
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
        '<leader>fh',
        function()
          Snacks.picker.help()
        end,
        desc = '[F]ind [H]elp',
      },
      { '<leader>fi', custom_pickers.git_show, desc = '[F]ind G[I]t Show' },
      { '<leader>fb', custom_pickers.git_diff_upstream, desc = 'Find in Git Branch' },
      {
        '<leader>fd',
        function()
          Snacks.picker.git_status()
        end,
        desc = 'Find in Git Diff',
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
      -- {
      --   ']w',
      --   function()
      --     Snacks.words.jump(vim.v.count1)
      --   end,
      --   desc = 'Next Reference',
      --   mode = { 'n', 't' },
      -- },
      -- {
      --   '[w',
      --   function()
      --     Snacks.words.jump(-vim.v.count1)
      --   end,
      --   desc = 'Prev Reference',
      --   mode = { 'n', 't' },
      -- },
      {
        '<leader>tz',
        function()
          Snacks.zen()
        end,
        desc = '[T]oggle [Z]en mode',
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
  {
    'dmtrKovalenko/fff.nvim',
    build = 'cargo build --release',
    opts = {},
    keys = {
      {
        'ff',
        function()
          require('fff').find_files() -- or find_in_git_root() if you only want git files
        end,
        desc = 'Open file picker',
      },
    },
  },
  {
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplac [)] [']
      require('mini.surround').setup()
      require('mini.operators').setup {
        replace = {
          prefix = 'gl',
        },
      }
      require('mini.diff').setup()
      require('mini.pairs').setup {
        mappings = {
          -- after https://gist.github.com/tmerse/dc21ec932860013e56882f23ee9ad8d2
          [')'] = { action = 'close', pair = '()', neigh_pattern = '[^\\].' },
          ['('] = {
            action = 'open',
            pair = '()',
            neigh_pattern = '.[%s%z%)]',
            register = { cr = false },
          },

          [']'] = { action = 'close', pair = '[]', neigh_pattern = '[^\\].' },
          ['['] = {
            action = 'open',
            pair = '[]',
            neigh_pattern = '.[%s%z%)}%]]',
            register = { cr = false },
          },

          ['}'] = { action = 'close', pair = '{}', neigh_pattern = '[^\\].' },
          ['{'] = {
            action = 'open',
            pair = '{}',
            neigh_pattern = '.[%s%z%)}%]]',
            register = { cr = false },
          },

          -- Double quote: Prevent pairing if either side is a letter
          ['"'] = {
            action = 'closeopen',
            pair = '""',
            neigh_pattern = '[^%w\\][^%w]',
            register = { cr = false },
          },
          -- Single quote: Prevent pairing if either side is a letter
          ["'"] = {
            action = 'closeopen',
            pair = "''",
            neigh_pattern = '[^%w\\][^%w]',
            register = { cr = false },
          },
          -- Backtick: Prevent pairing if either side is a letter
          ['`'] = {
            action = 'closeopen',
            pair = '``',
            neigh_pattern = '[^%w\\][^%w]',
            register = { cr = false },
          },
        },
      }

      local animate = require 'mini.animate'
      animate.setup {
        scroll = { enable = true, timing = animate.gen_timing.linear { duration = 70, unit = 'total' } },
        resize = { enable = false },
        open = { enable = false },
        close = { enable = false },
        cursor = { enable = false },
      }

      -- Highlight hex colours
      local hipatterns = require 'mini.hipatterns'
      hipatterns.setup {
        highlighters = {
          hex_color = hipatterns.gen_highlighter.hex_color { style = 'full' },
        },
      }
    end,
  },
  {
    'nullromo/go-up.nvim',
    opts = {
      goUpLimit = 'center',
    },
    config = function(_, opts)
      local goUp = require 'go-up'
      goUp.setup(opts)
    end,
    init = function()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'VeryLazy',
        callback = function()
          local function center_after_move(keys)
            return function()
              local count = vim.v.count
              if count == 0 then
                vim.cmd('normal! ' .. keys)
              else
                vim.cmd('normal! ' .. count .. keys)
              end
              require('go-up').centerScreen()
            end
          end

          -- Center after moving to the top or bottom
          vim.keymap.set('n', 'gg', center_after_move 'gg', { noremap = true, silent = true })
          vim.keymap.set('n', 'G', center_after_move 'G', { noremap = true, silent = true })

          -- Keep your existing scroll mappings
          vim.keymap.set('n', '<C-d>', [[<Cmd>lua vim.cmd('normal! <C-d>'); MiniAnimate.execute_after('scroll', require('go-up').centerScreen)<CR>]])
          vim.keymap.set('n', '<C-u>', [[<Cmd>lua vim.cmd('normal! <C-u>'); MiniAnimate.execute_after('scroll', require('go-up').centerScreen)<CR>]])
        end,
      })
    end,
  },
  {
    'OXY2DEV/helpview.nvim',
    lazy = false,
    opts = {
      preview = {
        icon_provider = 'devicons',
      },
    },
  },
  {
    'rachartier/tiny-inline-diagnostic.nvim',
    event = 'VeryLazy', -- Or `LspAttach`
    priority = 1000, -- needs to be loaded in first
    config = function()
      require('tiny-inline-diagnostic').setup {
        options = {
          show_source = true,
          multilines = true,
          break_line = {
            enabled = true,
            after = 60,
          },
        },
        disabled_ft = {},
      }
      vim.diagnostic.config { virtual_text = false } -- Only if needed in your configuration, if you already have native LSP diagnostics
    end,
  },
  {
    'altermo/ultimate-autopair.nvim',
    enabled = false,
    event = { 'InsertEnter', 'CmdlineEnter' },
    branch = 'v0.6', --recommended as each new version will have breaking changes
    opts = {
      cr = {
        enable = true,
        autoclose = true,
      },
      close = { enable = true },
    },
  },
}
