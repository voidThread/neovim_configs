-- CodeCompanion.nvim (Lazy.nvim) + OpenAI Codex via Responses API
return {
  "olimorris/codecompanion.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("codecompanion").setup({
      adapters = {
        http = {
          openai_responses = function()
            return require("codecompanion.adapters").extend("openai_responses", {
              env = {
                -- Put your key in the environment:
                -- export OPENAI_API_KEY="sk-..."
                api_key = vim.env.OPENAI_API_KEY,
              },
              schema = {
                model = { default = "gpt-5-codex" },
              },
            })
          end,
        },
      },

      -- Use the adapter for both chat and inline
      interactions = {
        chat = { adapter = "openai_responses" },
        inline = { adapter = "openai_responses" },
      },
    })

    -- Keymaps (optional)
    vim.keymap.set("n", "<leader>cc", "<cmd>CodeCompanionChat<cr>", { desc = "CodeCompanion: Chat" })
    vim.keymap.set({ "n", "v" }, "<leader>ci", "<cmd>CodeCompanionInline<cr>", { desc = "CodeCompanion: Inline" })
  end,
}

