return {
  -- Named session management
  {
    "Shatur/neovim-session-manager",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    event = "VeryLazy",
    config = function()
      local Path = require("plenary.path")
      local config = require("session_manager.config")

      require("session_manager").setup({
        sessions_dir = Path:new(vim.fn.stdpath("data"), "sessions"), -- Sessions directory
        autoload_mode = config.AutoloadMode.CurrentDir, -- Auto-load session for cwd
        autosave_last_session = true, -- Auto-save session on exit
        autosave_ignore_not_normal = true, -- Don't save if not in normal mode
        autosave_ignore_dirs = {}, -- Directories to ignore
        autosave_ignore_filetypes = { "gitcommit", "gitrebase" },
        autosave_ignore_buftypes = {},
        autosave_only_in_session = false, -- Always autosave
        max_path_length = 80, -- Shorten session names
      })

      -- Auto-save session on exit
      vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
          require("session_manager").save_current_session()
        end,
      })
    end,
    keys = {
      { "<leader>Sl", "<cmd>SessionManager load_session<cr>", desc = "Load session" },
      { "<leader>Ss", "<cmd>SessionManager save_current_session<cr>", desc = "Save session" },
      { "<leader>Sd", "<cmd>SessionManager delete_session<cr>", desc = "Delete session" },
      { "<leader>Sc", "<cmd>SessionManager load_current_dir_session<cr>", desc = "Load current dir session" },
      { "<leader>SL", "<cmd>SessionManager load_last_session<cr>", desc = "Load last session" },
    },
  },

  -- Integrate with persistence.nvim (LazyVim default)
  {
    "folke/persistence.nvim",
    opts = {
      dir = vim.fn.stdpath("data") .. "/sessions/",
    },
  },
}
