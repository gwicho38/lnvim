-- Colorscheme configuration with persistence

return {
  -- Gruvbox (warm, retro theme)
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
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
    end,
  },

  -- TokyoNight (modern, vibrant theme)
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night", -- "storm", "moon", "night", "day"
        transparent = false,
        styles = {
          sidebars = "dark",
          floats = "dark",
        },
      })
    end,
  },

  -- Catppuccin (pastel, soothing theme)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- "latte", "frappe", "macchiato", "mocha"
        transparent_background = false,
        integrations = {
          telescope = true,
          nvimtree = true,
          which_key = true,
          mason = true,
        },
      })
    end,
  },

}
