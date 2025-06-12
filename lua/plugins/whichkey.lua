return {
  "folke/which-key.nvim",
  opts = {
    win = {
      position = "bottom",
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    wk.register({
      ["<leader>c"] = { name = "+copilot" },
    })
  end,
}
