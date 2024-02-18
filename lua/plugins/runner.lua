return {
  "MarcHamamji/runner.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  config = function()
    require("runner").setup()
  end,
}
