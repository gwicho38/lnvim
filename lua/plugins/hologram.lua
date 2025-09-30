return {
  "edluffy/hologram.nvim",
  enabled = false, -- Disabled due to buffer errors with dashboard
  ft = { "markdown", "rst" }, -- Lazy-load on markdown and rst files where images are common
  cmd = { "Hologram" },
  opts = {
    auto_display = true,
  },
}
