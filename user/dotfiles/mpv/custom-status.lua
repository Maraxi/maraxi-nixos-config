-- ~/.config/mpv/scripts/custom-status.lua

-- local utils = require("mp.utils")

-- Create a path to store your volume level in your mpv config folder
local volume_file = mp.command_native({ "expand-path", "~~/radio-volume.txt" })

-----------------------------------------
-- Part 1: Save & Restore Volume State
-----------------------------------------

-- 1. Restore the volume instantly when the player starts
local f = io.open(volume_file, "r")
if f then
	local saved_vol = f:read("*all")
	f:close()
	if saved_vol and tonumber(saved_vol) then
		mp.set_property_number("volume", tonumber(saved_vol))
	end
end

-- 2. Save the volume to the file whenever you exit mpv
mp.register_event("shutdown", function()
	local current_vol = mp.get_property_number("volume")
	if current_vol then
		local f = io.open(volume_file, "w")
		if f then
			f:write(tostring(current_vol))
			f:close()
		end
	end
end)

-----------------------------------------
-- Part 2: Custom Status Line Formatting
-----------------------------------------

local function update_status()
	local cache_dur = mp.get_property_number("demuxer-cache-duration", 0)
	local playback_time = mp.get_property_osd("playback-time") or "00:00:00"
	local has_video = mp.get_property_bool("video-dec", false)
	local prefix = has_video and "AV:" or "A:"

	local status = string.format("%s %s - Cache: %.1fs", prefix, playback_time, cache_dur)
	mp.set_property("term-status-msg", status)
end

mp.observe_property("playback-time", "none", update_status)
mp.observe_property("demuxer-cache-duration", "none", update_status)
