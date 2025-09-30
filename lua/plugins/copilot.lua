return {
  "github/copilot.vim",
  event = "InsertEnter",
  keys = {
    { "<leader>ce", "<cmd>Copilot enable<cr>", desc = "Copilot Enable" },
    { "<leader>cD", "<cmd>Copilot disable<cr>", desc = "Copilot Disable" },
    { "<leader>co", "<cmd>Copilot panel<cr>", desc = "Copilot Panel" },
    { "<leader>cs", "<cmd>Copilot status<cr>", desc = "Copilot Status" },
  },
  config = function()
    -- Copilot config
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true
    vim.g.copilot_tab_fallback = ""

    -- Accept suggestion with <C-J> instead of <Tab>
    vim.keymap.set("i", "<C-J>", 'copilot#Accept("\\<CR>")', {
      expr = true,
      replace_keycodes = false,
      desc = "Accept Copilot suggestion",
    })

    -- Navigate suggestions
    vim.keymap.set("i", "<C-]>", "<Plug>(copilot-next)", { desc = "Next Copilot suggestion" })
    vim.keymap.set("i", "<C-[>", "<Plug>(copilot-previous)", { desc = "Previous Copilot suggestion" })
  end,
}
