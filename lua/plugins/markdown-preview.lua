return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown" },
  build = function() vim.fn["mkdp#util#install"]() end,
  config = function()
    -- Use a new browser window for the preview
    vim.g.mkdp_browser = ''                             -- Leave empty to use the default browser
    vim.g.mkdp_auto_start = 1                           -- Automatically start the preview when editing a markdown file
    vim.g.mkdp_auto_close = 1                           -- Automatically close the preview when leaving a markdown buffer
    vim.g.mkdp_page_title = 'Markdown Preview: ${name}' -- Custom page title format
    vim.g.mkdp_browserfunc = ''                         -- Define your own function if you need special handling
  end,
}

