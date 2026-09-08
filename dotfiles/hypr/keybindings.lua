-- tracklinux Hyprland keybindings
-- Target: Hyprland 0.55+ Lua configuration
--
-- Load from ~/.config/hypr/hyprland.lua with:
-- require("keybindings")
--
-- Philosophy:
--   Persistent = infrastructure
--   On-demand  = interface
--   Keep bindings small, predictable, and application-centric.

-- ---------------------------------------------------------------------------
-- Applications
-- ---------------------------------------------------------------------------

local terminal = "foot"
local launcher = "fuzzel"
local browser  = "firefox"

hl.bind(
    "SUPER + RETURN",
    hl.dsp.exec_cmd(terminal),
    { description = "Launch terminal" }
)

hl.bind(
    "SUPER + SPACE",
    hl.dsp.exec_cmd(launcher),
    { description = "Launch application launcher" }
)

hl.bind(
    "SUPER + B",
    hl.dsp.exec_cmd(browser),
    { description = "Launch browser" }
)

-- ---------------------------------------------------------------------------
-- Window / application lifecycle
-- ---------------------------------------------------------------------------

-- Close only the currently focused window.
-- Hyprland sends a graceful close request to that window.
hl.bind(
    "SUPER + W",
    hl.dsp.window.close(),
    { description = "Close active window" }
)

-- Quit the active application using the conventional application-level
-- Ctrl+Q shortcut. This is intentionally different from closing one window.
--
-- Because this is an application shortcut rather than a forced process kill,
-- applications can still show Save / Cancel dialogs when appropriate.
--
-- Note: Ctrl+Q is common but not universal. Some XWayland applications may
-- also handle injected shortcuts differently.
hl.bind(
    "SUPER + Q",
    hl.dsp.send_shortcut({
        mods = "CTRL",
        key = "Q",
        window = "activewindow"
    }),
    { description = "Quit active application (Ctrl+Q)" }
)

-- Deliberately no force-kill keybinding by default.
-- If we later decide one is useful, Hyprland provides hl.dsp.window.kill(),
-- which sends SIGKILL and should be reserved for hung applications.

-- ---------------------------------------------------------------------------
-- Window state
-- ---------------------------------------------------------------------------

hl.bind(
    "SUPER + F",
    hl.dsp.window.fullscreen({
        action = "toggle",
        mode = "fullscreen"
    }),
    { description = "Toggle fullscreen" }
)

-- ---------------------------------------------------------------------------
-- Focus navigation — Vim-style H/J/K/L
-- ---------------------------------------------------------------------------

hl.bind("SUPER + H", hl.dsp.focus({ direction = "l" }),
    { description = "Focus left" })

hl.bind("SUPER + J", hl.dsp.focus({ direction = "d" }),
    { description = "Focus down" })

hl.bind("SUPER + K", hl.dsp.focus({ direction = "u" }),
    { description = "Focus up" })

hl.bind("SUPER + L", hl.dsp.focus({ direction = "r" }),
    { description = "Focus right" })

-- ---------------------------------------------------------------------------
-- Move windows — Super + Shift + H/J/K/L
-- ---------------------------------------------------------------------------

hl.bind("SUPER + SHIFT + H", hl.dsp.window.move({ direction = "l" }),
    { description = "Move window left" })

hl.bind("SUPER + SHIFT + J", hl.dsp.window.move({ direction = "d" }),
    { description = "Move window down" })

hl.bind("SUPER + SHIFT + K", hl.dsp.window.move({ direction = "u" }),
    { description = "Move window up" })

hl.bind("SUPER + SHIFT + L", hl.dsp.window.move({ direction = "r" }),
    { description = "Move window right" })

-- ---------------------------------------------------------------------------
-- Workspaces 1–9
-- ---------------------------------------------------------------------------

for i = 1, 9 do
    hl.bind(
        "SUPER + " .. i,
        hl.dsp.focus({ workspace = i }),
        { description = "Switch to workspace " .. i }
    )

    -- Move the active window without following it.
    hl.bind(
        "SUPER + SHIFT + " .. i,
        hl.dsp.window.move({
            workspace = i,
            follow = false
        }),
        { description = "Move window to workspace " .. i }
    )
end

-- ---------------------------------------------------------------------------
-- Mouse window manipulation
-- ---------------------------------------------------------------------------

-- Super + left-drag: move floating window.
hl.bind(
    "SUPER + mouse:272",
    hl.dsp.window.drag(),
    {
        mouse = true,
        description = "Drag window"
    }
)

-- Super + right-drag: resize floating window.
hl.bind(
    "SUPER + mouse:273",
    hl.dsp.window.resize(),
    {
        mouse = true,
        description = "Resize window"
    }
)

-- ---------------------------------------------------------------------------
-- Hardware controls
-- ---------------------------------------------------------------------------

-- Audio control uses wpctl (provided by WirePlumber).
hl.bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),
    {
        repeating = true,
        locked = true,
        description = "Volume up"
    }
)

hl.bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    {
        repeating = true,
        locked = true,
        description = "Volume down"
    }
)

hl.bind(
    "XF86AudioMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    {
        locked = true,
        description = "Toggle audio mute"
    }
)

-- Display brightness requires the brightnessctl package.
hl.bind(
    "XF86MonBrightnessUp",
    hl.dsp.exec_cmd("brightnessctl set +5%"),
    {
        repeating = true,
        description = "Brightness up"
    }
)

hl.bind(
    "XF86MonBrightnessDown",
    hl.dsp.exec_cmd("brightnessctl set 5%-"),
    {
        repeating = true,
        description = "Brightness down"
    }
)
