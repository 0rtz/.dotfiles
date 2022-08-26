-- log
function MyDump(...)
	local objects = vim.tbl_map(vim.inspect, {...})
	print(unpack(objects))
end

-- LSP format visual selection
function My_range_formatting()
	local start_row, _ = unpack(vim.api.nvim_buf_get_mark(0, "<"))
	local end_row, _ = unpack(vim.api.nvim_buf_get_mark(0, ">"))
	vim.lsp.buf.format({
		range = {
			["start"] = { start_row, 0 },
			["end"] = { end_row, 0 },
		},
		async = true,
	})
end

-- disable diagnostics/errors in buffer
vim.b.my_diagnostics_visible_buffer = true
function My_toggle_diagnostics_buffer()
	if vim.b.my_diagnostics_visible_buffer then
		vim.b.my_diagnostics_visible_buffer = false
		vim.diagnostic.disable(0)
	else
		vim.b.my_diagnostics_visible_buffer = true
		vim.diagnostic.enable(0)
	end
end
-- disable diagnostics/errors globally
vim.b.my_diagnostics_visible = true
function My_toggle_diagnostics()
	if vim.b.my_diagnostics_visible then
		vim.diagnostic.disable()
		vim.b.my_diagnostics_visible = false
	else
		vim.b.my_diagnostics_visible = true
		vim.diagnostic.enable()
	end
end

-- notification manager custom_instance
function MyNotificationMin(str)
	local custom_opts = {
		render = "minimal",
		stages = "static",
		timeout = 1500,
	}
	local custom_instance = vim.notify.instance(custom_opts, false)
	custom_instance(str, 2, custom_opts)
end
