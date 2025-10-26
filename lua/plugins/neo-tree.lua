return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup()
    vim.keymap.set('n', '<leader>n', ':Neotree filesystem reveal left toggle<CR>', {})
    vim.keymap.set('n', '<leader>e', ':Neotree filesystem reveal left<CR>', {})
  end
}
