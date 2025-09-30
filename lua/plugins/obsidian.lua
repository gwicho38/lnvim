return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
    "nvim-telescope/telescope.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    workspaces = {
      {
        name = "lefv-vault",
        path = "~/repos/lefv-vault",
      },
    },

    -- Daily notes configuration
    daily_notes = {
      folder = "notes",
      date_format = "%Y%m%d",
      alias_format = "%B %-d, %Y",
      template = "template/Note.md",
    },

    -- Note ID generation (Zettelkasten timestamp format)
    note_id_func = function(title)
      -- Generate timestamp ID like Zettelkasten: YYYYMMDDHHMMSS
      return tostring(os.date("%Y%m%d%H%M%S"))
    end,

    -- Note path function (organize by domain)
    note_path_func = function(spec)
      -- Save notes to appropriate domain directory
      -- For now, default to notes/ directory
      local path = spec.dir / "notes"
      return path:tostring() .. "/" .. spec.id .. ".md"
    end,

    -- Frontmatter
    note_frontmatter_func = function(note)
      local out = {
        id = note.id,
        title = note.title,
        created = os.date("%Y-%m-%dT%H:%M:%S") .. "Z",
        modified = os.date("%Y-%m-%dT%H:%M:%S") .. "Z",
        tags = note.tags or {},
        domain = "notes", -- default domain
        status = "draft",
      }

      -- Add aliases if present
      if note.aliases ~= nil and #note.aliases > 0 then
        out.aliases = note.aliases
      end

      return out
    end,

    -- Templates
    templates = {
      folder = "template",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
      substitutions = {},
    },

    -- Completion settings
    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },

    -- Mappings (can be customized)
    mappings = {
      -- "Obsidian follow"
      ["gf"] = {
        action = function()
          return require("obsidian").util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      -- Toggle checkbox
      ["<leader>ch"] = {
        action = function()
          return require("obsidian").util.toggle_checkbox()
        end,
        opts = { buffer = true },
      },
      -- Smart action (depends on context)
      ["<cr>"] = {
        action = function()
          return require("obsidian").util.smart_action()
        end,
        opts = { buffer = true, expr = true },
      },
    },

    -- Customize how note IDs are displayed
    preferred_link_style = "wiki", -- use [[wiki-style]] links

    -- Disable wiki link syntax concealment
    disable_frontmatter = false,

    -- UI settings
    ui = {
      enable = true,
      update_debounce = 200,
      max_file_length = 5000,
      checkboxes = {
        [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
        ["x"] = { char = "", hl_group = "ObsidianDone" },
        [">"] = { char = "", hl_group = "ObsidianRightArrow" },
        ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
        ["!"] = { char = "", hl_group = "ObsidianImportant" },
      },
      bullets = { char = "•", hl_group = "ObsidianBullet" },
      external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
      reference_text = { hl_group = "ObsidianRefText" },
      highlight_text = { hl_group = "ObsidianHighlightText" },
      tags = { hl_group = "ObsidianTag" },
      block_ids = { hl_group = "ObsidianBlockID" },
      hl_groups = {
        ObsidianTodo = { bold = true, fg = "#f78c6c" },
        ObsidianDone = { bold = true, fg = "#89ddff" },
        ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
        ObsidianTilde = { bold = true, fg = "#ff5370" },
        ObsidianImportant = { bold = true, fg = "#d73128" },
        ObsidianBullet = { bold = true, fg = "#89ddff" },
        ObsidianRefText = { underline = true, fg = "#c792ea" },
        ObsidianExtLinkIcon = { fg = "#c792ea" },
        ObsidianTag = { italic = true, fg = "#89ddff" },
        ObsidianBlockID = { italic = true, fg = "#89ddff" },
        ObsidianHighlightText = { bg = "#75662e" },
      },
    },

    -- Image pasting configuration
    attachments = {
      img_folder = "assets/images",
      img_text_func = function(client, path)
        local link_path = client:vault_relative_path(path) or path
        return string.format("![%s](%s)", path.name, link_path)
      end,
    },

    -- Finder configuration
    finder = "telescope.nvim",
    finder_mappings = {
      new = "<C-x>",
    },

    -- Follow URL with system browser
    follow_url_func = function(url)
      vim.fn.jobstart({ "open", url })
    end,

    -- Customize picker (telescope)
    picker = {
      name = "telescope.nvim",
      mappings = {
        new = "<C-x>",
        insert_link = "<C-l>",
      },
    },

    -- Open notes in new split/vsplit
    open_notes_in = "current", -- or "vsplit", "hsplit"

    -- Automatically set up concealment
    conceallevel = 2,
  },

  -- Additional keymaps
  keys = {
    -- Obsidian commands
    { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New note" },
    { "<leader>oo", "<cmd>ObsidianSearch<cr>", desc = "Search notes" },
    { "<leader>oq", "<cmd>ObsidianQuickSwitch<cr>", desc = "Quick switch" },
    { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Show backlinks" },
    { "<leader>ot", "<cmd>ObsidianToday<cr>", desc = "Open today's note" },
    { "<leader>oy", "<cmd>ObsidianYesterday<cr>", desc = "Open yesterday's note" },
    { "<leader>od", "<cmd>ObsidianDailies<cr>", desc = "Open daily notes" },
    { "<leader>ol", "<cmd>ObsidianLinks<cr>", desc = "Show links" },
    { "<leader>og", "<cmd>ObsidianTags<cr>", desc = "Search tags" },
    { "<leader>of", "<cmd>ObsidianFollowLink<cr>", desc = "Follow link" },
    { "<leader>oi", "<cmd>ObsidianPasteImg<cr>", desc = "Paste image" },
    { "<leader>or", "<cmd>ObsidianRename<cr>", desc = "Rename note" },
    { "<leader>om", "<cmd>ObsidianTemplate<cr>", desc = "Insert template" },

    -- Link operations
    { "<leader>ol", ":ObsidianLink<cr>", desc = "Link selection", mode = "v" },
    { "<leader>oln", ":ObsidianLinkNew<cr>", desc = "Link to new note", mode = "v" },

    -- Extract selection to new note
    { "<leader>oe", ":ObsidianExtractNote<cr>", desc = "Extract to new note", mode = "v" },

    -- Open in Obsidian app (if needed)
    { "<leader>oO", "<cmd>ObsidianOpen<cr>", desc = "Open in Obsidian app" },
  },

  config = function(_, opts)
    require("obsidian").setup(opts)

    -- Set conceallevel for markdown files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function()
        vim.opt_local.conceallevel = 2
      end,
    })
  end,
}
