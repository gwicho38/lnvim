return {
  -- Dependency for menu
  { "nvzone/volt", lazy = true },

  -- Context menu plugin
  {
    "nvzone/menu",
    lazy = true,
    config = function()
      -- Custom menu definitions
      local menus = {}

      -- Default context menu
      -- Using string commands to avoid buffer issues with Snacks.picker
      menus.default = {
        { name = "󰈞  Find File", cmd = ":Telescope find_files<CR>", rtxt = "<leader>ff" },
        { name = "󰊄  Find Text", cmd = ":Telescope live_grep<CR>", rtxt = "<leader>sg" },
        { name = "separator" },
        { name = "  Format Buffer", cmd = function() LazyVim.format({ force = true }) end, rtxt = "<leader>cf" },
        { name = "  Code Actions", cmd = vim.lsp.buf.code_action, rtxt = "<leader>ca" },
        { name = "  Rename Symbol", cmd = vim.lsp.buf.rename, rtxt = "<leader>cr" },
        { name = "󰌵  LSP Actions", hl = "Exblue", items = "lsp" },
        { name = "separator" },
        { name = "  Git Status", cmd = ":Lazygit<CR>", rtxt = "<leader>gg" },
        { name = "  Git Blame", cmd = ":Telescope git_bcommits<CR>", rtxt = "<leader>gb" },
        { name = "󰊢  Git Add All", cmd = function()
          local result = vim.fn.system("git add .")
          if vim.v.shell_error == 0 then
            vim.notify("Git: staged all changes", vim.log.levels.INFO)
          else
            vim.notify("Git add failed: " .. result, vim.log.levels.ERROR)
          end
        end, rtxt = "<leader>ga" },
        { name = "separator" },
        { name = "󰈙  Copy All", cmd = "%y+", rtxt = "<C-c>" },
        { name = "󱉽  Open Vault", cmd = ":cd ~/repos/lefv-vault | Telescope find_files<CR>" },
        { name = "  Open Terminal", cmd = ":terminal<CR>", rtxt = "<leader>ft" },
        { name = "separator" },
        { name = "  Config", cmd = ":Telescope find_files cwd=" .. vim.fn.stdpath("config") .. "<CR>", rtxt = "<leader>fc" },
      }

      -- LSP submenu
      menus.lsp = {
        { name = "󰁨  Hover Info", cmd = vim.lsp.buf.hover, rtxt = "K" },
        { name = "  Go to Definition", cmd = vim.lsp.buf.definition, rtxt = "gd" },
        { name = "  Go to Declaration", cmd = vim.lsp.buf.declaration, rtxt = "gD" },
        { name = "󰌹  References", cmd = vim.lsp.buf.references, rtxt = "gr" },
        { name = "  Implementation", cmd = vim.lsp.buf.implementation, rtxt = "gI" },
        { name = "separator" },
        { name = "  Diagnostics", cmd = vim.diagnostic.open_float, rtxt = "<leader>cd" },
        { name = "  Next Diagnostic", cmd = vim.diagnostic.goto_next, rtxt = "]d" },
        { name = "  Prev Diagnostic", cmd = vim.diagnostic.goto_prev, rtxt = "[d" },
      }

      -- Store custom menus for access
      _G.custom_menus = menus
    end,
    keys = {
      -- Keyboard trigger
      {
        "<leader>m",
        function()
          require("menu").open(_G.custom_menus.default)
        end,
        desc = "Open Menu",
      },
      -- Right-click context menu
      {
        "<RightMouse>",
        function()
          -- Clean up old menus first
          require("menu.utils").delete_old_menus()

          -- Get mouse position info without simulating click
          local mouse = vim.fn.getmousepos()
          if mouse.winid > 0 then
            -- Move cursor to clicked window/position
            vim.api.nvim_set_current_win(mouse.winid)
          end

          -- Open menu at mouse position
          require("menu").open(_G.custom_menus.default, { mouse = true })
        end,
        mode = { "n", "v" },
        desc = "Context Menu",
      },
    },
  },
}
