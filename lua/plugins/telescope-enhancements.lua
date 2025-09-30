-- Enhanced Telescope for better note searching
return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },
  keys = {
    -- Override default find files to search in vault
    {
      "<leader>fn",
      function()
        require("telescope.builtin").find_files({
          cwd = vim.fn.expand("~/repos/lefv-vault"),
          prompt_title = "Find Notes",
        })
      end,
      desc = "Find notes in vault",
    },
    {
      "<leader>fg",
      function()
        require("telescope.builtin").live_grep({
          cwd = vim.fn.expand("~/repos/lefv-vault"),
          prompt_title = "Grep Notes",
        })
      end,
      desc = "Grep in vault",
    },
  },
  opts = function(_, opts)
    local actions = require("telescope.actions")
    opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
      file_ignore_patterns = {
        "node_modules",
        ".git/",
        ".obsidian/",
        ".trash/",
        "%.mp4",
        "%.png",
        "%.jpg",
        "%.jpeg",
        "%.gif",
      },
      mappings = {
        i = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
        },
      },
    })
    return opts
  end,
}
