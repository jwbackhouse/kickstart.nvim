local function apply_custom_highlights()
  local hl = vim.api.nvim_set_hl

  -- Apply the specific highlights you want for TypeScript
  hl(0, '@keyword.typescript', {
    italic = true,
    fg = '#9d7cd8',
  })
  hl(0, '@keyword.function.typescript', {
    italic = true,
    fg = '#9d7cd8',
  })
  hl(0, '@keyword.coroutine.typescript', {
    italic = true,
    fg = '#9d7cd8',
  })

  hl(0, '@keyword.tsx', {
    italic = true,
    fg = '#9d7cd8',
  })
  hl(0, '@keyword.function.tsx', {
    italic = true,
    fg = '#9d7cd8',
  })
  hl(0, '@keyword.coroutine.tsx', {
    italic = true,
    fg = '#9d7cd8',
  })
end

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
    lazy = false,
    priority = 1000,
    config = function()
      require('tokyonight').setup {
        style = 'storm',
        day_brightness = 0.4,
        styles = {
          keywords = { italic = true },
          comments = { italic = true },
          functions = { italic = true },
          variables = { italic = true, bold = true },
        },
        on_highlights = function(hl, c)
          hl['@keyword.typescript'] = {
            italic = true,
            fg = '#9d7cd8',
          }
          hl['@keyword.function.typescript'] = {
            italic = true,
            fg = '#9d7cd8',
          }
          hl['@keyword.coroutine.typescript'] = {
            italic = true,
            fg = '#9d7cd8',
          }

          -- TSX highlights
          hl['@keyword.tsx'] = {
            italic = true,
            fg = '#9d7cd8',
          }
          hl['@keyword.function.tsx'] = {
            italic = true,
            fg = '#9d7cd8',
          }
          hl['@keyword.coroutine.tsx'] = {
            italic = true,
            fg = '#9d7cd8',
          }
        end,
      }
      vim.o.termguicolors = true
      vim.cmd.colorscheme 'tokyonight-storm'

      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter', 'FileType' }, {
        pattern = { '*.ts', '*.tsx', '*.js', '*.jsx' },
        callback = function(args)
          -- Wait a bit for TreeSitter to be ready
          vim.defer_fn(function()
            apply_custom_highlights()
          end, 100)
        end,
      })

      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
        callback = function(args)
          -- print(string.format("=== FileType autocmd fired: %s ===", args.match))
          vim.defer_fn(function()
            apply_custom_highlights()
          end, 200)
        end,
      })

      -- Reapply highlights after save operations (to handle ESLint/formatting reset)
      vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
        pattern = { '*.ts', '*.tsx', '*.js', '*.jsx' },
        callback = function(args)
          -- Small delay to let formatters/linters finish
          vim.defer_fn(function()
            apply_custom_highlights()
          end, 100)
        end,
      })
    end,
  },
}
