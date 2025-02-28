require("telescope").setup {
  defaults = {
    layout_config = {
      prompt_position = "top",
      width = { padding = 0 },
      height = { padding = 0 },
      preview_width = 0.5,
    },
    path_display = function(_, path)
      local tail = require('telescope.utils').path_tail(path)
      return string.format("%s ~ %s", tail, path)
    end,
    sorting_strategy = "ascending",
    border = false,
    selection_caret = ' ',
    winblend = 10,
    mappings = {
      i = {
        ["<C-u>"] = false
      },
    },
  }
}

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
