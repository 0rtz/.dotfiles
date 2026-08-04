-- Copy selected/hovered file names to system clipboard
local get_names = ya.sync(function()
	local names = {}
	for _, url in pairs(cx.active.selected) do
		names[#names + 1] = url.name
	end
	if #names == 0 then
		local h = cx.active.current.hovered
		if h then names[1] = h.url.name end
	end
	return names
end)

local function entry()
	local names = get_names()
	if #names == 0 then return end

	local result = table.concat(names, "\n")
	ya.clipboard(result)
	ya.notify {
		title = "yazi",
		content = "yanked: " .. result,
		timeout = 2,
	}
end

return { entry = entry }
