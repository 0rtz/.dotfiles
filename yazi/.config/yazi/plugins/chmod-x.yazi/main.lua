-- Toggle executable permission on selected/hovered files
local get_urls = ya.sync(function()
	local urls = {}
	for _, url in pairs(cx.active.selected) do
		urls[#urls + 1] = tostring(url)
	end
	if #urls == 0 then
		local h = cx.active.current.hovered
		if h then urls[1] = tostring(h.url) end
	end
	return urls
end)

local function entry()
	local urls = get_urls()
	if #urls == 0 then return end

	-- Check first file to decide +x or -x
	local cha = fs.cha(Url(urls[1]))
	local flag = (cha and cha:perm():sub(4, 4) == "x") and "-x" or "+x"

	local status, err = Command("chmod"):arg(flag):arg(urls):status()
	if not status or not status.success then
		return ya.notify {
			title = "chmod",
			content = "Failed: " .. tostring(err or "unknown error"),
			level = "error",
			timeout = 3,
		}
	end

	ya.notify {
		title = "chmod",
		content = flag .. " on " .. #urls .. " file(s)",
		timeout = 2,
	}
end

return { entry = entry }
