-- https://wiki.hypr.land/Configuring/Start/

--------------------
---- LEADER KEY ----
--------------------

-- Alt key
mainMod = "ALT"
-- Win key
-- mainMod = "SUPER"

--------------------
---- MODULES ----
--------------------

require("conf.input")
require("conf.applications")
require("conf.windows")
require("conf.workspaces")

-- Machine-specific overrides (optional, won't error if missing)
pcall(require, "local_config")

--------------------
---- SETTINGS ----
--------------------

-- Clean startup
-- https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    ecosystem = {
        no_donation_nag = true,
        no_update_news  = true,
    },

    -- No default UI
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
    },
})

--------------------
---- AUTOSTART ----
--------------------

-- Run my-desktop.target dependencies after Hyprland finished setting up
hl.on("hyprland.start", function()
    hl.exec_cmd("systemctl --user start my-desktop.target")
end)
