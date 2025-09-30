return {
  "tris203/hawtkeys.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  cmd = { "Hawtkeys", "HawtkeysAll", "HawtkeysDupes" },
  opts = {
    -- Detect duplicate keybindings and show warnings
    leader = " ", -- Space as leader
    homerow = 2, -- Distance from home row (affects scoring)
  },
}
