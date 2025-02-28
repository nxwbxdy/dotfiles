vim.o.rnu = true
vim.o.nu = true
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣', multispace = '·' }
vim.o.splitright = true
vim.o.cmdheight = 1
vim.o.inccommand = 'split'

-- move help pages to the right
vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = "*.txt", -- Help files are .txt filetype
  callback = function()
    if vim.bo.filetype == "help" then
      vim.cmd.wincmd("L") -- Move window to far right
    end
  end,
})

-- move man pages to the right
vim.api.nvim_create_autocmd("FileType", {
  pattern = "man",
  callback = function()
    vim.cmd.wincmd("L") -- Move window to far right
  end,
})
