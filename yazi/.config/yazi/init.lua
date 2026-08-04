-- List yazi plugins: \ya pkg list
-- Builtin components accessible through lua: https://github.com/sxyazi/yazi/blob/main/yazi-plugin/preset/components

-- https://github.com/yazi-rs/plugins/tree/main/full-border.yazi
require("full-border"):setup()

-- https://github.com/yazi-rs/plugins/tree/main/no-status.yazi
require("no-status"):setup()

-- https://github.com/yazi-rs/plugins/tree/main/git.yazi
require("git"):setup {
	-- Order of status signs showing in the linemode
	order = 1500,
}

-- https://yazi-rs.github.io/docs/plugins/builtins/#zoxide
require("zoxide"):setup {
	update_db = true,
}