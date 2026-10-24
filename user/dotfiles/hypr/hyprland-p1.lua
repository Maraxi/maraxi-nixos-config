-- Hyprland config for the ThinkPad P1 (Ubuntu + nix, started via uwsm). Everything shared is in common.lua.
-- Env for aquamarine / uwsm (AQ_DRM_DEVICES, Qt, Electron) is in ~/.config/uwsm/env-hyprland (user/hyprland-ubuntu.nix).
-- Hyprpaper, hypridle, hyprpolkitagent and dunst are handled by systemd user units (user/hyprland-ubuntu.nix),
-- only started inside Hyprland.

-- Remove after, just to hide warnings
-- local hl = {}

local common = require 'common'

------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
--
-- Monitors are matched by EDID description (desc:), not by port name: the port names (DP-3, DP-4, ...)
-- change with docks and replugging. A desc is "<make> <model> <serial>" as shown by `hyprctl monitors`.
-- Unknown monitors fall back to the catch-all rule at the end (auto position).
--
-- To use different monitors: add one more `desc:` line below (copy the description from `hyprctl monitors`).
-- If that gets tedious (many docks / locations), switch to profile based tools which apply a layout by
-- the set of connected monitors, e.g. kanshi or shikane (both work with Hyprland via wlr-output-management).
--
-- The two desc strings below were verified with `hyprctl monitors` (2x Samsung LS27D60xU; the ports
-- DP-3/DP-4 swap between boots, the serials do not).
-- Layout, left to right, all bottom aligned (the panel is 360px lower than the 1440px high externals):
--   eDP-1 (reference, x = 0, 1920x1080)  |  monitor_middle (2560x1440)  |  monitor_right (2560x1440)
local monitor_integrated = 'eDP-1'
local monitor_middle = 'desc:Samsung Electric Company LS27D60xU HNAX501260'
local monitor_right = 'desc:Samsung Electric Company LS27D60xU HK2XA00058'
-- Internal panel: 15.6" FHD (1920x1080), 'auto' would pick scale 1.5 which is far too large
hl.monitor { output = monitor_integrated, mode = 'preferred', position = '0x360', scale = 1 }
hl.monitor { output = monitor_middle, mode = 'preferred', position = '1920x0', scale = 'auto' }
hl.monitor { output = monitor_right, mode = 'preferred', position = '4480x0', scale = 'auto' }
-- Any other monitor
hl.monitor { output = '', mode = 'preferred', position = 'auto', scale = 'auto' }

common.setup {
  lock_cmd = 'lock-screen',
  autostart = { 'uwsm app -- intune-portal' },
  media_binds = {
    ['brightnessctl -e4 -n2 set 5%+'] = { keys = { 'XF86MonBrightnessUp' }, repeating = true },
    ['brightnessctl -e4 -n2 set 5%-'] = { keys = { 'XF86MonBrightnessDown' }, repeating = true },
  },
  -- wallpaper_binds: fixed wallpapers can be bound in the wallpaper submap, see hyprland-desktop.lua
  -- (hyprpaper-random uses ~/Pictures/e6/, which does not exist here yet)
}

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- Workspaces on fixed monitors with default apps (ignored while the monitor is not connected)
-- `default = true` is the workspace a monitor starts with at login, so the middle one gets 1 (not 3)
hl.workspace_rule { workspace = '1', monitor = monitor_middle, default = true }
hl.workspace_rule { workspace = '2', monitor = monitor_right, default = true, on_created_empty = 'microsoft-edge-stable' }
hl.workspace_rule { workspace = '9', monitor = monitor_integrated, on_created_empty = 'keepassxc' }
hl.workspace_rule { workspace = '10', monitor = monitor_integrated, default = true }

-- Zscaler Client Connector is a fixed size window (max size set by the app), so Hyprland floats it and
-- refuses to tile it. Dropping the size limit lets the float toggle work.
hl.window_rule { name = 'zscaler-tile', match = { class = 'ZSTray6' }, tile = true, no_max_size = true, workspace = 10 }
hl.window_rule { match = { class = 'Intune-portal' }, tile = true, workspace = 10 }

-- Browser "<site> is sharing your screen." bubble (Edge/Chrome, e.g. Teams): a small floating window
-- without class. waybar already shows active screen shares. Closing it also stops the share, so it is
-- hidden instead: it opens on the special workspace "sharing" (= i3's scratchpad), not shown ("silent").
-- Show it again with: hl.dsp.workspace.toggle_special('sharing')
-- The title is set at creation (initialTitle), so a static rule is enough.
hl.window_rule {
  name = 'screen-share-indicator',
  match = { title = '.* is sharing (your screen|a window).*' },
  workspace = 'special:sharing silent',
  border_size = 0,
  no_shadow = true,
  no_initial_focus = true,
}
