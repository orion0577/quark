local WORKSPACES_PER_MONITOR = 5
local WRAP_AROUND = false

-- map monitor name -> stable index (0,1,2,...)
local monitor_index_map = {}

local function rebuild_monitor_map()
    monitor_index_map = {}

    for i, m in ipairs(hl.get_monitors()) do
        monitor_index_map[m.name] = i - 1
    end
end

rebuild_monitor_map()

hl.on("monitor.added", function()
    rebuild_monitor_map()
end)

local function get_monitor_index(mon)
    return monitor_index_map[mon.name] or 0
end

local function ws_id(mon, local_ws)
    return get_monitor_index(mon) * WORKSPACES_PER_MONITOR + local_ws
end

-- create workspaces per monitor
local function create_workspaces(mon)
    for i = 1, WORKSPACES_PER_MONITOR do
        hl.workspace_rule({
            workspace = tostring(ws_id(mon, i)),
            monitor = mon.name,
            persistent = true,
            default = (i == 1),
        })
    end
end

for _, m in ipairs(hl.get_monitors()) do
    create_workspaces(m)
end

hl.on("monitor.added", create_workspaces)

-- get active monitor safely
local function active_monitor()
    return hl.get_active_monitor()
end

-- get local workspace index (1..5)
local function local_ws_index()
    local ws = hl.get_active_workspace()
    if not ws then return nil end

    local idx = ((ws.id - 1) % WORKSPACES_PER_MONITOR) + 1
    return idx
end

-- focus workspace
local function focus_ws(i)
    local mon = active_monitor()
    if not mon then return end

    hl.dispatch(
        hl.dsp.focus({
            workspace = tostring(ws_id(mon, i))
        })
    )
end

-- move window
local function move_ws(i)
    local mon = active_monitor()
    if not mon then return end

    hl.dispatch(
        hl.dsp.window.move({
            workspace = tostring(ws_id(mon, i)),
            follow = true
        })
    )
end

-- relative navigation
local function step(forward, fn)
    local i = local_ws_index()
    if not i then return end

    if forward then
        i = i + 1
        if i > WORKSPACES_PER_MONITOR then
            if WRAP_AROUND then i = 1 else return end
        end
    else
        i = i - 1
        if i < 1 then
            if WRAP_AROUND then i = WORKSPACES_PER_MONITOR else return end
        end
    end

    fn(i)
end

-- keybinds (Mod+1..5)
for i = 1, WORKSPACES_PER_MONITOR do
    hl.bind("SUPER + " .. i, function()
        focus_ws(i)
    end)

    hl.bind("SUPER + SHIFT + " .. i, function()
        move_ws(i)
    end)
end

-- scroll / navigation
hl.bind("SUPER + mouse_up", function()
    step(true, focus_ws)
end)

hl.bind("SUPER + mouse_down", function()
    step(false, focus_ws)
end)

hl.bind("SUPER + CTRL + right", function()
    step(true, focus_ws)
end)

hl.bind("SUPER + CTRL + left", function()
    step(false, focus_ws)
end)

hl.bind("SUPER + ALT + right", function()
    step(true, move_ws)
end)

hl.bind("SUPER + ALT + left", function()
    step(false, move_ws)
end)
