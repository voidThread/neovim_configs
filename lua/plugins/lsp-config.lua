return {
  -- 1) Mason: installs LSP binaries
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  -- 2) Mason <-> LSP bridge: ensures servers are installed
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

  -- 3) Core LSP (no more lspconfig.setup; use vim.lsp.config/enable)
  {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Defaults for ALL servers
      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      -- Per-server configs (only where you need tweaks)

      -- clangd
      vim.lsp.config("clangd", {
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
        filetypes = { "c", "cpp", "objc", "objcpp" },
        root_markers = { ".clangd", "compile_commands.json", ".git" },
      })

      -- stylelint_lsp
      vim.lsp.config("stylelint_lsp", {
        filetypes = { "scss", "css" },
        on_attach = function(client)
          -- disable formatting if another tool handles it
          client.server_capabilities.documentFormattingProvider = false
        end,
      })

      -- Enable everything (will auto-start per filetype/root)
      vim.lsp.enable({
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
      })

      -- Your LSP keymaps (still fine with the new API)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
          local o = { buffer = ev.buf }
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, o)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, o)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, o)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, o)
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, o)
          vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, o)
          vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, o)
          vim.keymap.set("n", "<space>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, o)
          vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, o)
          vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, o)
          vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, o)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, o)
          vim.keymap.set("n", "<space>f", function()
            vim.lsp.buf.format({ async = true })
          end, o)
        end,
      })
    end,
  },
}
