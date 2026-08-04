-- cd to the closest project root by searching upward for root patterns
local ROOT_PATTERNS = {
	".git", "_darcs", ".hg", ".bzr", ".svn",
	"package.json", ".root", ".marksman.toml",
}

local get_cwd = ya.sync(function()
	return cx.active.current.cwd
end)

local function entry()
	local dir = get_cwd()
	while dir do
		for _, pattern in ipairs(ROOT_PATTERNS) do
			local cha = fs.cha(dir:join(pattern))
			if cha then
				return ya.emit("cd", { dir })
			end
		end
		dir = dir.parent
	end
end

return { entry = entry }
