-- Windows

local mocha = require("conf.mocha")

-------------------------------
---- FOCUS & MOVEMENT ----
-------------------------------

-- Move focus between windows
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

-- https://wiki.hypr.land/Configuring/Basics/Variables/#binds
hl.config({
    binds = {
        -- In a grouped window movefocus cycles windows in the groups first,
        -- then at each ends of tabs moves to other groups
        movefocus_cycles_groupfirst = true,
    },
})

-- Move focused windows
hl.bind(mainMod .. " + SHIFT + Left",  hl.dsp.group.move_window({ forward = false }))
hl.bind(mainMod .. " + SHIFT + Right", hl.dsp.group.move_window({ forward = true }))
hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.move({ direction = "left",  group_aware = true }))
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.move({ direction = "right", group_aware = true }))
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.move({ direction = "up",    group_aware = true }))
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.move({ direction = "down",  group_aware = true }))

-- Move/resize windows with mainMod + Left-mouse/Right-mouse click and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Toggle window tiling/floating state
hl.bind(mainMod .. " + SHIFT + SPACE", function()
    hl.dispatch(hl.dsp.window.move({ out_of_group = true }))
    hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
end)

-- Toggle tabbed layout for a window
hl.bind(mainMod .. " + e", hl.dsp.group.toggle())

-- Enter fullscreen mode for the focused window
hl.bind(mainMod .. " + f", hl.dsp.window.fullscreen())

-- Kill focused window
hl.bind(mainMod .. " + SHIFT + x", hl.dsp.window.close())

-- Focus when client requests window activation (urgent window)
hl.config({
    misc = {
        focus_on_activate = true,
    },
})

-------------------------------
---- LAYOUT ----
-------------------------------

-- Initial windows layout = tabbed
-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/#group-window-rule-options
hl.window_rule({
    name  = "default-layout",
    match = { class = "(.*)" },
    group = "set always",
})

hl.config({
    -- https://wiki.hypr.land/Configuring/Basics/Variables/#general
    general = {
        -- Layout used for non tabbed windows
        layout = "dwindle",
    },
    -- https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/
    dwindle = {
        -- The split (side/top) will not change regardless of what happens to the window
        preserve_split = true,
    },
})

hl.config({
    group = {
        -- Dragging a floating window into a tiled window groupbar will merge them
        merge_floated_into_tiled_on_groupbar = true,
    },
})

-------------------------------
---- APPEARANCE ----
-------------------------------

hl.config({
    group = {
        -- Active group (set of tabbed windows) border color
        col = {
            border_active   = mocha.maroon,
            border_inactive = mocha.base,
        },

        -- Windows title bars appearance (single red thin line)
        -- https://wiki.hypr.land/Configuring/Basics/Variables/#group
        groupbar = {
            gaps_in          = 0,
            gaps_out         = 0,
            indicator_height = 4,
            height           = 0,
            rounding         = 0,
            render_titles    = false,
            round_only_edges = false,
            col = {
                active   = mocha.maroon,
                inactive = mocha.base,
            },
        },
    },
})

-- Windows borders appearance
-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
hl.config({
    general = {
        -- Gaps between windows
        gaps_in  = 0,
        -- Gaps between windows and monitor edges
        gaps_out = 0,

        -- Size of the border around windows
        border_size = 2,

        col = {
            -- Border color for the active window
            active_border   = mocha.maroon,
            -- Border color for inactive windows
            inactive_border = mocha.base,
        },
    },

    -- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
    decoration = {
        -- Do not use rounded windows borders
        rounding       = 0,
        rounding_power = 0,

        -- https://wiki.hypr.land/Configuring/Basics/Variables/#blur
        blur = {
            -- Higher value = more blurry
            size = 4,
        },
    },
})

-------------------------------
---- WINDOW RULES ----
-------------------------------

-- Floating windows appearance
-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/
hl.window_rule({
    name        = "floating-windows",
    match       = { float = true },
    opacity     = 0.9,
    border_size = 2,
})

-- "Smart gaps" / "No gaps when only"
-- https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/#smart-gaps
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
hl.window_rule({
    name        = "no-gaps-wtv1",
    match       = { float = false, workspace = "w[tv1]" },
    border_size = 0,
    rounding    = 0,
})
hl.window_rule({
    name        = "no-gaps-f1",
    match       = { float = false, workspace = "f[1]" },
    border_size = 0,
    rounding    = 0,
})

-------------------------------
---- ANIMATIONS ----
-------------------------------
--- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/

-- Disable all animations by default, then selectively enable below
hl.animation({ leaf = "global", enabled = false })

-- Windows creation
hl.animation({ leaf = "windows", enabled = true, speed = 2, bezier = "default", style = "popin" })

-- Overlay windows that appear on top of regular windows (e.g. notification popups, dropdown menus (rofi), floating panels)
hl.animation({ leaf = "layers", enabled = true, speed = 4, bezier = "default", style = "slide" })
