-- Keyboard/mouse
-- https://wiki.hypr.land/Configuring/Basics/Variables/#input

-- Cursor
hl.env("XCURSOR_SIZE", "32")
hl.env("XCURSOR_THEME", "phinger-cursors-light")

hl.config({
    input = {
        -- Keyboard languages
        kb_layout  = "us,ru",
        kb_options = "caps:none,grp:shift_caps_toggle",

        -- Do not select window under cursor automatically
        follow_mouse = 0,

        -- Can focus windows in the regular workspace from within special workspace if special
        --   workspace contains only floating windows
        -- Special workspaces: scratchpad, bitwarden, etc.
        special_fallthrough = true,

        -- Mouse input sensitivity
        sensitivity = 0.1,
    },

    cursor = {
        -- Hide cursor after 3 seconds of inactivity
        inactive_timeout = 3,
    },
})
