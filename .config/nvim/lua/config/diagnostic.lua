vim.diagnostic.config({
  virtual_text =
  {
    source = true,
    prefix = '●',
    spacing = 4,
    severity =
    {
      min = vim.diagnostic.severity.ERROR
    }
  },
  signs = true
})
