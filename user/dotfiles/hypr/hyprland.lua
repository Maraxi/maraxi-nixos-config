-- Remove after, just to hide warnings
-- local hl = {}
------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
local monitor_left = 'DP-5'
local monitor_right = 'HDMI-A-2'
hl.monitor { output = monitor_left, mode = 'preferred', position = '0x0', scale = 'auto' }
hl.monitor { output = monitor_right, mode = 'preferred', position = '2560x0', scale = 'auto' }
hl.monitor { output = '', mode = 'preferred', position = 'auto', scale = 'auto' }

---------------------
---- MY PROGRAMS ----
---------------------

local terminal = 'ghostty +new-window'
local fileManager = 'nemo'
local menu = 'wofi --show drun --matching multi-contains --insensitive'

-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
hl.on('hyprland.start', function()
  hl.exec_cmd 'dbus-update-activation-environment --systemd --all'
  -- hl.exec_cmd("nm-applet")
  hl.exec_cmd 'waybar & hyprpaper'
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
hl.env('XCURSOR_SIZE', '24')
hl.env('HYPRCURSOR_SIZE', '24')
hl.env('LIBVA_DRIVER_NAME', 'nvidia')
hl.env('__GLX_VENDOR_LIBRARY_NAME', 'nvidia')

-----------------------
----- PERMISSIONS -----
-----------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")

-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config {
  general = {
    gaps_in = 5,
    gaps_out = { top = 0, right = 15, bottom = 12, left = 15 },

    border_size = 1,

    col = {
      active_border = { colors = { 'rgba(33ccffee)', 'rgba(00ff99ee)' }, angle = 45 },
      inactive_border = 'rgba(595959aa)',
    },

    -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
    resize_on_border = false,

    -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
    allow_tearing = false,

    layout = 'dwindle',
  },

  decoration = {
    rounding = 8,
    rounding_power = 2,

    -- Change transparency of focused and unfocused windows
    active_opacity = 1.0,
    inactive_opacity = 1.0,

    shadow = {
      enabled = true,
      range = 4,
      render_power = 3,
      color = 'rgba(1a1a1aee)',
    },

    blur = {
      enabled = false,
      size = 3,
      passes = 1,
      vibrancy = 0.1696,
    },
  },

  animations = {
    enabled = false,
  },
}

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve('easeOutQuint', { type = 'bezier', points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve('easeInOutCubic', { type = 'bezier', points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve('linear', { type = 'bezier', points = { { 0, 0 }, { 1, 1 } } })
hl.curve('almostLinear', { type = 'bezier', points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve('quick', { type = 'bezier', points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Default springs
hl.curve('easy', { type = 'spring', mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation { leaf = 'global', enabled = true, speed = 10, bezier = 'default' }
hl.animation { leaf = 'border', enabled = true, speed = 5.39, bezier = 'easeOutQuint' }
hl.animation { leaf = 'windows', enabled = true, speed = 4.79, spring = 'easy' }
hl.animation { leaf = 'windowsIn', enabled = true, speed = 4.1, spring = 'easy', style = 'popin 87%' }
hl.animation { leaf = 'windowsOut', enabled = true, speed = 1.49, bezier = 'linear', style = 'popin 87%' }
hl.animation { leaf = 'fadeIn', enabled = true, speed = 1.73, bezier = 'almostLinear' }
hl.animation { leaf = 'fadeOut', enabled = true, speed = 1.46, bezier = 'almostLinear' }
hl.animation { leaf = 'fade', enabled = true, speed = 3.03, bezier = 'quick' }
hl.animation { leaf = 'layers', enabled = true, speed = 3.81, bezier = 'easeOutQuint' }
hl.animation { leaf = 'layersIn', enabled = true, speed = 4, bezier = 'easeOutQuint', style = 'fade' }
hl.animation { leaf = 'layersOut', enabled = true, speed = 1.5, bezier = 'linear', style = 'fade' }
hl.animation { leaf = 'fadeLayersIn', enabled = true, speed = 1.79, bezier = 'almostLinear' }
hl.animation { leaf = 'fadeLayersOut', enabled = true, speed = 1.39, bezier = 'almostLinear' }
hl.animation { leaf = 'workspaces', enabled = true, speed = 1.94, bezier = 'almostLinear', style = 'fade' }
hl.animation { leaf = 'workspacesIn', enabled = true, speed = 1.21, bezier = 'almostLinear', style = 'fade' }
hl.animation { leaf = 'workspacesOut', enabled = true, speed = 1.94, bezier = 'almostLinear', style = 'fade' }
hl.animation { leaf = 'zoomFactor', enabled = true, speed = 7, bezier = 'quick' }

-- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- "Smart gaps" / "No gaps when only"
-- uncomment all if you wish to use that.
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule { workspace = 'f[1]', gaps_out = 0, gaps_in = 0 }
-- hl.window_rule({
--     name  = "no-gaps-wtv1",
--     match = { float = false, workspace = "w[tv1]" },
--     border_size = 0,
--     rounding    = 0,
-- })
-- hl.window_rule({
--     name  = "no-gaps-f1",
--     match = { float = false, workspace = "f[1]" },
--     border_size = 0,
--     rounding    = 0,
-- })

hl.config {
  -- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
  dwindle = {
    preserve_split = false, -- You probably want this
  },
  -- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
  master = {
    new_status = 'master',
  },
  -- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
  scrolling = {
    fullscreen_on_one_column = true,
  },
}

----------------
----  MISC  ----
----------------

hl.config {
  misc = {
    force_default_wallpaper = 0, -- Set to 0 or 1 to disable the anime mascot wallpapers
    disable_hyprland_logo = false, -- If true disables the random hyprland logo / anime girl background. :(
    col = { splash = 'rgba(00000000)' },
    focus_on_activate = true,
    key_press_enables_dpms = true,
  },
  ecosystem = {
    no_donation_nag = true,
  },
}

---------------
---- INPUT ----
---------------

hl.config {
  input = {
    kb_layout = 'de',
    kb_variant = 'nodeadkeys',
    kb_model = '',
    kb_options = 'caps:escape,compose:rctrl',
    kb_rules = '',

    follow_mouse = 1,
    mouse_refocus = false,

    sensitivity = 0.3, -- -1.0 - 1.0, 0 means no modification.
  },
}

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
--[[
hl.device({
	name = "epic-mouse-v1",
	sensitivity = -0.5,
})
]]

hl.config {
  cursor = {
    no_warps = true,
  },
}

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = 'SUPER + ' -- Sets "Windows" key as main modifier
local mehMod = 'SUPER + CTRL + SHIFT + ' -- Sets "Windows" key as main modifier

hl.bind(mainMod .. 'Return', hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. 'D', hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. 'E', hl.dsp.exec_cmd(fileManager))

hl.bind(mehMod .. 'Q', hl.dsp.window.close())
hl.bind(mehMod .. 'K', hl.dsp.window.kill())

hl.bind(mehMod .. 'L', hl.dsp.window.float { action = 'toggle' })
hl.bind(
  mainMod .. 'space',
  function()
    hl.dispatch(hl.dsp.window.cycle_next {
      floating = not hl.get_active_window().floating,
    })
  end,
  { description = 'Switch focus between tiled and floating windows' }
)

-- hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
-- hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle only

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. 'H', hl.dsp.focus { direction = 'left' })
hl.bind(mainMod .. 'L', hl.dsp.focus { direction = 'right' })
hl.bind(mainMod .. 'K', hl.dsp.focus { direction = 'up' })
hl.bind(mainMod .. 'J', hl.dsp.focus { direction = 'down' })
hl.bind(mainMod .. 'SHIFT + ' .. 'H', hl.dsp.workspace.move { monitor = 'l' })
hl.bind(mainMod .. 'SHIFT + ' .. 'L', hl.dsp.workspace.move { monitor = 'r' })
hl.bind(mainMod .. 'SHIFT + ' .. 'left', hl.dsp.window.move { direction = 'l' })
hl.bind(mainMod .. 'SHIFT + ' .. 'right', hl.dsp.window.move { direction = 'r' })
hl.bind(mainMod .. 'SHIFT + ' .. 'up', hl.dsp.window.move { direction = 'u' })
hl.bind(mainMod .. 'SHIFT + ' .. 'down', hl.dsp.window.move { direction = 'd' })

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
  local key = i % 10 -- 10 maps to key 0
  hl.bind(mainMod .. key, function()
    hl.dispatch(hl.dsp.focus { workspace = i })
    -- If the workspace was newly created then focus can move back to the window under the mouse
    -- Find the monitor that owns this workspace.
    local workspace = hl.get_workspace(i)
    local active_monitor = hl.get_active_monitor()
    if workspace and workspace.monitor and workspace.monitor ~= active_monitor then
      -- Explicitly focus that monitor.
      hl.dispatch(hl.dsp.focus { monitor = workspace.monitor.name })
    end
  end)
  hl.bind(mainMod .. 'SHIFT + ' .. key, hl.dsp.window.move { workspace = i })
end

-- Alt tab to last active window
hl.bind(mainMod .. 'tab', hl.dsp.focus { last = true })
hl.bind(mainMod .. 'asciicircum', function()
  hl.dispatch(hl.dsp.workspace.move { workspace = 2, monitor = monitor_right })
  hl.dispatch(hl.dsp.focus { workspace = 2 })
end)

-- Full Screen
hl.bind(mehMod .. 'F', hl.dsp.window.fullscreen { action = 'toggle', mode = 'fullscreen' })
hl.bind(mehMod .. 'G', hl.dsp.window.fullscreen { action = 'toggle', mode = 'maximized' })
hl.bind(mehMod .. 'H', hl.dsp.window.fullscreen_state { action = 'toggle', internal = 0, client = 2 })

-- Example special workspace (scratchpad)
-- hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
-- hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
-- hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
-- hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. 'mouse:272', hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. 'mouse:273', hl.dsp.window.resize(), { mouse = true })

-- Screenshot
local screenShot = hl.dsp.exec_cmd 'grim -g "$(slurp)" -t ppm - | satty --filename -'
hl.bind(mainMod .. 'P', screenShot)
hl.bind('Print', screenShot)
local screenRecord = hl.dsp.exec_cmd 'record-screen'
hl.bind(mainMod .. 'Print', screenRecord)

-- Laptop multimedia keys for volume and LCD brightness
local soundOptions = { locked = true, repeating = true }
hl.bind('XF86AudioLowerVolume', hl.dsp.exec_cmd 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%-', soundOptions)
hl.bind('F7', hl.dsp.exec_cmd 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%-', soundOptions)
hl.bind('XF86AudioRaiseVolume', hl.dsp.exec_cmd 'wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 3%+', soundOptions)
hl.bind('F8', hl.dsp.exec_cmd 'wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 3%+', soundOptions)
hl.bind('XF86AudioMute', hl.dsp.exec_cmd 'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle', soundOptions)
hl.bind('F9', hl.dsp.exec_cmd 'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle', soundOptions)
hl.bind('XF86AudioMicMute', hl.dsp.exec_cmd 'wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle', soundOptions)
-- hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
-- hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
-- hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
-- hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
-- hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
-- hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

----- Submaps -----

-- Wallpaper
hl.bind(mehMod .. 'E', hl.dsp.exec_cmd 'wofi-wallpaper-selector.sh')
hl.bind(mehMod .. 'W', hl.dsp.submap 'wallpaper')
hl.define_submap('wallpaper', function()
  local function set_wp(file) return hl.dsp.exec_cmd('hyprctl hyprpaper wallpaper ,' .. file) end

  hl.bind('E', set_wp '/home/stefan/Pictures/wallpaper/ef29_wallpaper_2_pc.png')
  hl.bind('D', set_wp '/home/stefan/Pictures/e6/28bf47c2383901e372940101003d9a03.png')
  hl.bind('R', hl.dsp.exec_cmd 'hyprpaper-random')
  hl.bind('plus', hl.dsp.exec_cmd 'hyprpaper-random p')
  hl.bind('minus', hl.dsp.exec_cmd 'hyprpaper-random m')
  hl.bind('S', set_wp '/home/stefan/Pictures/wallpaper/galaxy-cosmic-5376x3584-14974.jpg')

  hl.bind('F', function()
    hl.timer(
      function() hl.dispatch(hl.dsp.dpms { action = 'off', monitor = monitor_right }) end,
      { timeout = 100, type = 'oneshot' }
    )
    hl.timer(
      function() hl.dispatch(hl.dsp.dpms { action = 'on', monitor = monitor_right }) end,
      { timeout = 1000, type = 'oneshot' }
    )
  end)

  hl.bind('escape', hl.dsp.submap 'reset')
end)

-- Lock screen, etc
hl.bind(mainMod .. 'O', hl.dsp.submap 'lock')
hl.define_submap('lock', function()
  hl.bind('O', function()
    hl.timer(function()
      hl.dispatch(hl.dsp.submap 'reset')
      hl.dispatch(hl.dsp.dpms 'off')
      hl.dispatch(hl.dsp.exec_cmd 'swaylock')
    end, { timeout = 100, type = 'oneshot' })
  end, { release = true })
  hl.bind('X', function()
    hl.timer(function()
      hl.dispatch(hl.dsp.submap 'reset')
      hl.dispatch(hl.dsp.dpms 'off')
    end, { timeout = 100, type = 'oneshot' })
  end, { release = true })
  hl.bind('E', hl.dsp.exit())
  hl.bind('P', hl.dsp.exec_cmd 'poweroff')
  hl.bind('S', function()
    hl.dispatch(hl.dsp.submap 'reset')
    hl.dispatch(hl.dsp.exec_cmd 'systemctl suspend')
  end)
  --hl.bind("H", hl.dsp.exec_cmd("hyprctl dispatch submap reset && systemctl hibernate"))
  hl.bind('R', hl.dsp.exec_cmd 'reboot')

  hl.bind('catchall', hl.dsp.submap 'reset')
end)

-- Unbind all other keys
hl.bind(mehMod .. 'P', function()
  hl.config { cursor = { no_warps = false } }
  hl.dispatch(hl.dsp.submap 'no-binds')
end)
hl.define_submap('no-binds', function()
  hl.bind(mainMod .. 'tab', hl.dsp.focus { last = true })
  hl.bind(mainMod .. 'asciicircum', function()
    hl.dispatch(hl.dsp.workspace.move { workspace = 2, monitor = monitor_right })
    hl.dispatch(hl.dsp.focus { workspace = 2 })
  end)

  hl.bind('XF86AudioRaiseVolume', hl.dsp.exec_cmd 'wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 3%+', soundOptions)
  hl.bind('XF86AudioLowerVolume', hl.dsp.exec_cmd 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%-', soundOptions)
  hl.bind('F12', hl.dsp.exec_cmd 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%-', soundOptions)
  hl.bind('XF86AudioMute', hl.dsp.exec_cmd 'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle', soundOptions)
  hl.bind('XF86AudioMicMute', hl.dsp.exec_cmd 'wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle', soundOptions)

  hl.bind(mehMod .. 'P', function()
    hl.config { cursor = { no_warps = true } }
    hl.dispatch(hl.dsp.submap 'reset')
  end)
end)
--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Workspaces on fixed monitors with default apps
hl.workspace_rule { workspace = '2', monitor = monitor_right, on_created_empty = 'firefox' }
hl.workspace_rule { workspace = '7', monitor = monitor_right, on_created_empty = 'steam' }
hl.workspace_rule { workspace = '8', monitor = monitor_right, on_created_empty = 'thunderbird' }
hl.workspace_rule { workspace = '9', monitor = monitor_right, on_created_empty = 'keepassxc' }
hl.workspace_rule { workspace = '10', monitor = monitor_right }

-- Application specific settings
hl.window_rule { match = { class = '^steam$' }, workspace = '7', no_initial_focus = true, suppress_event = 'activatefocus' }
hl.window_rule { match = { title = '^Steam$' }, tile = true }
hl.window_rule {
  match = { class = [[steam_app_\d+|dota2|FTL.*|Hollow Knight Silksong]], float = false },
  workspace = '10',
  fullscreen = true,
}

hl.window_rule { match = { class = '^thunderbird$' }, workspace = '8', suppress_event = 'activatefocus' }

hl.window_rule {
  match = { class = '^org.keepassxc.KeePassXC$', title = 'negative:^Unlock.*' },
  workspace = '9',
  no_initial_focus = true,
  no_screen_share = true,
}
hl.window_rule { match = { initial_title = '^Unlock Database - KeePassXC$' }, stay_focused = true }

hl.window_rule { match = { class = '^firefox$' }, fullscreen_state = '0 -1' } -- full screen inside its own borders
hl.window_rule { match = { title = '^About Mozilla Firefox$' }, float = true }

-- Ignore maximize requests from all apps
hl.window_rule { name = 'suppress-maximize-events', match = { class = '.*' }, suppress_event = 'maximize' }

-- Fix some dragging issues with XWayland
hl.window_rule {
  name = 'fix-xwayland-drags',
  match = { class = '^$', title = '^$', xwayland = true, float = true, fullscreen = false, pin = false },
  no_focus = true,
}
