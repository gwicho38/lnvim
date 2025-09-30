-- Colorscheme configuration
-- Uncomment and customize your preferred colorscheme

return {
  -- Gruvbox (warm, retro theme)
  {
    "ellisonleao/gruvbox.nvim",
    enabled = true,
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
          strings = true,
          comments = true,
          operators = false,
          folds = true,
        },
        contrast = "hard", -- "hard", "soft" or "" (normal)
        palette_overrides = {
          dark0_hard = "#1d2021",
        },
      })
      vim.cmd.colorscheme("gruvbox")
    end,
  },

  -- TokyoNight (modern, vibrant theme)
  -- {
  --   "folke/tokyonight.nvim",
  --   enabled = false,
  --   priority = 1000,
  --   opts = {
  --     style = "night", -- "storm", "moon", "night", "day"
  --     transparent = false,
  --   },
  --   config = function(_, opts)
  --     require("tokyonight").setup(opts)
  --     vim.cmd.colorscheme("tokyonight")
  --   end,
  -- },

  -- Catppuccin (pastel, soothing theme)
  -- {
  --   "catppuccin/nvim",
  --   name = "catppuccin",
  --   enabled = false,
  --   priority = 1000,
  --   opts = {
  --     flavour = "mocha", -- "latte", "frappe", "macchiato", "mocha"
  --   },
  --   config = function(_, opts)
  --     require("catppuccin").setup(opts)
  --     vim.cmd.colorscheme("catppuccin")
  --   end,
  -- },
}
