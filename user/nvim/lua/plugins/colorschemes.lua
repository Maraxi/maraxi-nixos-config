  return {
    {
      "folke/tokyonight.nvim",
      enabled = true,
      lazy = false,
      config = function()
	vim.cmd.colorscheme "tokyonight"
      end,
      priority = 1000,
    },
  }
