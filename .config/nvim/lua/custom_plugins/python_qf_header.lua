local function find_python_comments()
  local bufnr = vim.api.nvim_get_current_buf()
  local ft = vim.bo[bufnr].filetype  -- Updated syntax

  if ft ~= "python" then
    vim.notify("Not a Python buffer", vim.log.levels.WARN)
    return
  end

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local qf_list = {}

  for lnum, line in ipairs(lines) do
    if line:match("^##") then
      table.insert(qf_list, {
        bufnr = bufnr,
        lnum = lnum,
        col = 1,
        text = line:gsub("^##%s*", "")  -- Optional: Clean up the comment
      })
    end
  end

  if #qf_list > 0 then
    vim.fn.setqflist(qf_list)
    vim.cmd("copen")
  else
    vim.notify("No ## comments found", vim.log.levels.INFO)
  end
end

-- Key mapping (using <leader>cf as an example)
vim.keymap.set("n", "<leader>cf", find_python_comments, {
  desc = "Find Python ## comments in quickfix"
})
