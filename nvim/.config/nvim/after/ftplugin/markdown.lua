local map = vim.keymap.set

map('n', 'K', '<nop>', { buffer = true })

-- Decrease/increase one leading '#' (if present) in visual selection
map('x', '-', ':s/^\\(#\\)\\{1,6}\\zs#//<CR>gv', { buffer = true })
map('x', '+', ':s/^\\(#\\{1,5}\\)/#\\1/<CR>gv', { buffer = true })

-- nvim-mini/mini.surround buffer-local custom surroundings
-- ysiwb = bold, ysibi = italic, ysiwl = link
vim.b.minisurround_config = {
  custom_surroundings = {
    b = {
      input = { "%*%*().-()%*%*" },
      output = { left = "**", right = "**" },
    },
    i = {
      input = { "%*().-()%*" },
      output = { left = "*", right = "*" },
    },
  },
}

map('n', '<leader>Fp', function ()
    -- iamcco/markdown-preview.nvim
    vim.cmd("MarkdownPreviewToggle")
end, { buffer=true, desc="Preview markdown file" })

-- dhruvasagar/vim-table-mode
-- Enter '|' to create new row or align existing table
map('n', '<leader>Fa', ':TableModeRealign<CR>', { buffer = true, desc="Align table" })
map('n', '<leader>Ft', ':TableModeToggle<CR>', { buffer = true, desc="Toggle table mode" })