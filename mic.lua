local RECORD_DT = 0.05
local BLOCK_HEIGHT = 1000

local mic = {}

newBlock = 0
function mic.setup()
	rds = assert(love.audio.getRecordingDevices())
	sound = {}
	sound.mic = rds[1]
	sound.mic:start(8000, 8000, 8, 1)
	sound.dt = 0
	return true
end

function mic.update(dt)
	sound.dt = sound.dt + dt
	if sound.dt > RECORD_DT then
		sound.dt = 0
		sound.data = sound.mic:getData() or sound.data
		local sum, size = 0, sound.data:getSampleCount()
		for i = 0, size - 1 do
			sum = sum + (sound.data:getSample(i) + 0)
		end
		 newBlock = math.abs(sum / size) * BLOCK_HEIGHT
		for i = #alturas, 2, -1 do
			alturas[i] = alturas[i - 1]
		end
		alturas[1] = math.min(newBlock, HEIGHT)
	end
end

return mic
