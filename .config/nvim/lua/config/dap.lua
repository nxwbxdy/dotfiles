vim.fn.sign_define('DapBreakpoint', { text = '', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointCondition', { text = '󰨰', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapLogPoint', { text = '󱂅', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '', texthl = '', linehl = '', numhl = '' })

require 'nvim-dap-virtual-text'.setup({})

local dap, dapui = require("dap"), require("dapui")
dapui.setup()
dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

vim.keymap.set('n', '<leader>dt', require 'dapui'.toggle)
vim.keymap.set('n', '<leader>dc', require 'dap'.continue)
vim.keymap.set('n', '<leader>dso', require 'dap'.step_over)
vim.keymap.set('n', '<leader>dsi', require 'dap'.step_into)
vim.keymap.set('n', '<leader>do', require 'dap'.step_out)
vim.keymap.set('n', '<leader>B', require 'dap'.toggle_breakpoint)
vim.keymap.set('n', '<leader>dbc', function() require 'dap'.set_breakpoint(vim.fn.input('BP condition: ')) end)
vim.keymap.set('n', '<leader>dbl', function() require 'dap'.set_breakpoint(nil, nil, vim.fn.input('Log msg: ')) end)
vim.keymap.set('n', '<leader>?', function() require('dapui').eval(nil, { enter = true }) end)
vim.keymap.set('n', '<leader>dru', function() require 'dapui'.open { reset = true } end)

vim.keymap.set('n', '<leader>dl', function()
  require "osv".launch({ port = 8086 })
end, { noremap = true })

vim.keymap.set('n', '<leader>dw', function()
  local widgets = require "dap.ui.widgets"
  widgets.hover()
end)

vim.keymap.set('n', '<leader>df', function()
  local widgets = require "dap.ui.widgets"
  widgets.centered_float(widgets.frames)
end)

dap.adapters.gdb = {
  type = "executable",
  command = "gdb",
  args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
}


dap.configurations.c = {
  {
    name = "Launch",
    type = "gdb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = "${workspaceFolder}",
    stopAtBeginningOfMainSubprogram = false,
  },
  {
    name = "Select and attach to process",
    type = "gdb",
    request = "attach",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    pid = function()
      local name = vim.fn.input('Executable name (filter): ')
      return require("dap.utils").pick_process({ filter = name })
    end,
    cwd = '${workspaceFolder}'
  },
  {
    name = 'Attach to gdbserver :1234',
    type = 'gdb',
    request = 'attach',
    target = 'localhost:1234',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}'
  },
}

dap.configurations.rust = {
  {
    name = "Launch default",
    type = "gdb",
    request = "launch",
    program = function()
      vim.fn.jobstart({ 'cargo', 'build' })
      local cargo_toml = vim.fn.getcwd() .. "/Cargo.toml"
      local binary_name = vim.fn.system("grep '^name' " .. cargo_toml .. " | awk -F '\"' '{print $2}'"):gsub("%s+", "")

      return vim.fn.getcwd() .. "/target/debug/" .. binary_name
    end,
    cwd = "${workspaceFolder}",
    stopAtBeginningOfMainSubprogram = false,
  },
  {
    name = "Launch input",
    type = "gdb",
    request = "launch",
    program = function()
      vim.fn.jobstart({ 'cargo', 'build' })

      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
    end,
    cwd = "${workspaceFolder}",
    stopAtBeginningOfMainSubprogram = false,
  },
}


dap.adapters.nlua = function(callback, conf)
  local adapter = {
    type = "server",
    host = conf.host or "127.0.0.1",
    port = conf.port or 8086,
  }
  if conf.start_neovim then
    local dap_run = dap.run
    dap.run = function(c)
      adapter.port = c.port
      adapter.host = c.host
    end
    require("osv").run_this()
    dap.run = dap_run
  end
  callback(adapter)
end
dap.configurations.lua = {
  {
    type = "nlua",
    request = "attach",
    name = "Run this file",
    start_neovim = {},
  },
  {
    type = "nlua",
    request = "attach",
    name = "Run that file",
    start_neovim = { '/home/l466l/.config/nvim/init.lua' },
  },
  {
    type = "nlua",
    request = "attach",
    name = "Attach to running Neovim instance (port = 8086)",
    port = 8086,
  },
  {
    type = "nlua",
    request = "attach",
    name = "Run config file",
    start_neovim = {},
  },
}
