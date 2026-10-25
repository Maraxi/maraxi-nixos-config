-- Hyprland config for the NixOS desktop. Everything shared is in common.lua.
-- Environment variables are in ~/.config/uwsm/env-hyprland (user/hyprland-nixos.nix).

local common = require 'common'
local mainMod, mehMod = common.mainMod, common.mehMod

------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
local monitor_left = 'desc:Samsung Electric Company LS27D60xU HNAX501260'
local monitor_right = 'desc:Samsung Electric Company LS27D60xU HK2XA00058'
hl.monitor { output = monitor_left, mode = 'preferred', position = '0x0', scale = 'auto' }
hl.monitor { output = monitor_right, mode = 'preferred', position = '2560x0', scale = 'auto' }
hl.monitor { output = '', mode = 'preferred', position = 'auto', scale = 'auto' }

common.setup {
  lock_cmd = 'swaylock',
  autostart = { 'uwsm app -- hyprpaper' },
  wallpaper_binds = function()
    local function set_wp(file) return hl.dsp.exec_cmd('hyprctl hyprpaper wallpaper ,' .. file) end

    hl.bind('E', set_wp '/home/stefan/Pictures/wallpaper/ef29_wallpaper_2_pc.png')
    hl.bind('D', set_wp '/home/stefan/Pictures/e6/28bf47c2383901e372940101003d9a03.png')
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
  end,
}

---------------------
---- KEYBINDINGS ----
---------------------

hl.bind(mainMod .. 'asciicircum', function()
  hl.dispatch(hl.dsp.workspace.move { workspace = 2, monitor = monitor_right })
  hl.dispatch(hl.dsp.focus { workspace = 2 })
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

  common.bind_media_keys()

  hl.bind(mehMod .. 'P', function()
    hl.config { cursor = { no_warps = true } }
    hl.dispatch(hl.dsp.submap 'reset')
  end)
end)

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- Workspaces on fixed monitors with default apps
hl.workspace_rule { workspace = '2', monitor = monitor_right, on_created_empty = 'firefox' }
hl.workspace_rule { workspace = '7', monitor = monitor_right, on_created_empty = 'steam' }
hl.workspace_rule { workspace = '8', monitor = monitor_right, on_created_empty = 'thunderbird' }
hl.workspace_rule { workspace = '9', monitor = monitor_right, on_created_empty = 'keepassxc' }
hl.workspace_rule { workspace = '10', monitor = monitor_right }

hl.window_rule { match = { class = 'steam' }, workspace = '7', no_initial_focus = true, suppress_event = 'activatefocus' }
hl.window_rule {
  match = { initial_title = 'Steam', float = true },
  move = { 'monitor_w/2 - window_w/2', 'monitor_h/2 - window_h/2' },
}

local ok, games = pcall(require, 'games')
if not ok or type(games) ~= 'table' then games = { [[steam_app_\d+]] } end
hl.window_rule {
  match = { class = table.concat(games, '|'), float = false },
  workspace = '10',
  fullscreen = true,
}

hl.window_rule { match = { class = 'thunderbird' }, workspace = '8', suppress_event = 'activatefocus' }

hl.window_rule { match = { class = 'firefox' }, fullscreen_state = '0 -1' } -- full screen inside its own borders
hl.window_rule { match = { title = 'About Mozilla Firefox' }, float = true }
