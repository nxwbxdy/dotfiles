require("conform").setup({
  formatters = {
    shfmt = {
      inherit = false,
      command = "shfmt",
      args = { "-i", "2", "-filename", "$FILENAME" },
    }
  }
})
