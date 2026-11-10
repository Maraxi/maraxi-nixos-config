-- ########################
-- ##      AutoCmds      ##
-- ########################
do
  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking text',
    -- TODO: do I need the group?
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function() vim.hl.on_yank() end,
  })

  -- Fix for german keyboard. Emulate <C-]> with <Enter> in help pages. See :help tag
  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('HelpEnterKey', { clear = true }),
    pattern = 'help',
    callback = function() vim.keymap.set('n', '<CR>', '<C-]>', { buffer = true }) end,
  })

  vim.api.nvim_create_augroup('HelpVertical', { clear = true })
  vim.api.nvim_create_autocmd('BufWinEnter', {
    group = 'HelpVertical',
    callback = function(ev)
      if vim.bo[ev.buf].filetype == 'help' then vim.cmd 'wincmd L' end
    end,
  })

  -- No swap files for third-party code. Avoids E325 when another instance has the file open.
  -- SwapExists is not consulted when LSP opens the file via nvim_win_set_buf, so disable the swapfile instead.
  vim.api.nvim_create_autocmd({ 'BufNew', 'BufAdd' }, {
    group = vim.api.nvim_create_augroup('NoSwapThirdParty', { clear = true }),
    pattern = { '*/.venv/*', '*/site-packages/*', '*/node_modules/*' },
    callback = function(ev) vim.bo[ev.buf].swapfile = false end,
  })
end
