-- TODO
-- layout switching (with super+tab but could also be in mabi-shell)
-- look into hyprshutdown

local function try_require(module)
    local status, value = pcall(require, module)
    if status then
        return value
    else
        return nil
    end
end

require("monitors")
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

-- Autostart
try_require("/usr/local/share/mabi-shell/hyprland")
hl.on("hyprland.start", function()
    -- to run mabi-shell in
    hl.exec_cmd("kitty", { workspace = "3 silent" })

    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("udiskie")
    -- TODO: try the hypr polkit agent
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    -- This is required for gammastep and mabi-shell
    -- Eventually mabi-shell may become an agent
    hl.exec_cmd("/usr/lib/geoclue-2.0/demos/agent")
    hl.exec_cmd("gammastep-indicator")
    hl.exec_cmd("elephant")
    hl.exec_cmd("walker --gapplication-service")
    hl.exec_cmd("ghostty --initial-window=false")
end)
-- This is a separate file so any per-device spawns can work.
try_require("autostart-apps")

-- Environment variables
hl.env("XCURSOR_THEME", "Adwaita")
hl.env("XCURSOR_SIZE", 24)

-- Make Qt apps behave
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")

-- Make KDE apps behave
-- This needs archlinux-xdg-menu
-- Also, use qt6ct-kde for styling
-- TODO: Maybe there's a better way to make Dolphin not mess up its menus
hl.env("XDG_MENU_PREFIX", "arch-")

-- Look and feel
hl.config({
    general = {
        gaps_in = 4,
        gaps_out = 6,
        border_size = 2,
        col = {
            active_border = { colors = { "#e174c5ee", "#8643b5ee" }, angle = 45 },
            inactive_border = "#595959aa",
        },
        resize_on_border = false,
        allow_tearing = false,

        layout = "dwindle",
    },
    decoration = {
        rounding = 8,
        rounding_power = 3,

        blur = {
            enabled = true,
            size = 12,
            passes = 2,
            vibrancy = 0.1696,
        },

        shadow = {
            enabled = true,
            color = "#1a1a1aee",
            range = 4,
            render_power = 3,
        }
    },
})

-- Animations
hl.config({ ["animations.enabled"] = true })
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 80%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 80%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 5, bezier = "quick" })

-- Behavior
hl.config({
    input = {
        kb_layout = "pl",

        follow_mouse = 2,
        float_switch_override_focus = 0,
        sensitivity = 0,

        touchpad = {
            natural_scroll = true,
        }
    },
    gestures = {
        workspace_swipe_distance = 300,
        workspace_swipe_cancel_ratio = 0.4,
    },
    misc = {
        middle_click_paste = false,
        vrr = 1,
        focus_on_activate = true,
        screencopy_force_8b = false,
    },
    -- TODO: Enable when 0.57 is out
    --[[
    layers = {
        allow_new_top_layers_over_existing_fullscreen = false,
    },
    --]]
    xwayland = {
        force_zero_scaling = true,
    },
    dwindle = {
        preserve_split = true,
    }
})

-- Binds
-- Window/workspace actions
hl.bind("SUPER + C", hl.dsp.window.close())
hl.bind("SUPER + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + P", hl.dsp.window.pseudo({ action = "toggle" }))
hl.bind("SUPER + J", hl.dsp.layout("togglesplit"))
for i = 1, 10 do
    -- map 10 to key 0
    local key = i % 10
    hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end
hl.bind("SUPER + left", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + up", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + down", hl.dsp.focus({ direction = "down" }))
local resize_delta = 120
hl.bind("SUPER + CTRL + left", hl.dsp.window.resize({ x = resize_delta, y = 0, relative = true }))
hl.bind("SUPER + CTRL + right", hl.dsp.window.resize({ x = resize_delta, y = 0, relative = true }))
hl.bind("SUPER + CTRL + up", hl.dsp.window.resize({ x = 0, y = -resize_delta, relative = true }))
hl.bind("SUPER + CTRL + down", hl.dsp.window.resize({ x = 0, y = resize_delta, relative = true }))

-- Mouse actions
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "m-1" }))
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "m+1" }))
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Gestures
hl.gesture({
    action = "workspace",
    direction = "horizontal",
    fingers = 3,
})

-- Programs
hl.bind("SUPER + Space", hl.dsp.exec_cmd("walker"))
-- Copilot button
hl.bind("SUPER + SHIFT + XF86Assistant", hl.dsp.exec_cmd("walker"))
hl.bind("SUPER + Q", hl.dsp.exec_cmd("ghostty +new-window"))
hl.bind("SUPER + E", hl.dsp.exec_cmd("dolphin --new-window"))
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("spaceshot region"))
-- TODO: show notification (this needs mabi-shell to support the span element)
hl.bind("SUPER + ALT + S", hl.dsp.exec_cmd("hyprpicker -al"))
-- TODO: integrate wl-clip-persist into the clipboard setup
hl.bind("SUPER + V", hl.dsp.exec_cmd("walker -m clipboard"))
hl.bind("SUPER + semicolon", hl.dsp.exec_cmd("walker -m symbols"))
hl.bind("SUPER + period", hl.dsp.exec_cmd("walker -m symbols"))

-- Global shortcuts
hl.bind("CTRL + period", hl.dsp.send_shortcut({ window = "class:vesktop", mods = "CTRL + SHIFT", key = "M" }))

-- Media keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("mabictl volume up"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("mabictl volume down"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("mabictl volume mute"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("mabictl brightness up"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("mabictl brightness down"), { locked = true, repeating = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Show Caps Lock state
-- Unfortunately Lua does not have API for checking it.
hl.bind("Caps_Lock", hl.dsp.exec_cmd("~/.config/hypr/scripts/capslock.fish"), {
    locked = true,
    release = true,
    non_consuming = true,
    transparent = true,
    ignore_mods = true,
    dont_inhibit = true,
    submap_universal = true,
})

-- Window rules
hl.window_rule({
    name = "float-pip",
    match = { class = "firefox", title = "Obraz.*" },
    float = true,
    suppress_event = "activate",
})

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name = "fix-xwayland-drags",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },

    no_focus = true,
})

-- Float dialogs
hl.window_rule({
    name = "float-gimp-dialogs",
    match = { class = "script-fu" },
    float = true,
})
hl.window_rule({
    name = "float-file-pickers",
    match = { title = "Open (File|Folder).*" },
    float = true,
})
hl.window_rule({
    name = "float-portal",
    match = { class = "xdg-desktop-portal-gtk" },
    float = true,
})
hl.window_rule({
    name = "float-gajim",
    match = { class = [[org\.gajim\.Gajim]] },
    float = true,
})

local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
