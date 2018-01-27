local RECORD_DT = 0.1
local BLOCK_HEIGHT = 650

local mic = {}

function mic.setup()
	rds = assert(love.audio.getRecordingDevices())
	sound = {}
	sound.mic = rds[1]
	sound.mic:start(8000, 8000, 16, 1)
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
		local newBlock = math.abs(sum / size) * BLOCK_HEIGHT
		for i = #alturas, 2, -1 do
			alturas[i] = alturas[i - 1]
			-- io.write(i, ' ', alturas[i], ' ')
		end
		-- io.write('1 ', newBlock, '\n')
		alturas[1] = newBlock
	end
end

return mic
