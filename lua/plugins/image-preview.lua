return {
  "3rd/image.nvim",
  event = "VeryLazy",
  opts = {
    backend = "kitty", -- Ghostty supports Kitty graphics protocol
    integrations = {
      markdown = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = true,
        only_render_image_at_cursor = false,
      },
    },
    max_width = 100,
    max_height = 12,
    max_width_window_percentage = nil,
    max_height_window_percentage = 50,
    window_overlap_clear_enabled = true,
    window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    tmux_show_only_in_active_window = true,
    hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" },
  },
  config = function(_, opts)
    require("image").setup(opts)

    -- Debug: check if backend is working
    vim.api.nvim_create_user_command("ImageDebug", function()
      local img = require("image")
      vim.notify("Image.nvim backend: " .. (img.backend and img.backend.name or "none"), vim.log.levels.INFO)
    end, {})
  end,
}
