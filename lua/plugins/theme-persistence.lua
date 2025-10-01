-- Theme persistence system
return {
  {
    "nvim-lua/plenary.nvim",
    lazy = false,
    priority = 999, -- Load before colorschemes but after lazy.nvim
    config = function()
      local theme_persistence = require("config.theme-persistence")

      -- Load saved theme on startup
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          local saved_theme = theme_persistence.load_theme()

          if saved_theme then
            -- Apply saved theme with delay to ensure plugins are loaded
            vim.defer_fn(function()
              pcall(vim.cmd.colorscheme, saved_theme)
            end, 100)
          else
            -- Default theme if none saved
            vim.defer_fn(function()
              vim.cmd.colorscheme("gruvbox")
              theme_persistence.save_theme("gruvbox")
            end, 100)
          end
        end,
      })

      -- Auto-save any colorscheme change (works with LazyVim's picker too!)
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          local current_theme = vim.g.colors_name
          if current_theme then
            theme_persistence.save_theme(current_theme)
          end
        end,
      })

      -- Create commands
      vim.api.nvim_create_user_command("ThemeSelect", function()
        theme_persistence.theme_picker()
      end, { desc = "Select and save theme" })

      vim.api.nvim_create_user_command("ThemeSet", function(opts)
        theme_persistence.set_theme(opts.args)
      end, { nargs = 1, desc = "Set and save theme" })

      vim.api.nvim_create_user_command("ThemeSave", function()
        local current = vim.g.colors_name
        if current then
          theme_persistence.save_theme(current)
          vim.notify("Saved theme: " .. current, vim.log.levels.INFO)
        end
      end, { desc = "Save current theme" })
    end,
    keys = {
      { "<leader>ut", "<cmd>ThemeSelect<cr>", desc = "Select Theme" },
      { "<leader>uT", "<cmd>ThemeSave<cr>", desc = "Save Current Theme" },
    },
  },
}
