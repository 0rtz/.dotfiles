-- LOGS: $HOME/.cache/nvim/dap.log
-- require('dap').set_log_level('TRACE')
local dap = require('dap')

local sign = vim.fn.sign_define
sign("DapBreakpoint", { text = "●"})
sign("DapBreakpointCondition", { text = "●"})
sign("DapLogPoint", { text = "◆"})

-- variable values as virtual text
require("nvim-dap-virtual-text").setup({})
local api = vim.api
local mappings = {
	["r"] = {
		mapped = false,
		keymap_preserve = {}
	},
	["n"] = {
		mapped = false,
		keymap_preserve = {}
	},
	["i"] = {
		mapped = false,
		keymap_preserve = {}
	},
	["c"] = {
		mapped = false,
		keymap_preserve = {}
	},
	["o"] = {
		mapped = false,
		keymap_preserve = {}
	},
	["p"] = {
		mapped = false,
		keymap_preserve = {}
	},
	["u"] = {
		mapped = false,
		keymap_preserve = {}
	},
	["t"] = {
		mapped = false,
		keymap_preserve = {}
	},
	["v"] = {
		mapped = false,
		keymap_preserve = {}
	},
	["f"] = {
		mapped = false,
		keymap_preserve = {}
	},
	["R"] = {
		mapped = false,
		keymap_preserve = {}
	},
}
-- initialize nvim-dap local mappings
dap.listeners.after['event_initialized']['me'] = function()
	local keymaps = api.nvim_get_keymap('n')
	for _, keymap in pairs(keymaps) do
		if mappings[keymap.lhs] then
			mappings[keymap.lhs].mapped = true
			for k,v in pairs(keymap) do
				mappings[keymap.lhs].keymap_preserve[k]=v
			end
			api.nvim_del_keymap('n', keymap.lhs)
		end
	end
	api.nvim_set_keymap(
	'n', 'r', '<Cmd>lua require("dap").toggle_breakpoint()<CR>', { silent = true })
	api.nvim_set_keymap(
	'n', 'n', '<Cmd>lua require("dap").step_over()<CR>', { silent = true })
	api.nvim_set_keymap(
	'n', 'i', '<Cmd>lua require("dap").step_into()<CR>', { silent = true })
	api.nvim_set_keymap(
	'n', 'c', '<Cmd>lua require("dap").continue()<CR>', { silent = true })
	api.nvim_set_keymap(
	'n', 'o', '<Cmd>lua require("dap").step_out()<CR>', { silent = true })
	api.nvim_set_keymap(
	'n', 'p', '<Cmd>lua require("dap.ui.widgets").hover()<CR>', { silent = true })
	api.nvim_set_keymap(
	'n', 'u', '<Cmd>lua require("dap").run_to_cursor()<CR>', { silent = true })
	api.nvim_set_keymap(
	'n', 't', '<Cmd>lua require("dap").repl.toggle()<CR>', { silent = true })
	api.nvim_set_keymap(
	-- show variables
	'n', 'v', '<Cmd>lua require("dap.ui.widgets").centered_float(require("dap.ui.widgets").scopes)<CR>', { silent = true })
	-- show call stack
	api.nvim_set_keymap(
	'n', 'f', '<Cmd>lua require("dap.ui.widgets").centered_float(require("dap.ui.widgets").frames).open()<CR>', { silent = true })
	api.nvim_set_keymap(
	'n', 'R', '<Cmd>lua require("dap").clear_breakpoints()<CR>', { silent = true })
end
-- restore user mappings
dap.listeners.after['event_terminated']['me'] = function()
	for keymap_key, keymap_val in pairs(mappings) do
		if keymap_val.mapped then
			api.nvim_set_keymap('n', keymap_val.keymap_preserve.lhs, keymap_val.keymap_preserve.rhs, { silent = keymap_val.keymap_preserve.silent == 1 })
		else
			-- no custom user mapping defined for key
			api.nvim_set_keymap('n', keymap_key, keymap_key, { })
		end
	end
end

-- Neovim lua modules debug
--
-- Debuggee: Launch the server the using ':lua require'osv'.launch({port = 8086})'
-- Debugger: Open source code of module to debug
-- Debugger: Place breakpoint
-- Debugger: Connect using the DAP client with the command ':lua require'dap'.continue()'
-- Debuggee: Run plugin
dap.configurations.lua = {
	{
		type = 'nlua',
		request = 'attach',
		name = "Attach to running Neovim instance",
	}
}
dap.adapters.nlua = function(callback, config)
	print("Connect to 127.0.0.1:8086 lua debugger")
	callback({ type = 'server', host = "127.0.0.1", port = 8086 })
end
