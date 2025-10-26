return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "williamboman/mason.nvim",
      "jay-babu/mason-nvim-dap.nvim", -- adapter manager
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      -- Core mason (safe even if called elsewhere)
      pcall(function() require("mason").setup() end)

      -- mason-nvim-dap: be compatible with both old & new APIs
      local mnd_ok, mnd = pcall(require, "mason-nvim-dap")
      if mnd_ok then
        mnd.setup({
          ensure_installed = { "codelldb", "delve" },
          automatic_installation = true,
          -- Some versions use this:
          automatic_setup = true,
        })
        if type(mnd.setup_handlers) == "function" then
          mnd.setup_handlers() -- Newer versions
        end
      else
        -- Fallback: manual adapter wire-up if mason-nvim-dap missing
        local dap = require("dap")
        local data = vim.fn.stdpath("data")
        local function pick_exec(name)
          if vim.fn.executable(name) == 1 then return name end
          local p = data .. "/mason/bin/" .. name
          if vim.fn.executable(p) == 1 then return p end
          return nil
        end
        local codelldb = pick_exec("codelldb")
        if codelldb then
          dap.adapters.codelldb = {
            type = "server",
            port = "${port}",
            executable = { command = codelldb, args = { "--port", "${port}" } },
          }
        end
      end

      require("nvim-dap-virtual-text").setup()

      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

      -- C / C++ / Rust configs (use codelldb adapter provided by mason-nvim-dap or fallback above)
      dap.configurations.cpp = {
        {
          name = "Launch file",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = function()
            local s = vim.fn.input("Arguments: ")
            return (s == "" and {}) or vim.split(s, " ")
          end,
        },
      }
      dap.configurations.c = dap.configurations.cpp
      dap.configurations.rust = dap.configurations.cpp

      -- Keymaps
      vim.keymap.set("n", "<leader>dt", dap.toggle_breakpoint, {})
      vim.keymap.set("n", "<leader>dc", dap.continue, {})
      vim.keymap.set("n", "<F10>", dap.step_over, {})
      vim.keymap.set("n", "<F11>", dap.step_into, {})
      vim.keymap.set("n", "<F12>", dap.step_out, {})
    end,
  },

  -- Go debugging (uses "delve", which mason-nvim-dap installs)
  {
    "leoluz/nvim-dap-go",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("dap-go").setup({
        dap_configurations = {
          {
            type = "go",
            name = "Attach remote",
            mode = "remote",
            request = "attach",
          },
        },
        delve = {
          path = "dlv",
          initialize_timeout_sec = 20,
          port = "${port}",
          args = {},
          build_flags = "",
        },
      })
    end,
  },
}
