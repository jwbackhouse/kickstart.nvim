local M = {}
local builtin = require 'telescope.builtin'
local action_state = require 'telescope.actions.state'
local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local make_entry = require 'telescope.make_entry'
local conf = require('telescope.config').values

-- Grep-in-fuzzy-directory
local live_multigrep = function(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or vim.uv.cwd()

  local finder = finders.new_async_job {
    command_generator = function(prompt)
      if not prompt or prompt == '' then
        return nil
      end

      local pieces = vim.split(prompt, '  ')
      local args = { 'rg' }
      if pieces[1] then
        table.insert(args, '-e')
        table.insert(args, pieces[1])
      end

      if pieces[2] then
        table.insert(args, '-g')
        table.insert(args, pieces[2])
      end

      return vim.tbl_flatten { args, { '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case' } }
    end,

    entry_maker = make_entry.gen_from_vimgrep(opts),
    cwd = opts.cwd,
  }

  pickers
    .new(opts, {
      debounce = 100,
      prompt_title = 'Multi Grep',
      finder = finder,
      previewer = conf.grep_previewer(opts),
      sorter = require('telescope.sorters').empty(),
    })
    :find()
end

M.setup = function()
  vim.keymap.set('n', '<leader>sm', live_multigrep, { desc = '[S]earch [M]ulti Grep' })
end

-- Delete multiple buffers
-- after https://github.com/nvim-telescope/telescope.nvim/issues/621
vim.keymap.set('n', '<leader>sd', function()
  builtin.buffers({
    initial_mode = 'normal',
    attach_mappings = function(prompt_bufnr, map)
      local delete_buf = function()
        local current_picker = action_state.get_current_picker(prompt_bufnr)
        current_picker:delete_selection(function(selection)
          vim.api.nvim_buf_delete(selection.bufnr, { force = true })
        end)
      end

      map('n', '<c-d>', delete_buf)

      return true
    end,
  }, {
    sort_lastused = true,
    sort_mru = true,
    theme = 'dropdown',
  })
end)

return M
