return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      filesystem = {
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
      },
    },
    keys = {
      { "<leader>n", function() vim.cmd("Neotree filesystem reveal left toggle") end, desc = "Neo-tree toggle" },
      { "<leader>e", function() vim.cmd("Neotree filesystem reveal left") end,       desc = "Neo-tree reveal" },
    },
    init = function()
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function(data)
          if vim.fn.isdirectory(data.file) == 1 then
            vim.cmd.enew()
            require("neo-tree.command").execute({
              source = "filesystem",
              position = "left",
              reveal = true,
            })
          end
        end,
      })
    end,
  },
}
