local function trailing_whitespace()
	return vim.fn.search([[\s\+$]], 'nw') ~= 0 and 'TW' or ''
end

require'lualine'.setup {
	options = {
		theme = 'auto',
		component_separators = { left = '', right = '' },
		section_separators = { left = '', right = '' },
		disabled_filetypes = { 'GV' },
		globalstatus = true,
	},
	sections = {
		lualine_a = {
			{
				'filename',
				separator = { right = ''},
			},
		},
		lualine_b = {
			{
				'branch',
				separator = { right = ''},
			},
			{
				'diff',
				colored = true,
				separator = { right = ''},
			},
		},
		lualine_c = {
			{
				'diagnostics',
				sources = {'nvim_diagnostic'},
			},
			{
				trailing_whitespace,
			},
			{
				-- current language
				'vim.opt.keymap._value',
				cond = function()
					if vim.opt.keymap._value ~= "" then
					   return true
					end
				end,
				color = { fg = "#000000", bg = "#d50000" },
			},
			{
				'grepper#statusline',
				color = { fg = "#000000", bg = "#d50000" },
			},
		},
		lualine_x = {
			{
				'filetype',
			},
		},
		lualine_y = {
			{
				"'%l:%c:%L'",
				separator = { left = '' },
			},
		},
		lualine_z = {
			{
				'filesize',
				separator = { left = '' },
			},
		},
	},
	extensions = {'nvim-tree', 'fugitive', 'symbols-outline', 'trouble'},
}
