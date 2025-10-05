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
    -- Wrap setup in pcall to handle backend detection failures
    local ok, err = pcall(function()
      require("image").setup(opts)
    end)

    if not ok then
      vim.notify(
        "image.nvim failed to load: " .. tostring(err) .. "\n\nImage previews disabled. This is likely due to:\n"
        .. "1. Tmux + Ghostty not fully supporting Kitty graphics protocol passthrough\n"
        .. "2. Try running outside tmux for image previews\n"
        .. "3. Or use a browser-based markdown preview instead",
        vim.log.levels.WARN
      )
    end

    -- Debug: check if backend is working
    vim.api.nvim_create_user_command("ImageDebug", function()
      if ok then
        local img = require("image")
        local backend = (img.backend and img.backend.name or "none")
        local tmux = os.getenv("TMUX") and "yes" or "no"
        vim.notify(
          string.format("Backend: %s\nTmux: %s\nTERM: %s", backend, tmux, os.getenv("TERM") or "unknown"),
          vim.log.levels.INFO
        )
      else
        vim.notify("image.nvim failed to initialize", vim.log.levels.ERROR)
      end
    end, {})
  end,
}
