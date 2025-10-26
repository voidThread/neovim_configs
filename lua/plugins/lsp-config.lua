return {
  -- Mason: package manager for LSP/DAP/linters
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  -- Bridge between Mason and nvim-lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "rust_analyzer",
          "clangd",
          "bashls",
          "gopls",
          "jsonls",
          "neocmake",
          "htmx",
          "stylelint_lsp",
          "ts_ls",
          "marksman",
        },
      })
    end,
  },

  -- Core LSP configs
  {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Default handler: apply to every server Mason installs
      require("mason-lspconfig").setup_handlers({
        function(server)
          lspconfig[server].setup({ capabilities = capabilities })
        end,

        -- Per-server tweaks
        ["clangd"] = function()
          lspconfig.clangd.setup({
            cmd = {
              "clangd",
              "--background-index",
              "--clang-tidy",
              "--completion-style=detailed",
              "--header-insertion=iwyu",
              "--header-insertion-decorators",
              "--fallback-style=llvm",
              "--query-driver=/usr/bin/gcc,/usr/bin/g++",
            },
            capabilities = capabilities,
            filetypes = { "c", "cpp", "objc", "objcpp" },
          })
        end,

        ["stylelint_lsp"] = function()
          lspconfig.stylelint_lsp.setup({
            filetypes = { "scss", "css" },
            capabilities = capabilities,
            on_attach = function(client)
              -- disable formatting if you use another formatter
              client.server_capabilities.documentFormattingProvider = false
            end,
          })
        end,
      })

      -- Extra servers that might not be managed by Mason (kept for completeness);
      -- harmless if Mason already installed them.
      -- lspconfig.marksman.setup({ capabilities = capabilities })

      -- Keymaps after LSP attaches
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
          local opts = { buffer = ev.buf }

          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
          vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
          vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
          vim.keymap.set("n", "<space>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts)
          vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
          vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "<space>f", function()
            vim.lsp.buf.format({ async = true })
          end, opts)
        end,
      })
    end,
  },
}
