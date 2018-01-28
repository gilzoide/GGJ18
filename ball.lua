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

local BALL_RADIUS
local LIXO_POINTS = -50

local goal = require 'goal'

local ball = {}

-- Respawn the ball, maybe subtracting score from player.
local function respawn(subtract)
	ball.body:setPosition(BALL_RADIUS, BALL_RADIUS)
	ball.body:setLinearVelocity(0, 0)
	if subtract then
		goal.score = goal.score - 1
	end
end

function ball.setup()
	ball.img = love.graphics.newImage("bolota.png")
	BALL_RADIUS = ball.img:getWidth() / 2
	ball.body = love.physics.newBody(world, 0, 0, "dynamic")
	ball.shape = love.physics.newCircleShape(BALL_RADIUS)
	ball.fixture = love.physics.newFixture(ball.body, ball.shape, 1)
	ball.fixture:setRestitution(0.4)
	ball.fixture:setUserData("bolota")
	respawn()
end

function ball.update(dt)
	local x, y = ball.body:getPosition()
	if x < 0 or x > WIDTH or y < -2 * BALL_RADIUS then
		respawn(true)
		if goal.score == LIXO_POINTS then
			love.window.showMessageBox("Parabéns!", "Você é um lixo =D", "warning")
		end
	end
	
	-- RESET de debug
	if love.keyboard.isDown("backspace") then
		respawn()
	end
end

function ball.draw()
	love.graphics.setColor(1,1,1)
	love.graphics.draw(ball.img, ball.body:getX(), ball.body:getY(),
			ball.body:getAngle(), nil, nil, BALL_RADIUS, BALL_RADIUS)
end

return ball
