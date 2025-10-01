return {
  -- Winbar with breadcrumbs and context
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    event = { "BufReadPost", "BufNewFile" }, -- Load immediately when opening files
    opts = {
      attach_navic = true, -- Attach navic to LSP automatically
      create_autocmd = true, -- Create autocmd to update winbar
      theme = "auto",
      include_buftypes = { "" },
      exclude_filetypes = { "netrw", "toggleterm", "neo-tree", "dashboard", "help", "alpha", "lazy" },
      show_dirname = true,
      show_basename = true,
      show_modified = true,
      modified = function(bufnr)
        return vim.bo[bufnr].modified
      end,
      symbols = {
        modified = " ●",
        ellipsis = "…",
        separator = "",
      },
      kinds = {
        File = " ",
        Module = " ",
        Namespace = " ",
        Package = " ",
        Class = " ",
        Method = " ",
        Property = " ",
        Field = " ",
        Constructor = " ",
        Enum = " ",
        Interface = " ",
        Function = " ",
        Variable = " ",
        Constant = " ",
        String = " ",
        Number = " ",
        Boolean = "◩ ",
        Array = " ",
        Object = " ",
        Key = " ",
        Null = "ﳠ ",
        EnumMember = " ",
        Struct = " ",
        Event = " ",
        Operator = " ",
        TypeParameter = " ",
      },
    },
  },

  -- Navic for LSP context
  {
    "SmiteshP/nvim-navic",
    lazy = true,
    init = function()
      vim.g.navic_silence = true

      -- Ensure winbar is enabled
      vim.schedule(function()
        -- Only set if not already set by user
        if vim.wo.winbar == "" then
          -- Let barbecue handle the winbar content
        end
      end)

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local buffer = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.server_capabilities.documentSymbolProvider then
            require("nvim-navic").attach(client, buffer)
          end
        end,
      })

      -- Add command to toggle winbar
      vim.api.nvim_create_user_command("WinbarToggle", function()
        local current = vim.opt.winbar:get()
        if current == "" then
          vim.notify("Winbar enabled", vim.log.levels.INFO)
          -- Trigger barbecue update
          vim.cmd("edit")
        else
          vim.opt.winbar = ""
          vim.notify("Winbar disabled", vim.log.levels.INFO)
        end
      end, { desc = "Toggle winbar" })
    end,
    opts = function()
      return {
        separator = " > ",
        highlight = true,
        depth_limit = 5,
        icons = {
          File = " ",
          Module = " ",
          Namespace = " ",
          Package = " ",
          Class = " ",
          Method = " ",
          Property = " ",
          Field = " ",
          Constructor = " ",
          Enum = " ",
          Interface = " ",
          Function = " ",
          Variable = " ",
          Constant = " ",
          String = " ",
          Number = " ",
          Boolean = "◩ ",
          Array = " ",
          Object = " ",
          Key = " ",
          Null = "ﳠ ",
          EnumMember = " ",
          Struct = " ",
          Event = " ",
          Operator = " ",
          TypeParameter = " ",
        },
      }
    end,
  },
}
