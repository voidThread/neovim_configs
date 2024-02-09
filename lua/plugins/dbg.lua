return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
    },
    config = function()
      local dap = require("dap")

      -- Function to get the path to codelldb
      local function get_codelldb_path()
        local mason_registry = require("mason-registry")
        local codelldb_pkg = mason_registry.get_package("codelldb")
        if codelldb_pkg then
          local codelldb_path = codelldb_pkg:get_install_path() .. "/codelldb"
          return codelldb_path
        else
          print("codelldb is not installed. Please install it via Mason.")
          return ""
        end
      end

      dap.adapters.codelldb = {
        type = 'server',
        port = '${port}',
        executable = {
          command = get_codelldb_path(),
          args = { '--port', '${port}' },
        }
      }

      dap.configurations.cpp = {
        {
          name = "Launch file",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}/build',
          stopOnEntry = false,
          terminal = 'integrated',
          -- Arguments passed to the program (optional)
          args = {"random_data_1.json"},
        },
      }

      local dapui = require("dapui")

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

      vim.keymap.set('n', '<leader>dt', dap.toggle_breakpoint, {})
      vim.keymap.set('n', '<leader>dc', dap.continue, {})
      vim.keymap.set('n', '<F10>', require 'dap'.step_over)
      vim.keymap.set('n', '<F11>', require 'dap'.step_into)
      vim.keymap.set('n', '<F12>', require 'dap'.step_out)
    end,
  },
  {
    "leoluz/nvim-dap-go",
    config = function()
      require("dap-go").setup {
        dap_configurations = {
          {
            -- Must be "go" or it will be ignored by the plugin
            type = "go",
            name = "Attach remote",
            mode = "remote",
            request = "attach",
          },
        },
        -- delve configurations
        delve = {
          -- the path to the executable dlv which will be used for debugging.
          -- by default, this is the "dlv" executable on your PATH.
          path = "dlv",
          -- time to wait for delve to initialize the debug session.
          -- default to 20 seconds
          initialize_timeout_sec = 20,
          -- a string that defines the port to start delve debugger.
          -- default to string "${port}" which instructs nvim-dap
          -- to start the process in a random available port
          port = "${port}",
          -- additional args to pass to dlv
          args = {},
          -- the build flags that are passed to delve.
          -- defaults to empty string, but can be used to provide flags
          -- such as "-tags=unit" to make sure the test suite is
          -- compiled during debugging, for example.
          -- passing build flags using args is ineffective, as those are
          -- ignored by delve in dap mode.
          build_flags = "",
        }
      }
    end
  }
}
