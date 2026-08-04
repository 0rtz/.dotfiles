local count = ya.sync(function()
	return #cx.tabs
end)

local function entry()
	if count() > 1 then
		-- https://yazi-rs.github.io/docs/configuration/keymap/#mgr.close
		return ya.emit("close", {})
	end

	local yes = ya.confirm {
		pos = { "center", w = 20, h = 5 },
		title = "Quit?",
	}

	if yes then
		ya.emit("quit", {})
	end
end

return { entry = entry }
