-- Applications
-- https://wiki.hypr.land/Configuring/Basics/Binds/

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- Toolkit backends
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")

-- XDG
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- Qt
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")

-- Electron apps
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- Mozilla
hl.env("MOZ_ENABLE_WAYLAND", "1")

-------------------------------
---- KEYBINDINGS ----
-------------------------------

-- Application launcher
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("rofi -show drun"))

-- Status bar
hl.bind(mainMod .. " + b", hl.dsp.exec_cmd("killall -SIGUSR1 waybar"))
hl.layer_rule({
    name  = "waybar-blur",
    match = { namespace = "waybar" },
    blur  = true,
})

-- Poweroff menu
hl.bind(mainMod .. " + SHIFT + Return", hl.dsp.exec_cmd("alacritty --class poweroff_menu --option font.size=25.0 --command fish -c 'my-powermenu'"))
hl.window_rule({
    name  = "poweroff-menu-float",
    match = { class = "poweroff_menu" },
    float = true,
    size  = "monitor_w*0.2 monitor_h*0.3",
    pin   = true,
})

-- Show last notification
hl.bind(mainMod .. " + n", hl.dsp.exec_cmd("dunstctl history-pop"))

-- Pick color
hl.bind(mainMod .. " + c", hl.dsp.exec_cmd("hyprpicker --autocopy"))

-- Clock
hl.bind(mainMod .. " + t", hl.dsp.exec_cmd([[alacritty --class "time_display" --option font.size=100.0 --command fish -c "my-time"]]))
hl.bind(mainMod .. " + t", hl.dsp.window.close({ window = "class:time_display" }), { release = true })
hl.window_rule({
    name  = "clock-float",
    match = { class = "time_display" },
    float = true,
    size  = "650 170",
})

-- Screenshot
hl.bind(mainMod .. " + s", hl.dsp.exec_cmd("fish -c 'my-take-screenshot'"))
hl.bind(mainMod .. " + SHIFT + s", hl.dsp.exec_cmd("fish -c 'my-take-screenshot --annotate'"))
-- Screen recording
hl.bind(mainMod .. " + r", hl.dsp.exec_cmd("fish -c 'my-screen-record'"))
-- Disable animations for 'slurp' (used when taking screenshots, recording screen)
hl.layer_rule({
    name     = "slurp-screenshot",
    match    = { namespace = "selection" },
    no_anim  = true,
})

-- Lock screen
hl.bind("CTRL + ALT + SHIFT + L", hl.dsp.exec_cmd("hyprlock"))

-- File manager
hl.bind(mainMod .. " + SHIFT + f", hl.dsp.exec_cmd("~/.config/hypr/scripts/filemanager.sh"))
hl.window_rule({
    name      = "file-manager-float",
    match     = { class = "org.gnome.Nautilus" },
    float     = true,
    opacity   = 0.8,
    size      = "monitor_w*0.5 monitor_h*0.5",
    move      = "(monitor_w-window_w)*0.5 (monitor_h-window_h)*0.5",
    workspace = "special:filemanager",
})

-- Password manager
hl.bind(mainMod .. " + SHIFT + p", hl.dsp.exec_cmd("~/.config/hypr/scripts/bitwarden.sh"))
hl.window_rule({
    name      = "password-manager-float",
    match     = { class = "^Bitwarden$" },
    float     = true,
    size      = "monitor_w*0.6 monitor_h*0.5",
    move      = "0 monitor_h-window_h-70",
    workspace = "special:bitwarden",
})

-- Task/time tracker
hl.bind(mainMod .. " + SHIFT + t", hl.dsp.exec_cmd("~/.config/hypr/scripts/tracker.sh"))
hl.window_rule({
    name      = "time-tracker-float",
    match     = { class = "superProductivity" },
    workspace = "special:superproductivity",
})
