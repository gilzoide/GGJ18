local block = require 'block'

local mic = {}

function mic.setup()
	rds = love.audio.getRecordingDevices()
	if not rds or #rds == 0 then return false end
	sound = {}
	sound.mic = rds[1]
	sound.mic:start(8000, 8000, 16, 1)
	sound.dt = 0
	return true
end

function mic.update(dt)
	if sound and not block.up then
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

return mic
