return
{
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup {
      flavour = "mocha",
      color_overrides = {
        mocha = {
          base = "#000000",
        }
      },
      highlight_overrides = {
        mocha = function(mocha)
          return {
            WinSeparator = { fg = mocha.mantle},
          }
        end
      },
      integrations = {
        cmp = true,
        dap = true,
        treesitter = true,
        alpha = true,
        mason = false,
        neotree = false,
      }
    }
    vim.cmd.colorscheme "catppuccin-mocha"
  end
}
