-- Welcome screen and first-run experience
return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      -- Add welcome command
      vim.api.nvim_create_user_command("Welcome", function()
        local lines = {
          "",
          "  ███╗   ██╗██╗   ██╗██╗███╗   ███╗",
          "  ████╗  ██║██║   ██║██║████╗ ████║",
          "  ██╔██╗ ██║██║   ██║██║██╔████╔██║",
          "  ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║",
          "  ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║",
          "  ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
          "",
          "  Welcome to Your LazyVim Config!",
          "",
          "  🚀 Quick Start:",
          "  • <Space> - Open dashboard and shortcuts",
          "  • <C-,> - Toggle Claude Code AI assistant",
          "  • <C-S-P> - Open command palette",
          "  • <leader>ff - Find files",
          "  • <leader>gg - Open lazygit",
          "",
          "  📚 Learn More:",
          "  • :help - Neovim help",
          "  • :Lazy - Plugin manager",
          "  • :Mason - LSP/tool installer",
          "  • :checkhealth - Verify installation",
          "",
          "  🔧 Customize:",
          "  • Edit ~/.config/nvim/lua/plugins/ - Add plugins",
          "  • Read CLAUDE.md - Architecture docs",
          "  • Read TROUBLESHOOTING.md - Common issues",
          "",
          "  💡 First Time Setup:",
          "  1. Run :checkhealth",
          "  2. Install tools with :Mason",
          "  3. Setup Copilot with :Copilot setup (optional)",
          "  4. Configure Claude Code CLI (optional)",
          "",
          "  Press 'q' to close | Run :Welcome anytime",
          "",
        }

        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        vim.api.nvim_buf_set_option(buf, "modifiable", false)
        vim.api.nvim_buf_set_option(buf, "buftype", "nofile")

        local width = 60
        local height = #lines
        local win = vim.api.nvim_open_win(buf, true, {
          relative = "editor",
          width = width,
          height = height,
          col = (vim.o.columns - width) / 2,
          row = (vim.o.lines - height) / 2 - 2,
          style = "minimal",
          border = "rounded",
          title = " Welcome ",
          title_pos = "center",
        })

        vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "<cmd>close<CR>", { noremap = true, silent = true })
      end, {})

      -- Show welcome on first run
      local config_path = vim.fn.stdpath("config")
      local first_run_marker = config_path .. "/.first_run_complete"

      if vim.fn.filereadable(first_run_marker) == 0 then
        vim.api.nvim_create_autocmd("VimEnter", {
          once = true,
          callback = function()
            -- Wait a bit for plugins to load
            vim.defer_fn(function()
              vim.cmd("Welcome")
              -- Create marker file
              vim.fn.writefile({}, first_run_marker)
            end, 1000)
          end,
        })
      end

      return opts
    end,
  },
}
