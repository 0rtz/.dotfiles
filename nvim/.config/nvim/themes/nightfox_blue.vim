set background=dark
lua <<EOF
require('nightfox').setup({
	options = {
		styles = {
			comments = "italic",
			keywords = "bold",
			types = "italic,bold",
		},
		modules = {
			hop = false,
		},
	},
	groups = {
		all = {
			TreesitterContext = { bg = "#3e3052" },
			QuickScopePrimary = { bg = "#d50000", style = "bold" },
			QuickScopeSecondary = { bg = "#dc00dc", style = "bold" },
			IblIndent = { fg = "#827390" },
			IblScope = { fg = "#BA69FF" },
			BufferLineTabSelected = { bg = "#43566F" },
			BufferLineTabSeparatorSelected = { fg = "#43566F", bg = "#43566F" },
			VertSplit = { fg = "#43566F" },
			Visual = { bg = "#43566F" },
			Whitespace = { fg = "#000000" },
		},
	}
})
EOF
colorscheme nightfox
