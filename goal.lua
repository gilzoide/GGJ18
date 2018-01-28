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

local GOAL_RADIUS
local GOAL_RANDOMPOS_DELAY = 5
local GOAL_Y = 70
local GOAL_Y_RANGE = 150

local goal = {}
goal.score = 0
goal.dt = 0

local function randPos()
	goal.body:setPosition(love.math.random(GOAL_RADIUS, WIDTH - GOAL_RADIUS),
			love.math.random(GOAL_RADIUS, GOAL_Y_RANGE))
end

local function beginContact(a, b, coll)
	if a:getUserData() == "cesta" and b:getUserData() == "bolota" or
			a:getUserData() == "bolota" and b:getUserData() == "cesta" then
		goal.score = goal.score + 1
	end
end

function goal.setup()
	goal.img = love.graphics.newImage("cesta.png")
	GOAL_RADIUS = goal.img:getWidth() / 2
	goal.body = love.physics.newBody(world, WIDTH/2, GOAL_Y, 'static')
	goal.shape = love.physics.newCircleShape(GOAL_RADIUS)
	goal.fixture = love.physics.newFixture(goal.body, goal.shape)
	goal.fixture:setSensor(true)
	goal.fixture:setUserData("cesta")

	world:setCallbacks(beginContact)
end

function goal.draw()
	love.graphics.setColor(1,1,1)
	love.graphics.draw(goal.img, goal.body:getX(), goal.body:getY(), nil, nil, nil,
			GOAL_RADIUS, GOAL_RADIUS)
end

function goal.update(dt)
	goal.dt = goal.dt + dt
	if goal.dt > GOAL_RANDOMPOS_DELAY then
		goal.dt = 0
		randPos()
	end
end

return goal
