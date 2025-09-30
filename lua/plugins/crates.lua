return {
  "saecki/crates.nvim",
  tag = "stable",
  config = function()
    require("crates").setup({
      smart_insert = true,
      completion = {
        cmp = {
          enabled = true,
        },
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
