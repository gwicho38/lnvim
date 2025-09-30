return {
  "FeiyouG/commander.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  keys = {
    {
      "<C-S-P>", -- Ctrl+Shift+P 
      function() require("commander").show() end,
      desc = "Open Command Palette",
    },
    {
      "<leader>cp", -- Space + c + p as alternative
      function() require("commander").show() end,
      desc = "Open Command Palette",
    },
  },
  config = function()
    local commander = require("commander")
    
    commander.setup({
      components = {
        "DESC",
        "KEYS",
        "CAT",
      },
      sort_by = {
        "DESC",
        "KEYS",
        "CAT",
        "CMD"
      },
      integration = {
        telescope = {
          enable = true,
          -- Theme for telescope
          theme = "commander",
        },
        lazy = {
          enable = true,
          set_plugin_name_as_cat = true,
        }
      }
    })

    -- Add common commands to the palette
    commander.add({
      {
        desc = "Find Files",
        cmd = require("telescope.builtin").find_files,
        keys = { "n", "<leader>ff" },
        cat = "telescope"
      },
      {
        desc = "Live Grep",
        cmd = require("telescope.builtin").live_grep,
        keys = { "n", "<leader>fg" },
        cat = "telescope"
      },
      {
        desc = "Recent Files",
        cmd = require("telescope.builtin").oldfiles,
        keys = { "n", "<leader>fr" },
        cat = "telescope"
      },
      {
        desc = "Buffers",
        cmd = require("telescope.builtin").buffers,
        keys = { "n", "<leader>fb" },
        cat = "telescope"
      },
      {
        desc = "Command History",
        cmd = require("telescope.builtin").command_history,
        keys = { "n", "<leader>:" },
        cat = "telescope"
      },
      {
        desc = "Search History", 
        cmd = require("telescope.builtin").search_history,
        keys = { "n", "<leader>/" },
        cat = "telescope"
      },
      {
        desc = "Help Tags",
        cmd = require("telescope.builtin").help_tags,
        keys = { "n", "<leader>fh" },
        cat = "telescope"
      },
      {
        desc = "Keymaps",
        cmd = require("telescope.builtin").keymaps,
        keys = { "n", "<leader>fk" },
        cat = "telescope"
      },
      {
        desc = "LSP Document Symbols",
        cmd = require("telescope.builtin").lsp_document_symbols,
        keys = { "n", "<leader>fs" },
        cat = "lsp"
      },
      {
        desc = "LSP Workspace Symbols", 
        cmd = require("telescope.builtin").lsp_workspace_symbols,
        keys = { "n", "<leader>fS" },
        cat = "lsp"
      },
      {
        desc = "Git Status",
        cmd = require("telescope.builtin").git_status,
        keys = { "n", "<leader>gs" },
        cat = "git"
      },
      {
        desc = "Git Commits",
        cmd = require("telescope.builtin").git_commits,
        keys = { "n", "<leader>gc" },
        cat = "git"
      },
      {
        desc = "Format Document",
        cmd = function() LazyVim.format({ force = true }) end,
        keys = { "n", "<leader>cf" },
        cat = "code"
      },
      {
        desc = "Toggle Relative Numbers",
        cmd = function() Snacks.toggle.option("relativenumber", { name = "Relative Number" })() end,
        keys = { "n", "<leader>uL" },
        cat = "ui"
      },
      {
        desc = "Toggle Line Numbers",
        cmd = function() Snacks.toggle.line_number()() end,
        keys = { "n", "<leader>ul" },
        cat = "ui"
      },
      {
        desc = "Toggle Dark Mode",
        cmd = function() Snacks.toggle.option("background", { off = "light", on = "dark" , name = "Dark Background" })() end,
        keys = { "n", "<leader>ub" },
        cat = "ui"
      },
      {
        desc = "Lazy Plugin Manager",
        cmd = "<cmd>Lazy<cr>",
        keys = { "n", "<leader>l" },
        cat = "lazy"
      },
      {
        desc = "Mason Package Manager", 
        cmd = "<cmd>Mason<cr>",
        cat = "mason"
      },
      {
        desc = "LazyVim Changelog",
        cmd = function() LazyVim.news.changelog() end,
        keys = { "n", "<leader>L" },
        cat = "lazyvim"
      },
      {
        desc = "New File",
        cmd = "<cmd>enew<cr>",
        keys = { "n", "<leader>fn" },
        cat = "file"
      },
      {
        desc = "Quit All",
        cmd = "<cmd>qa<cr>",
        keys = { "n", "<leader>qq" },
        cat = "file"
      },
      {
        desc = "Save File",
        cmd = "<cmd>w<cr>",
        keys = { "n", "<C-s>" },
        cat = "file"
      }
    })
  end,
}
