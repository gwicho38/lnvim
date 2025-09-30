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
          hide = { "q", "<esc>" },
          open_url = { "<cr>" },
          select = { "<cr>" },
          select_alt = { "s" },
          toggle_feature = { "<cr>" },
          copy_value = { "yy" },
          goto_item = { "gd", "K" },
          jump_forward = { "<c-i>" },
          jump_back = { "<c-o>", "<c-p>" },
        },
      },
    })
  end,
}
