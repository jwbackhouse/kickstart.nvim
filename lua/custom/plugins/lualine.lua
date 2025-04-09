local function config_lualine(colors)
  local modecolor = {
    n = colors.teal,
    i = colors.red,
    v = colors.purple,
    ['␖'] = colors.purple,
    V = colors.red,
    c = colors.yellow,
    no = colors.red,
    s = colors.yellow,
    S = colors.yellow,
    ['␓'] = colors.yellow,
    ic = colors.yellow,
    R = colors.green,
    Rv = colors.purple,
    cv = colors.red,
    ce = colors.red,
    r = colors.cyan,
    rm = colors.cyan,
    ['r?'] = colors.cyan,
    ['!'] = colors.red,
    t = colors.bright_red,
  }

  local theme = {
    normal = {
      a = { fg = colors.bg_dark, bg = colors.blue },
      b = { fg = colors.white, bg = colors.bg_mid },
      c = { fg = colors.white, bg = colors.bg },
      z = { fg = colors.white, bg = colors.bg },
    },
    insert = { a = { fg = colors.bg_dark, bg = colors.orange } },
    visual = { a = { fg = colors.bg_dark, bg = colors.green } },
    replace = { a = { fg = colors.bg_dark, bg = colors.green } },
  }

  local space = {
    function()
      return ' '
    end,
    color = { bg = colors.bg, fg = colors.blue },
  }

  local filelocation = {
    'filename',
    path = 1,
    file_status = true,
    fmt = function(str)
      local _, secondForwardSlash = string.find(str, '.-/.-/')
      if not secondForwardSlash then
        return str
      end
      return string.sub(str, 1, secondForwardSlash) .. '.../'
    end,
    separator = nil,
    padding = { right = 0 },
  }

  local filename = {
    'filename',
    path = 0,
    separator = { right = '' },
    padding = { left = 0 },
  }

  local inactive_winbar_filename = {
    'filename',
    color = { bg = colors.bg, fg = colors.dark5 },
  }

  local winbar_filename = {
    'filename',
    color = { bg = colors.bg, fg = colors.blue2, gui = 'bold' },
  }

  local filetype = {
    'filetype',
    icon_only = true,
    colored = false,
    padding = { left = 2, right = 0 },
  }

  local branch = {
    'branch',
    icon = '',
    padding = { left = 2, right = 0 },
  }

  local location = {
    'location',
    color = { bg = colors.purple, fg = colors.bg, gui = 'bold' },
    separator = { left = '' },
  }

  local diff = {
    'diff',
    separator = { right = '' },
    symbols = { added = ' ', modified = ' ', removed = ' ' },

    diff_color = {
      added = { fg = colors.teal },
      modified = { fg = colors.yellow },
      removed = { fg = colors.red },
    },
  }

  local modes = {
    'mode',
    color = function()
      local mode_color = modecolor
      return { bg = mode_color[vim.fn.mode()], fg = colors.bg_dark }
    end,
    separator = { right = '' },
  }

  local function getLspName()
    local bufnr = vim.api.nvim_get_current_buf()
    local buf_clients = vim.lsp.get_clients { bufnr = bufnr }
    local buf_ft = vim.bo.filetype
    if next(buf_clients) == nil then
      return '  No servers'
    end
    local buf_client_names = {}

    for _, client in pairs(buf_clients) do
      if client.name ~= 'null-ls' then
        table.insert(buf_client_names, client.name)
      end
    end

    local lint_s, lint = pcall(require, 'lint')
    if lint_s then
      for ft_k, ft_v in pairs(lint.linters_by_ft) do
        if type(ft_v) == 'table' then
          for _, linter in ipairs(ft_v) do
            if buf_ft == ft_k then
              table.insert(buf_client_names, linter)
            end
          end
        elseif type(ft_v) == 'string' then
          if buf_ft == ft_k then
            table.insert(buf_client_names, ft_v)
          end
        end
      end
    end

    local ok, conform = pcall(require, 'conform')
    local formatters = table.concat(conform.list_formatters_for_buffer(), ' ')
    if ok then
      for formatter in formatters:gmatch '%w+' do
        if formatter then
          table.insert(buf_client_names, formatter)
        end
      end
    end

    local hash = {}
    local unique_client_names = {}

    for _, v in ipairs(buf_client_names) do
      if not hash[v] then
        unique_client_names[#unique_client_names + 1] = v
        hash[v] = true
      end
    end
    local language_servers = table.concat(unique_client_names, ', ')

    return '  ' .. language_servers
  end

  local dia = {
    'diagnostics',
    sources = { 'nvim_diagnostic' },
    symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
    diagnostics_color = {
      error = { fg = colors.red },
      warn = { fg = colors.yellow },
      info = { fg = colors.purple },
      hint = { fg = colors.cyan },
    },
    color = { bg = colors.gray2, fg = colors.blue, gui = 'bold' },
    separator = { left = '' },
  }

  local lsp = {
    function()
      return getLspName()
    end,
    separator = { left = '', right = '' },
    color = { bg = colors.purple, fg = colors.bg, gui = 'italic,bold' },
  }

  require('lualine').setup {
    options = {
      icons_enabled = true,
      theme = theme,
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      disabled_filetypes = {
        statusline = {},
        winbar = {},
      },
      ignore_focus = {},
      always_divide_middle = true,
      globalstatus = true,
    },

    sections = {
      lualine_a = {
        modes,
      },
      lualine_b = {
        filetype,
        filelocation,
        filename,
        diff,
      },
      lualine_c = {
        branch,
      },
      lualine_x = {
        space,
      },
      lualine_y = { space },
      lualine_z = {
        dia,
        location,
      },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
    winbar = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { winbar_filename },
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
    inactive_winbar = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { inactive_winbar_filename },
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
  }
end

local function update_mode_colors(is_dark_mode)
  ---@class Palette
  local colors

  vim.o.background = is_dark_mode and 'dark' or 'light'

  if vim.g.colors_name == 'onenord' then
    colors = require('onenord.colors').load()
    colors.bg_dark = colors.bg
    colors.bg_mid = '#40485C'
  else
    colors = is_dark_mode and require 'tokyonight.colors.storm' or require('tokyonight.colors').setup { style = 'day' }
    colors.bg_mid = '#2f354d'
    if not is_dark_mode then
      colors.bg_mid = colors.bg_dark1
    end
  end

  config_lualine(colors)
  vim.cmd 'redrawstatus' -- Force a redraw
end

return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons', 'folke/tokyonight.nvim' },
  config = function()
    ---@class Palette
    local colors
    if vim.g.colors_name == 'onenord' then
      colors = require('onenord.colors').load()
    else
      colors = require 'tokyonight.colors.storm'
    end
    config_lualine(colors)
  end,
  update_mode_colors = update_mode_colors,
}
