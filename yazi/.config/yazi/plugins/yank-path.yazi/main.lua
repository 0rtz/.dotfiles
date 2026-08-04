-- Copy selected/hovered file paths to system clipboard
local get_paths = ya.sync(function()
	local paths = {}
	for _, url in pairs(cx.active.selected) do
		paths[#paths + 1] = tostring(url)
	end
	if #paths == 0 then
		local h = cx.active.current.hovered
		if h then paths[1] = tostring(h.url) end
	end
	return paths
end)

local function entry()
	local paths = get_paths()
	if #paths == 0 then return end

	local result = table.concat(paths, "\n")
	ya.clipboard(result)
	ya.notify {
		title = "yazi",
		content = "yanked: " .. result,
		timeout = 2,
	}
end

return { entry = entry }
