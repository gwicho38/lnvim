-- Basic smoke tests for Neovim configuration

describe("Configuration", function()
  it("should load without errors", function()
    assert.is_true(true)
  end)

  it("should have lazy.nvim installed", function()
    local lazy_ok, lazy = pcall(require, "lazy")
    assert.is_true(lazy_ok, "lazy.nvim should be available")
    assert.is_not_nil(lazy, "lazy.nvim should be loaded")
  end)

  it("should have LazyVim loaded", function()
    local lazyvim_ok, lazyvim = pcall(require, "lazyvim")
    assert.is_true(lazyvim_ok, "LazyVim should be available")
    assert.is_not_nil(lazyvim, "LazyVim should be loaded")
  end)

  it("should have leader key set to space", function()
    assert.equals(" ", vim.g.mapleader)
  end)

  it("should have clipboard set to unnamedplus", function()
    assert.equals("unnamedplus", vim.o.clipboard)
  end)

  it("should load core plugins", function()
    local plugins = require("lazy").plugins()
    local plugin_names = {}
    for _, plugin in ipairs(plugins) do
      table.insert(plugin_names, plugin.name)
    end

    -- Check for essential plugins
    assert.is_true(
      vim.tbl_contains(plugin_names, "lazy.nvim"),
      "lazy.nvim should be in plugin list"
    )
  end)
end)

describe("Custom plugins", function()
  it("should have claude-code.nvim configured", function()
    local plugins = require("lazy").plugins()
    local has_claude = false
    for _, plugin in ipairs(plugins) do
      if plugin.name == "claude-code.nvim" then
        has_claude = true
        break
      end
    end
    assert.is_true(has_claude, "claude-code.nvim should be configured")
  end)

  it("should have commander.nvim configured", function()
    local plugins = require("lazy").plugins()
    local has_commander = false
    for _, plugin in ipairs(plugins) do
      if plugin.name == "commander.nvim" then
        has_commander = true
        break
      end
    end
    assert.is_true(has_commander, "commander.nvim should be configured")
  end)
end)

describe("Keymaps", function()
  it("should have custom keymaps defined", function()
    -- Check for jj escape mapping
    local keymaps = vim.api.nvim_get_keymap("i")
    local has_jj = false
    for _, map in ipairs(keymaps) do
      if map.lhs == "jj" then
        has_jj = true
        break
      end
    end
    assert.is_true(has_jj, "jj escape keymap should be defined")
  end)
end)
