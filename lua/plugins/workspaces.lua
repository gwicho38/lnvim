return {
  "natecraddock/workspaces.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
  },
  event = "VeryLazy",
  config = function()
    require("workspaces").setup({
      -- Path to workspace configuration file
      path = vim.fn.stdpath("data") .. "/workspaces",

      -- Automatically change directory when switching workspaces
      cd_type = "global", -- or "tab", "local"

      -- Sort workspaces by name, last modified, or most recently opened
      sort = true,

      -- Use relative paths in workspace definitions
      mru_sort = true,

      -- Notify when workspace changes
      notify_info = true,

      -- Hooks to run when opening/closing workspaces
      hooks = {
        -- Open session when switching to workspace
        open_pre = {},
        open = function()
          -- Load session for the new workspace directory if it exists
          require("session_manager").load_current_dir_session()
        end,
        -- Add any additional hooks here
        add = {},
      },
    })

    -- Load telescope extension
    require("telescope").load_extension("workspaces")
  end,
  keys = {
    { "<leader>pw", "<cmd>Telescope workspaces<cr>", desc = "Switch workspace" },
    { "<leader>pa", "<cmd>WorkspacesAdd<cr>", desc = "Add workspace" },
    { "<leader>pr", "<cmd>WorkspacesRemove<cr>", desc = "Remove workspace" },
    { "<leader>pl", "<cmd>WorkspacesList<cr>", desc = "List workspaces" },
  },
}
