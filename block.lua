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

local BLOCK_RADIUS = 10
local BLOCK_SPACE = 8
local NUM_BLOCKS = math.ceil(WIDTH / (BLOCK_RADIUS + BLOCK_SPACE))
local SPEED = 2
local MOUSE_UP_FACTOR = 4
local BLOCK_Y_RANGE = love.system.getOS() == "Windows" and 999999 or 1500 -- HAHAHack
local PUSH_DELAY = 0.05

local block = {}

function block.setup()
	for i = 1, NUM_BLOCKS do
		local obj = {}
		obj.body = love.physics.newBody(world, (i - 1) * (BLOCK_RADIUS + BLOCK_SPACE) + BLOCK_RADIUS, FLOOR, "kinematic")
		obj.shape = love.physics.newCircleShape(BLOCK_RADIUS)
		obj.fixture = love.physics.newFixture(obj.body, obj.shape, 1)
		block[i] = obj
	end
	block.heights = {}
	for i = 1, NUM_BLOCKS do
		block.heights[i] = 0
	end

	block.PUSH_DELAY = PUSH_DELAY
	block.dt = 0
end

function block.update(dt)
	block.dt = block.dt + dt

	-- Move blocks to desired height
	for i, obj in ipairs(block) do
		local y = obj.body:getY()
		local block_height = block.heights[i]
		obj.body:setLinearVelocity(0, (FLOOR - block_height - y) * SPEED)
	end 
	
	-- Block heights update
	for i = 1, NUM_BLOCKS do
		block.heights[i] = block.heights[i] < 0 and 0 or block.heights[i] - SPEED/2
	end

	if love.mouse.isDown(1) then
		block.up = (block.up or 0) + dt
		block.push_height(block.up * MOUSE_UP_FACTOR)
	else
		block.up = false
	end

	-- Transmit energy
	if block.dt > block.PUSH_DELAY then
		block.dt = 0
		for i = #block.heights, 1, -1 do
			block.heights[i] = block.heights[i - 1] or 0
		end
		block.heights[0] = nil
	end
end

function block.draw()
	love.graphics.setColor(0.2, 0.2, 0.2)
	for i = 1, NUM_BLOCKS do
		local x, y = block[i].body:getPosition()
		love.graphics.circle("fill", x, y, BLOCK_RADIUS)
	end
end

function block.push_height(val)
	block.heights[0] = math.min(val * BLOCK_Y_RANGE, HEIGHT)
end

return block
