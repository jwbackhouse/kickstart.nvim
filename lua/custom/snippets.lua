-- Luasnip
if vim.g.snippets ~= 'luasnip' then
  return
end

local ls = require 'luasnip'
local types = require 'luasnip.util.types'

ls.config.set_config {
  history = true,
  updateevents = 'TextChanged,TextChangedI',
  enable_autosnippets = true,
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { 'choice', 'Comment' } },
      },
    },
  },
}

vim.keymap.set({ 'i' }, '<Tab>', function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true })
vim.keymap.set({ 'i', 's' }, '<C-x>', function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true })
-- Cycle through choices
vim.keymap.set({ 'i', 's' }, '<D-Tab>', function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, { silent = true })

ls.snippets = {
  all = {
    ls.parser.parse_snippet('expand', 'this is what was expanded!'),
  },
  lua = {},
}
