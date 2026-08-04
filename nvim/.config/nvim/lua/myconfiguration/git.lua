-- Git interface
MyAddPlugin("NeogitOrg/neogit")
-- Preview git hunks
MyAddPlugin("lewis6991/gitsigns.nvim")
-- Show git commits history under cursor
MyAddPlugin("rhysd/git-messenger.vim")
-- codediff.nvim dependency
MyAddPlugin("MunifTanjim/nui.nvim")
-- UI for git diff
MyAddPlugin("esmuellert/codediff.nvim")

local map = vim.keymap.set

map("n", "<leader>ga", function()
  vim.cmd("silent !git add %")
end, {desc="Stage current file"})

-- NeogitOrg/neogit
local neogit = require('neogit')
map("n", "<leader>gs", function()
  neogit.open()
end, {desc="Show git status"})
map("n", "<leader>gl", function()
  neogit.open({ "log" })
end, {desc="Show git log"})

-- lewis6991/gitsigns.nvim
local gitsigns = require("gitsigns")
map("n", "<leader>qd", function()
  gitsigns.setqflist("all")
end, {desc="Git diff hunks quickfix window"})
require("gitsigns").setup({
  on_attach = function(bufnr)

    local function buf_map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Hunks
    buf_map("n", "]h", function() gitsigns.nav_hunk("next") end, {desc="Goto next git hunk"})
    buf_map("n", "[h", function() gitsigns.nav_hunk("prev") end, {desc="Goto previous git hunk"})
    buf_map("v", "<leader>g", function() gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, {desc="Stage git hunk"})
    buf_map("v", "<leader>G", function() gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, {desc="Reset git hunk"})
    buf_map("n", "<leader>gp", gitsigns.preview_hunk, {desc="Preview git hunk"})
  end,
})

-- rhysd/git-messenger.vim
vim.g.git_messenger_no_default_mappings = true
map("n", "<leader>gL", function()
  vim.cmd("GitMessenger")
end, {desc="Show git commit history under cursor"})

-- esmuellert/codediff.nvim
require("codediff").setup({
  keymaps = {
    view = {
      -- Toggle the file panel
      toggle_explorer = ".n",
      -- Stage/unstage the selected entry
      toggle_stage = "a",
    },
  },
})
map("n", "<leader>gd", function()
  vim.cmd("CodeDiff")
end, {desc="Show git diff"})