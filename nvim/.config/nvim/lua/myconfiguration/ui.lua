-- Colorscheme
MyAddPlugin("catppuccin/nvim")
-- Notifications in a popup window
MyAddPlugin("rcarriga/nvim-notify")
-- Highlight/search TODO comments
MyAddPlugin("folke/todo-comments.nvim")
-- Highlight other uses of the word under the cursor
MyAddPlugin("RRethy/vim-illuminate")
-- Show indentation guides
MyAddPlugin("lukas-reineke/indent-blankline.nvim")
-- Visualize rgb color codes
MyAddPlugin("catgoose/nvim-colorizer.lua")
-- Show available keybindings in a popup
MyAddPlugin("folke/which-key.nvim")

local opt = vim.opt

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local map = vim.keymap.set

-- 24-bit RGB color in terminal
opt.termguicolors = true

-- Highlight current line number with 'CursorLineNr'
opt.cursorline = true
opt.cursorlineopt = "number"

-- Highlight current line number in focused window only
augroup("cursorline_set_group", { clear = true })
autocmd({ "BufEnter", "FocusGained", "WinEnter" }, {
  group = "cursorline_set_group",
  callback = function() vim.opt.cursorline = true end,
})
autocmd({ "BufLeave", "FocusLost", "WinLeave" }, {
  group = "cursorline_set_group",
  callback = function() vim.opt.cursorline = false end,
})

-- Show line numbers
opt.number = true

-- Show relative line numbers in focused window only
augroup("my_numbertoggle", { clear = true })
autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
  group = "my_numbertoggle",
  callback = function()
    if vim.wo.number and vim.fn.mode() ~= "i" then
      vim.opt.relativenumber = true
    end
  end,
})
autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
  group = "my_numbertoggle",
  callback = function()
    if vim.wo.number then
      vim.opt.relativenumber = false
    end
  end,
})

-- Display signs in the 'number' column
opt.signcolumn = "number"

-- How to display whitespace characters in 'list' mode
opt.listchars:append({ trail = "␣", eol = "↲", space = "·", tab = "├─┤" })

map("n", ".W", ":set colorcolumn=80", {desc="Toggle line width limit symbol"})

map("n", "<leader>+", [[:<c-u>exec 'resize +'.v:count1*5<CR>]], {desc="Increase window width"})
map("n", "<leader>_", [[:<c-u>exec 'resize -'.v:count1*5<CR>]], {desc="Decrease window width"})
map("n", "<leader>=", [[:<c-u>exec 'vertical resize +'.v:count1*20<CR>]], {desc="Increase window height"})
map("n", "<leader>-", [[:<c-u>exec 'vertical resize -'.v:count1*20<CR>]], {desc="Decrease window height"})

-- Make folds less ugly
vim.opt.fillchars = {
  fold = " ",
}
function _G.my_custom_fold_text()
  local line = vim.fn.getline(vim.v.foldstart)
  local lines = vim.v.foldend - vim.v.foldstart + 1
  return " " .. vim.trim(line) .. "  (" .. lines .. " lines)"
end
vim.opt.foldtext = "v:lua.my_custom_fold_text()"

map("n", "<leader>ih", function() vim.cmd("Inspect") end, { desc = "Show highlight groups under cursor" })
-- `:HighlightList` = show highlight groups info in new tab
vim.api.nvim_create_user_command("HighlightList", function()
  local output = vim.fn.execute("silent hi")

  vim.cmd("tab new")
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(output, "\n"))
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.bo[buf].filetype = "txt"
end, {})

local function toggle_left_column()
  if vim.wo.signcolumn ~= "no" then
    vim.wo.signcolumn = "no"
  else
    vim.wo.signcolumn = "number"
  end
  vim.wo.relativenumber = not vim.wo.relativenumber
  vim.wo.number = not vim.wo.number
end

map("n", ".l", toggle_left_column, { desc = "Toggle left column" })

local function toggle_bars()
  vim.o.showtabline = vim.o.showtabline ~= 0 and 0 or 2
  vim.o.cmdheight = vim.o.cmdheight ~= 0 and 0 or 1
end
map("n", ".b", toggle_bars, { desc = "Toggle bars" })

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Disable left column by default
    toggle_left_column()
    -- Disable bars by default
    toggle_bars()
  end,
})

local indent_inspect_state = {}
map("n", ".t", function()
  local buf = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()
  local key = buf .. ":" .. win

  if not indent_inspect_state[key] then
    indent_inspect_state[key] = {
      list = vim.wo.list,
      tabstop = vim.bo.tabstop,
      shiftwidth = vim.bo.shiftwidth,
      expandtab = vim.bo.expandtab,
    }

    vim.wo.list = true
    vim.bo.tabstop = 8
    vim.bo.shiftwidth = 8
    vim.bo.expandtab = false

    -- lukas-reineke/indent-blankline.nvim
    local ok = pcall(require, "ibl")
    if ok then
      vim.cmd("IBLDisable")
    end

  else
    local s = indent_inspect_state[key]

    vim.wo.list = s.list
    vim.bo.tabstop = s.tabstop
    vim.bo.shiftwidth = s.shiftwidth
    vim.bo.expandtab = s.expandtab

    -- lukas-reineke/indent-blankline.nvim
    local ok = pcall(require, "ibl")
    if ok then
      vim.cmd("IBLEnable")
    end

    indent_inspect_state[key] = nil
  end
end, { desc = "Toggle indentation inspect mode" })

-- Notify when macro recording starts
vim.api.nvim_create_autocmd("RecordingEnter", {
  callback = function()
    local reg = vim.fn.reg_recording()
    vim.notify("Recording macro @" .. reg, vim.log.levels.INFO)
  end,
})
-- Notify when macro recording stops
vim.api.nvim_create_autocmd("RecordingLeave", {
  callback = function()
    vim.notify("Stopped recording macro", vim.log.levels.INFO)
  end,
})

-- catppuccin/nvim
require("catppuccin").setup({
  flavour = "mocha",
  transparent_background = true,
  float = {
    transparent = true,
  },
})
vim.cmd.colorscheme("catppuccin")

-- rcarriga/nvim-notify
-- List notifications `:Notifications`
local notify = require("notify")
---@diagnostic disable-next-line: undefined-field
notify.setup({
  timeout = 2000,
  stages = "slide",
  render = "minimal",
  background_colour = "#000000",
})
-- Set as a default notify function
vim.notify = notify
map("n", "<leader>n", function()
  ---@diagnostic disable-next-line: undefined-field
  notify.dismiss({ pending = true, silent = true })
end, { desc = "Dismiss notification" })

-- folke/todo-comments.nvim
require("todo-comments").setup()
map("n", "<leader>qt", function()
  vim.cmd("TodoQuickFix")
end, { desc = "TODO comments quickfix window" })

-- RRethy/vim-illuminate
map("n", "<c-j>", function()
  require("illuminate").goto_next_reference()
end, { desc = "Jump to next reference", silent = true })
map("n", "<c-k>", function()
  require("illuminate").goto_prev_reference()
end, { desc = "Jump to previous reference", silent = true })

-- lukas-reineke/indent-blankline.nvim
require("ibl").setup({
  indent = { char = "▏" },
  exclude = {
    filetypes = { "markdown" },
  },
})

-- catgoose/nvim-colorizer.lua
require("colorizer").setup()
map("n", ".o", function()
  vim.cmd("ColorizerToggle")
end, { desc = "Toggle colorizer" })