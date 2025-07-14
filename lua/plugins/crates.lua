return {
  "saecki/crates.nvim",
  tag = "stable",
  config = function()
    require("crates").setup({
      smart_insert = true,
      show_versions = true,
      show_version_date = false,
      completion = {
        enabled = true,
        autofire = true,
      },
      popup = {
        autofocus = true,
        keys = {
          expand = "<CR>",
          copy_value = "<C-y>",
        }
      }
    })
  end,
}
