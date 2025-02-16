return {
  {
    "mbbill/undotree",
    lazy = false,
    config = function()
      vim.g.undotree_WindowLayout = 4
    end,
    keys = { { "<leader>u", vim.cmd.UndotreeToggle, desc = "Toggle UndoTree" } }
  }
}
