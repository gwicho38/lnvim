return {
  -- Enhanced hover documentation
  {
    "lewis6991/hover.nvim",
    event = "VeryLazy",
    opts = {
      init = function()
        -- Require providers
        require("hover.providers.lsp")
        require("hover.providers.gh")
        require("hover.providers.gh_user")
        require("hover.providers.man")
        require("hover.providers.dictionary")
      end,
      preview_opts = {
        border = "rounded",
      },
      preview_window = false,
      title = true,
      mouse_providers = {
        "LSP",
      },
      mouse_delay = 1000,
    },
    keys = {
      {
        "K",
        function()
          require("hover").hover()
        end,
        desc = "Hover Documentation",
      },
      {
        "gK",
        function()
          require("hover").hover_select()
        end,
        desc = "Hover Select",
      },
      {
        "<MouseMove>",
        function()
          require("hover").hover_mouse()
        end,
        desc = "Hover Mouse",
      },
    },
  },

  -- Auto-hover on cursor hold (optional)
  {
    "neovim/nvim-lspconfig",
    opts = function()
      -- Show hover automatically after 500ms of cursor hold
      vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
          local opts = {
            focusable = false,
            close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
            border = "rounded",
            source = "always",
            prefix = " ",
            scope = "cursor",
          }
          vim.diagnostic.open_float(nil, opts)
        end,
      })
    end,
  },
}
