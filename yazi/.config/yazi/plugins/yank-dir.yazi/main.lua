-- Copy current directory path to system clipboard
local get_cwd = ya.sync(function()
	return tostring(cx.active.current.cwd)
end)

local function entry()
	local cwd = get_cwd()
	ya.clipboard(cwd)
	ya.notify {
		title = "yazi",
		content = "yanked: " .. cwd,
		timeout = 2,
	}
end

return { entry = entry }
