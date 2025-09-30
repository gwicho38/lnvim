return {
  "David-Kunz/gen.nvim",
  cmd = { "Gen" },
  keys = {
    { "<leader>ag", ":Gen<CR>", mode = { "n", "v" }, desc = "AI Generate" },
  },
  opts = {
    model = "llama2", -- Default model
    display_mode = "split", -- horizontal split for output
  },
}
