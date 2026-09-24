
local mainMod = "SUPER"
local RESIZE_STEP = 50

-- Applications
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("rofi -show drun"))
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd("ghostty"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("librewolf"))
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd("zotero"))
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd("flatpak run org.jeffvli.feishin"))
-- Window navigation
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + TAB", hl.dsp.exec_cmd("hyprctl dispatch focuscurrentorlast"))

-- Client controls
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + E", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))

-- Layout controls
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("hyprctl keyword general:layout dwindle"))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("hyprctl dispatch fullscreen 1"))
hl.bind(mainMod .. " + SPACE", hl.dsp.layout("togglesplit"))

-- Resize window with keyboard

hl.bind(mainMod .. " + SHIFT + H",
    hl.dsp.window.resize({ x = -RESIZE_STEP, y = 0, relative = true }),
    { repeating = true })

hl.bind(mainMod .. " + SHIFT + L",
    hl.dsp.window.resize({ x = RESIZE_STEP, y = 0, relative = true }),
    { repeating = true })

hl.bind(mainMod .. " + SHIFT + K",
    hl.dsp.window.resize({ x = 0, y = -RESIZE_STEP, relative = true }),
    { repeating = true })

hl.bind(mainMod .. " + SHIFT + J",
    hl.dsp.window.resize({ x = 0, y = RESIZE_STEP, relative = true }),
    { repeating = true })

-- Monitor navigation
hl.bind(mainMod .. "+PERIOD", hl.dsp.focus({ monitor = "+1" }))


hl.bind(mainMod .. "+SHIFT+PERIOD",
    hl.dsp.window.move({ monitor = "+1", follow = true })
)

-- Screenshot
hl.bind(mainMod .. " + SHIFT + S",
    hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"))

-- Volume
hl.bind("XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),
    { locked = true, repeating = true })

hl.bind("XF86AudioLowerVolume",
    hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { locked = true, repeating = true })

hl.bind("XF86AudioMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true })

-- Brightness
hl.bind(mainMod .. " + SHIFT + equal",
    hl.dsp.exec_cmd("brightnessctl set +5% && ddcutil setvcp 10 + 5"),{ locked = true, repeating = true })

hl.bind(mainMod .. " + SHIFT + minus",hl.dsp.exec_cmd("brightnessctl set 5%- && ddcutil setvcp 10 - 5"),{ locked = true, repeating = true })

-- Reload / Quit
hl.bind(mainMod .. " + SHIFT + R",hl.dsp.exec_cmd("hyprctl reload"))

hl.bind(mainMod .. " + SHIFT + Q",hl.dsp.exit())

-- Power
hl.bind(mainMod .. " + SHIFT + RETURN",
    hl.dsp.exec_cmd("systemctl poweroff"))


hl.bind(mainMod .. " + SHIFT + D",hl.dsp.exec_cmd("DEV_ENV=/home/orion/personal/dev ~/personal/dev/dev-env"))

hl.bind(mainMod .. " + W",hl.dsp.exec_cmd("looking-glass -F -m KEY_END"))
