-- Language servers (lspconfig/mason/null-ls)/Highlights & Motions (treesitter)

-- Neovim logs :h lspconfig-logging
-- vim.lsp.set_log_level 'trace'

-- Currently configured languages:
	-- bash
	-- C/C++
	-- yaml
	-- json
	-- vim
	-- Dockerfile
	-- awk
	-- ansible
	-- xml
	-- .rst
	-- lua-nvim
	-- markdown
	-- .spec (rpm build files)
	-- zsh
	-- Makefile
	-- cmake
	-- gitcommit
	-- text

-- Language servers configs used by the neovim LSP client
local lsp_conf = require("lspconfig")
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- completions
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
-- buffer-scope LSP settings
local on_attach = function(client, bufnr)
	local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
	local opts = { noremap=true, silent=true }

	buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	buf_set_keymap('n', 'gf', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
	buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
	buf_set_keymap('n', 'gR', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
	buf_set_keymap('n', 'gr', '<cmd>Telescope lsp_references<CR>', opts)

	-- open in split
	buf_set_keymap('n', 'gF', '<Cmd>vsplit<CR><Cmd>lua vim.lsp.buf.definition()<CR>', opts)

	-- info about LSP symbol under cursor
	buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)

	-- info about function parameters under cursor
	buf_set_keymap('n', 'gls', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	buf_set_keymap("n", "glf", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", opts)
	buf_set_keymap("v", "glf", "<cmd>lua My_range_formatting()<CR>", opts)

	buf_set_keymap('n', '<leader>ie', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
	buf_set_keymap('n', '[e', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
	buf_set_keymap('n', ']e', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
	buf_set_keymap('n', '<space>qe', '<cmd>lua vim.diagnostic.setqflist()<CR>', opts)
	buf_set_keymap('n', '\\d', '<cmd>lua My_toggle_diagnostics_buffer()<CR>', opts)
	buf_set_keymap('n', '\\D', '<cmd>lua My_toggle_diagnostics()<CR>', opts)
end

-- Language server diagnostic icons in signcolumn
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
-- Language server diagnostics virtual text
vim.diagnostic.config({
	virtual_text = {
		source = "if_many",
		prefix = '',
		severity = {
		  min = vim.diagnostic.severity.INFO,
		},
		severity_sort = true,
	},
})

-- Language Servers package manager
require("mason").setup()
require("mason-lspconfig").setup {
	automatic_installation = { exclude = { "clangd" } }
}

-- Language Server within neovim that uses various linters as backend
local null_ls = require("null-ls")
-- buffer-scope null-ls settings
local on_attach_null_ls = function(_, bufnr)
	local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
	local opts = { noremap=true, silent=true }

	buf_set_keymap("n", "glf", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", opts)
    buf_set_keymap("v", "glf", "<cmd>lua My_range_formatting()<CR>", opts)
	buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)

	buf_set_keymap('n', '<leader>ie', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
	buf_set_keymap('n', '[e', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
	buf_set_keymap('n', ']e', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
	buf_set_keymap('n', '\\d', '<cmd>lua My_toggle_diagnostics_buffer()<CR>', opts)
	buf_set_keymap('n', '\\D', '<cmd>lua My_toggle_diagnostics()<CR>', opts)
end
-- which linters to use
local null_ls_sources = {}

-- which languages treesitter support
local treesitter_sources = {}

-- Configured languages: ---------------------------------------------------------------------------

-- bash
-- Neoformat: shfmt
table.insert(null_ls_sources, null_ls.builtins.formatting.shellharden)
table.insert(null_ls_sources, null_ls.builtins.code_actions.shellcheck)
table.insert(treesitter_sources, "bash")
-- includes shellcheck linter support
lsp_conf.bashls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

-- C/C++
table.insert(null_ls_sources, null_ls.builtins.diagnostics.cppcheck)
table.insert(treesitter_sources, "c")
table.insert(treesitter_sources, "cpp")
if vim.fn.executable("clangd") then
	local clangd_capabilities = {
		textDocument = {
			completion = {
				editsNearCursor = true,
			},
		},
		offsetEncoding = { 'utf-16' },
	}
	-- Clangd's off-spec features
	require("clangd_extensions").setup {
		server = {
			on_attach = on_attach,
			capabilities = vim.tbl_deep_extend('keep', capabilities, clangd_capabilities),
			cmd = {'clangd', '--header-insertion=never'},
		},
		extensions = {
			autoSetHints = false,
		}
	}
end

-- yaml
-- Neoformat: prettier
table.insert(null_ls_sources, null_ls.builtins.diagnostics.yamllint)
table.insert(treesitter_sources, "yaml")
lsp_conf.yamlls.setup({
	on_attach = on_attach,
	capabilities = capabilities
})

-- json
-- Neoformat: prettier
table.insert(treesitter_sources, "json")
table.insert(treesitter_sources, "json5")
table.insert(treesitter_sources, "jsonc")
lsp_conf.jsonls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	json = {
		-- validate some popular JSON document types
		schemas = require('schemastore').json.schemas(),
		validate = { enable = true },
	},
})

-- vim
table.insert(null_ls_sources, null_ls.builtins.diagnostics.vint)
table.insert(treesitter_sources, "vim")
lsp_conf.vimls.setup({
	on_attach = on_attach,
	capabilities = capabilities
})

-- Dockerfile
table.insert(null_ls_sources, null_ls.builtins.diagnostics.hadolint)
table.insert(treesitter_sources, "dockerfile")
lsp_conf.dockerls.setup({
	on_attach = on_attach,
	capabilities = capabilities
})

-- awk
lsp_conf.awk_ls.setup({
	on_attach = on_attach,
	capabilities = capabilities
})

-- ansible
-- includes ansiblelint support
lsp_conf.ansiblels.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

-- xml
-- Neoformat: prettier
table.insert(null_ls_sources, null_ls.builtins.formatting.xmllint)
lsp_conf.lemminx.setup({
	on_attach = on_attach,
	capabilities = capabilities
})

-- .rst
table.insert(treesitter_sources, "rst")
lsp_conf.esbonio.setup({
	on_attach = on_attach,
	capabilities = capabilities
})

-- lua-nvim
table.insert(treesitter_sources, "lua")
lsp_conf.lua_ls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		Lua = {
			diagnostics = {
				globals = {'vim'},
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			telemetry = {
				enable = false,
			},
		}
	}
})

-- markdown
-- Neoformat: prettier
table.insert(null_ls_sources, null_ls.builtins.diagnostics.markdownlint)
table.insert(treesitter_sources, "markdown")

-- .spec (rpm build files)
table.insert(null_ls_sources, null_ls.builtins.diagnostics.rpmspec)

-- zsh
table.insert(null_ls_sources, null_ls.builtins.diagnostics.zsh)

-- Makefile
table.insert(treesitter_sources, "make")

-- cmake
table.insert(treesitter_sources, "cmake")
-- includes cmake_format support
lsp_conf.cmake.setup({
	on_attach = on_attach,
	capabilities = capabilities
})

-- gitcommit
table.insert(null_ls_sources, null_ls.builtins.diagnostics.gitlint)
table.insert(treesitter_sources, "gitcommit")

---------------------------------------------------------------------------

-- null-ls sources to apply to all files
table.insert(null_ls_sources, null_ls.builtins.diagnostics.codespell)
table.insert(null_ls_sources, null_ls.builtins.formatting.codespell)
table.insert(null_ls_sources, null_ls.builtins.diagnostics.editorconfig_checker.with({
		command = "editorconfig-checker",
		args = {
			"-no-color",
			"-disable-indent-size",
			"$FILENAME",
		},
	})
)
-- remove duplicate elements from null_ls_sources
local seen_null_ls_sources = {}
for index,item in ipairs(null_ls_sources) do
	if seen_null_ls_sources[item] then
		table.remove(null_ls_sources, index)
	else
		seen_null_ls_sources[item] = true
	end
end
-- apply null-ls configurations
null_ls.setup({
	sources = null_ls_sources,
	on_attach = on_attach_null_ls,
	on_init = function(new_client, _)
		new_client.offset_encoding = 'utf-16'
	end,
	-- :NullLsLog
	-- debug = true,
	-- log = {
	-- 	enable = true,
	-- 	level = "trace",
	-- 	use_console = "sync",
	-- },
})

-- treesitter specific sources
table.insert(treesitter_sources, "comment")
table.insert(treesitter_sources, "regex")
table.insert(treesitter_sources, "query")
table.insert(treesitter_sources, "diff")
-- remove duplicate elements from treesitter_sources
local seen_treesitter_sources = {}
for index,item in ipairs(treesitter_sources) do
	if seen_treesitter_sources[item] then
		table.remove(treesitter_sources, index)
	else
		seen_treesitter_sources[item] = true
	end
end
-- apply treesitter configurations
---@diagnostic disable-next-line: missing-fields
require'nvim-treesitter.configs'.setup {
	ensure_installed = treesitter_sources,
	sync_install = false,

	-- auto install parsers on buffer enter, needs tree-sitter cli
	auto_install = true,
	ignore_install = {},

	------------------------------
	-- treesitter built-in modules
	-- syntax highlighting for supppored treesitter_sources
	highlight = {
		enable = true,
		-- Follow anchors in preservim/vim-markdown
		additional_vim_regex_highlighting = {
			"markdown",
		},
	},
	-- '=' operator changes spaces to tabs where applicable
	indent = {
		enable = true
	},
	------------------------------

	------------------------------
	-- treesitter external modules
	-- JoosepAlviste/nvim-ts-context-commentstring
	-- semantic nested commenting
	context_commentstring = {
		enable = true
	},

	-- andymass/vim-matchup
	-- better integration for %
	matchup = {
		enable = true,
	},

	-- nvim-treesitter-textobjects
	-- motions for LSP symbols
	textobjects = {
		-- operator-pending mode
		select = {
			enable = true,
			keymaps = {
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["il"] = "@loop.inner",
				["al"] = "@loop.outer",
				["ii"] = "@conditional.inner",
				["ai"] = "@conditional.outer",
				["ak"] = "@comment.outer",
				["ik"] = "@comment.inner",
				["ab"] = "@block.outer",
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]C"] = "@class.outer",
				["]F"] = "@function.outer",
				["]L"] = "@loop.outer",
				["]I"] = "@conditional.outer",
			},
			goto_next_end = {
				["]c"] = "@class.outer",
				["]f"] = "@function.outer",
				["]l"] = "@loop.outer",
				["]i"] = "@conditional.outer",
			},
			goto_previous_start = {
				["[c"] = "@class.outer",
				["[f"] = "@function.outer",
				["[l"] = "@loop.outer",
				["[i"] = "@conditional.outer",
			},
			goto_previous_end = {
				["[C"] = "@class.outer",
				["[F"] = "@function.outer",
				["[L"] = "@loop.outer",
				["[I"] = "@conditional.outer",
			},
		},
	},
	------------------------------
}
