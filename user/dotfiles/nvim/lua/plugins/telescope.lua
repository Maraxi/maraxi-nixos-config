return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    config = function()
      require('telescope').setup {
        pickers = {
          find_files = {
            -- theme = 'ivy'
          }
        },
      }
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>fd', builtin.find_files, { desc = 'Telescope find files' })
      vim.keymap.set('n', '<leader>en', function()
        builtin.find_files {
          cwd = vim.fn.stdpath("config")
        }
      end, { desc = 'Telescope find neovim config files' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
    end
  },
}
