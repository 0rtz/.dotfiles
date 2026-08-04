-- Workspaces

-------------------------------
---- SWITCH WORKSPACES ----
-------------------------------

hl.bind(mainMod .. " + q", hl.dsp.focus({ workspace = 1 }))
hl.bind(mainMod .. " + w", hl.dsp.focus({ workspace = 2 }))
hl.bind(mainMod .. " + d", hl.dsp.focus({ workspace = 3 }))
hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = 4 }))
hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace = 5 }))
hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace = 6 }))
hl.bind(mainMod .. " + 4", hl.dsp.focus({ workspace = 7 }))
hl.bind(mainMod .. " + 5", hl.dsp.focus({ workspace = 8 }))
hl.bind(mainMod .. " + 6", hl.dsp.focus({ workspace = 9 }))
hl.bind(mainMod .. " + 7", hl.dsp.focus({ workspace = 10 }))
hl.bind(mainMod .. " + a", hl.dsp.focus({ workspace = "previous" }))

-------------------------------
---- MOVE WINDOW TO WORKSPACE ----
-------------------------------

local function move_to_workspace(key, ws)
    hl.bind(mainMod .. " + SHIFT + " .. key, function()
        hl.dispatch(hl.dsp.window.move({ out_of_group = true }))
        hl.dispatch(hl.dsp.window.move({ workspace = ws, follow = false }))
    end)
end

move_to_workspace("q", 1)
move_to_workspace("w", 2)
move_to_workspace("d", 3)
move_to_workspace("1", 4)
move_to_workspace("2", 5)
move_to_workspace("3", 6)
move_to_workspace("4", 7)
move_to_workspace("5", 8)
move_to_workspace("6", 9)
move_to_workspace("7", 10)

-------------------------------
---- SCRATCHPAD ----
-------------------------------

-- Move the currently focused window to the scratchpad
hl.bind(mainMod .. " + SHIFT + period", function()
    hl.dispatch(hl.dsp.window.move({ out_of_group = true }))
    hl.dispatch(hl.dsp.window.move({ workspace = "special:magic" }))
end)
-- Show scratchpad
hl.bind(mainMod .. " + period", hl.dsp.workspace.toggle_special("magic"))

-------------------------------
---- ANIMATION ----
-------------------------------

-- Animation for switching between workspaces
hl.animation({ leaf = "workspaces", enabled = true, speed = 3, bezier = "default", style = "slidefade 80%" })

-------------------------------
---- DECORATION ----
-------------------------------

hl.config({
    decoration = {
        -- How much to dim the rest of the screen when a special workspace is open
        dim_special = 0.1,
    },
})
