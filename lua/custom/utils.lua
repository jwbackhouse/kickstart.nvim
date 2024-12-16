local M = {}

function M.wordUnderCursor()
  return vim.fn.expand '<cword>'
end

function M.quicklog(opts)
  if not opts then
    opts = { addLineNumber = false }
  end

  local varname = M.wordUnderCursor()
  local logStatement
  local ft = vim.bo.filetype
  local lnStr = ''
  if opts.addLineNumber then
    lnStr = 'L' .. tostring(vim.lineNo '.') .. ' '
  end

  if ft == 'lua' then
    logStatement = 'print("' .. lnStr .. varname .. ':", ' .. varname .. ')'
  elseif ft == 'python' then
    logStatement = 'print("' .. lnStr .. varname .. ': " + ' .. varname .. ')'
  elseif ft == 'javascript' or ft == 'typescript' or ft == 'typescriptreact' or ft == 'javascriptreact' then
    logStatement = 'console.log("' .. lnStr .. varname .. ':", ' .. varname .. ')'
  elseif ft == 'zsh' or ft == 'bash' or ft == 'fish' or ft == 'sh' then
    logStatement = 'echo "' .. lnStr .. varname .. ': $' .. varname .. '"'
  elseif ft == 'applescript' then
    logStatement = 'log "' .. lnStr .. varname .. ': " & ' .. varname
  else
    vim.notify('Quicklog does not support ' .. ft .. ' yet.', vim.logWarn)
    return
  end

  local current_line = vim.fn.line '.'
  vim.api.nvim_buf_set_lines(0, current_line, current_line, false, { logStatement })
  vim.cmd [[normal! j==]] -- move down and indent
end

return M
