-- Change directory to a path read from system clipboard
local function entry()
	local dir = ya.clipboard()
	if not dir or dir == "" then return end

	-- Expand ~ and $HOME
	local home = os.getenv("HOME") or ""
	if dir:sub(1, 1) == "~" then
		dir = home .. dir:sub(2)
	elseif dir:sub(1, 5) == "$HOME" then
		dir = home .. dir:sub(6)
	end

	-- If the path is a file, cd to its parent directory
	local url = Url(dir)
	local cha = fs.cha(url)
	if cha and not cha.is_dir then
		url = url.parent
	end

	if url then
		ya.emit("cd", { url })
	end
end

return { entry = entry }
