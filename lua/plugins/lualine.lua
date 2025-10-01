return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function(_, opts)
    -- Get current session name
    local function session_name()
      local session_dir = vim.fn.stdpath("data") .. "/sessions/"
      local cwd = vim.fn.getcwd()
      local session_file = session_dir .. cwd:gsub("/", "%%") .. ".vim"

      if vim.fn.filereadable(session_file) == 1 then
        -- Extract meaningful name from path
        local name = vim.fn.fnamemodify(cwd, ":t")
        return "📂 " .. name
      end
      return ""
    end

    -- Get git branch with icon
    local function git_branch()
      local branch = vim.fn.system("git branch --show-current 2>/dev/null | tr -d '\\n'")
      if branch ~= "" then
        return " " .. branch
      end
      return ""
    end

    -- LSP status
    local function lsp_status()
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      if #clients > 0 then
        local names = {}
        for _, client in ipairs(clients) do
          table.insert(names, client.name)
        end
        return "  " .. table.concat(names, ", ")
      end
      return ""
    end

    -- Macro recording indicator
    local function macro_recording()
      local reg = vim.fn.reg_recording()
      if reg ~= "" then
        return "Recording @" .. reg
      end
      return ""
    end

    -- File encoding and format
    local function file_info()
      local encoding = vim.opt.fileencoding:get()
      local format = vim.bo.fileformat
      if encoding ~= "utf-8" or format ~= "unix" then
        return encoding .. "[" .. format .. "]"
      end
      return ""
    end

    -- Configure lualine
    opts.options = {
      theme = "auto",
      globalstatus = true, -- Single statusline for all windows
      component_separators = { left = "|", right = "|" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = {
        statusline = { "dashboard", "alpha", "starter" },
      },
    }

    opts.sections = {
      lualine_a = {
        { "mode", fmt = function(str) return str:sub(1, 1) end }, -- Single letter mode
      },
      lualine_b = {
        { session_name, color = { fg = "#89b4fa", gui = "bold" } },
        { git_branch, color = { fg = "#a6e3a1" } },
      },
      lualine_c = {
        {
          "filename",
          path = 1, -- Relative path
          symbols = {
            modified = " ●",
            readonly = " ",
            unnamed = "[No Name]",
          },
        },
        { "diff", colored = true },
      },
      lualine_x = {
        { macro_recording, color = { fg = "#f38ba8", gui = "bold" } },
        {
          "diagnostics",
          sources = { "nvim_diagnostic" },
          symbols = { error = " ", warn = " ", info = " ", hint = " " },
        },
        { lsp_status, color = { fg = "#cba6f7" } },
        { file_info },
      },
      lualine_y = {
        { "filetype", icon_only = false },
        { "progress" },
      },
      lualine_z = {
        { "location" },
      },
    }

    opts.inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { "filename" },
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    }

    -- Update lualine when recording macro
    vim.api.nvim_create_autocmd("RecordingEnter", {
      callback = function()
        require("lualine").refresh()
      end,
    })
    vim.api.nvim_create_autocmd("RecordingLeave", {
      callback = function()
        vim.defer_fn(function()
          require("lualine").refresh()
        end, 50)
      end,
    })

    return opts
  end,
}
