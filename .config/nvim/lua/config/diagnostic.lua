vim.diagnostic.config({
  virtual_lines =
  {
    current_line = false
  },
  virtual_text =
  {
    source = true,
    prefix = function(diagnostic)
      if diagnostic.severity == vim.diagnostic.severity.ERROR then
        return " " -- Nerd font icon for error
      elseif diagnostic.severity == vim.diagnostic.severity.WARN then
        return " " -- Nerd font icon for warning
      elseif diagnostic.severity == vim.diagnostic.severity.INFO then
        return " " -- Nerd font icon for info
      else
        return " " -- Nerd font icon for hint
      end
    end,
    format = function()
      return ""
    end,
    spacing = 2,
    -- severity =
    -- {
    --   min = vim.diagnostic.severity.ERROR
    -- }
    virt_text_pos = 'eol',
    virt_text_hide = true
  },
})

-- Toggle current line diagnostics
vim.keymap.set('n', 'gK', function()
  local vl = vim.diagnostic.config().virtual_lines or {}
  if type(vl) ~= 'table' then vl = {} end -- Force boolean true to table

  vim.diagnostic.config({
    virtual_lines = vim.tbl_extend('force', vl, {
      current_line = not (vl.current_line or false)
    })
  })
end, { desc = 'Toggle current line diagnostics' })

-- Toggle all virtual lines
vim.keymap.set('n', 'gL', function()
  vim.diagnostic.config({
    virtual_lines = not vim.diagnostic.config().virtual_lines
  })
end, { desc = 'Toggle all diagnostics' })
