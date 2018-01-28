--[[
-- Copyright 2018   Gil Barbosa Reis
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
-- 
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--]]

local block = require 'block'

local mic = {}

local sound
function mic.setup()
	rds = love.audio.getRecordingDevices()
	if not rds or #rds == 0 then
		love.window.showMessageBox(messages.micerror[1], messages.micerror[2], 'error')
		return
	end
	sound = {}
	sound.mic = rds[1]
	mic.toggle()
end

function mic.update(dt)
	if sound and mic.enabled and (not block.up) then
		sound.dt = sound.dt + dt
		if sound.dt > block.PUSH_DELAY then
			sound.dt = 0
			sound.data = sound.mic:getData() or sound.data
			local sum, size = 0, sound.data:getSampleCount()
			for i = 0, size - 1 do
				sum = sum + (sound.data:getSample(i) + 0)
			end
			block.push_height(math.abs(sum / size))
		end
	end
end

function mic.toggle()
	if sound then
		mic.enabled = not mic.enabled
		if mic.enabled then
			sound.mic:start(8000, 8000, 16, 1)
			sound.dt = 0
		else
			sound.mic:stop()
		end
	end
end

return mic
