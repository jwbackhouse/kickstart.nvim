-- After https://github.com/jedrzejboczar/possession.nvim/issues/22#issuecomment-1413401663
-- and https://github.com/goolord/alpha-nvim/discussions/16#discussioncomment-10062303
return {
  {
    'goolord/alpha-nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'nvim-lua/plenary.nvim',
    },
    config = function()
      local dashboard = require 'alpha.themes.dashboard'

      -- helper function for utf8 chars
      local function getCharLen(s, pos)
        local byte = string.byte(s, pos)
        if not byte then
          return nil
        end
        return (byte < 0x80 and 1) or (byte < 0xE0 and 2) or (byte < 0xF0 and 3) or (byte < 0xF8 and 4) or 1
      end

      local function applyColors(logo, colors, logoColors)
        dashboard.section.header.val = logo

        for key, color in pairs(colors) do
          local name = 'Alpha' .. key
          vim.api.nvim_set_hl(0, name, color)
          colors[key] = name
        end

        dashboard.section.header.opts.hl = {}
        for i, line in ipairs(logoColors) do
          local highlights = {}
          local pos = 0

          for j = 1, #line do
            local opos = pos
            pos = pos + getCharLen(logo[i], opos + 1)

            local color_name = colors[line:sub(j, j)]
            if color_name then
              table.insert(highlights, { color_name, opos, pos })
            end
          end

          table.insert(dashboard.section.header.opts.hl, highlights)
        end
        return dashboard.opts
      end

      require('alpha').setup(applyColors({
        [[  ███       ███  ]],
        [[  ████      ████ ]],
        [[  ████     █████ ]],
        [[ █ ████    █████ ]],
        [[ ██ ████   █████ ]],
        [[ ███ ████  █████ ]],
        [[ ████ ████ ████ ]],
        [[ █████  ████████ ]],
        [[ █████   ███████ ]],
        [[ █████    ██████ ]],
        [[ █████     █████ ]],
        [[ ████      ████ ]],
        [[  ███       ███  ]],
        [[                    ]],
        [[  N  E  O  V  I  M  ]],
      }, {
        ['b'] = { fg = '#3399ff', ctermfg = 33 },
        ['a'] = { fg = '#53C670', ctermfg = 35 },
        ['g'] = { fg = '#39ac56', ctermfg = 29 },
        ['h'] = { fg = '#33994d', ctermfg = 23 },
        ['i'] = { fg = '#33994d', bg = '#39ac56', ctermfg = 23, ctermbg = 29 },
        ['j'] = { fg = '#53C670', bg = '#33994d', ctermfg = 35, ctermbg = 23 },
        ['k'] = { fg = '#30A572', ctermfg = 36 },
      }, {
        [[  kkkka       gggg  ]],
        [[  kkkkaa      ggggg ]],
        [[ b kkkaaa     ggggg ]],
        [[ bb kkaaaa    ggggg ]],
        [[ bbb kaaaaa   ggggg ]],
        [[ bbbb aaaaaa  ggggg ]],
        [[ bbbbb aaaaaa igggg ]],
        [[ bbbbb  aaaaaahiggg ]],
        [[ bbbbb   aaaaajhigg ]],
        [[ bbbbb    aaaaajhig ]],
        [[ bbbbb     aaaaajhi ]],
        [[ bbbbb      aaaaajh ]],
        [[  bbbb       aaaaa  ]],
        [[                    ]],
        [[  a  a  a  b  b  b  ]],
      }))
      dashboard.section.buttons.val = {
        dashboard.button('e', ' ' .. ' New file', ':enew <BAR> startinsert <CR>'),
        dashboard.button('o', '󰄉 ' .. ' Recent files', ":lua Snacks.picker.recent({layout = 'dropdown' }) <CR>"),
        dashboard.button('f', ' ' .. ' Find files', ':lua Snacks.picker.smart() <CR>'),
        dashboard.button('g', ' ' .. ' Find text', ':lua Snacks.picker.grep() <CR>'),
        dashboard.button('b', ' ' .. ' Git branches', ':lua Snacks.picker.git_branches({layout = "vscode"}) <CR>'),
        dashboard.button('c', ' ' .. ' Config', ':e ~/.config/nvim/init.lua<CR>'),
        dashboard.button('t', ' ' .. ' Typing', ':Typr <CR>'),
        dashboard.button('q', ' ' .. ' Quit', ':qa<CR>'),
        (function()
          local group = { type = 'group', opts = { spacing = 0 } }
          group.val = {
            {
              type = 'text',
              val = 'Sessions',
              opts = {
                position = 'center',
              },
            },
          }
          local path = vim.fn.stdpath 'data' .. '/possession'
          local files = vim.split(vim.fn.glob(path .. '/*.json'), '\n')
          for i, file in pairs(files) do
            local basename = vim.fs.basename(file):gsub('%.json', '')
            local button = dashboard.button(tostring(i), ' ' .. basename, '<cmd>PossessionLoad ' .. basename .. '<cr>')
            table.insert(group.val, button)
          end
          return group
        end)(),
      }
      dashboard.opts.layout[1].val = 8
    end,
  },
  vim.keymap.set('n', '<leader>ta', '<cmd>Alpha<CR>', { noremap = true, silent = true, desc = '[T]oggle [A]lpha' }),
}
