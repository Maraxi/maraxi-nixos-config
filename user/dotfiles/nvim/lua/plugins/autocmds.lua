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
end
