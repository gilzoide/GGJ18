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

local FLOOR_HEIGHT = 70
WIDTH, HEIGHT = 1024, 700
local WALL_WIDTH = 10
local SPLASH_DELAY = 5
local CREDITS_DELAY = 7

local mic = require 'mic'
local goal = require 'goal'
local splash = require 'splash'
local block = require 'block'
local ball = require 'ball'
local credits = require 'credits'
local messages = require 'messages'

-- Run a scene that implements `draw` method for `seconds` seconds.
-- Clicking any key or mouse button will skip the scene and return to the previous one.
local function runSceneFor(scene, seconds)
	local update, draw, keypressed, mousepressed = love.update, love.draw, love.keypressed, love.mousepressed
	local _dt, _skip = 0, false
	love.draw = scene.draw
	love.update = function(dt)
		_dt = _dt + dt
		if _dt > seconds or _skip then
			love.update, love.draw, love.keypressed, love.mousepressed = update, draw, keypressed, mousepressed
		end
	end
	local function skip()
		_skip = true
	end
	love.keypressed, love.mousepressed = skip, skip
end

function love.load()
	font = love.graphics.newFont("font.ttf", 20)
	love.graphics.setFont(font)

	love.physics.setMeter(64)
	world = love.physics.newWorld(0, 9.81*64, true)

	ground = {}
	ground.body = love.physics.newBody(world, WIDTH/2, HEIGHT - FLOOR_HEIGHT/2, 'static')
	ground.shape = love.physics.newRectangleShape(WIDTH, FLOOR_HEIGHT)
	ground.fixture = love.physics.newFixture(ground.body, ground.shape)
	FLOOR = ground.body:getY() - FLOOR_HEIGHT/2

	-- Walls
	wall = {}
	wall.body = love.physics.newBody(world, 0, HEIGHT/2, 'static')
	wall.shape_left = love.physics.newRectangleShape(0, 0, WALL_WIDTH, HEIGHT)
	wall.shape_right = love.physics.newRectangleShape(WIDTH, 0, WALL_WIDTH, HEIGHT)
	wall.fixture_left = love.physics.newFixture(wall.body, wall.shape_left)
	wall.fixture_right = love.physics.newFixture(wall.body, wall.shape_right)
	
	ball.setup()
	block.setup()
	mic.setup()
	goal.setup()
	credits.setup()
	splash.setup()
	messages.setup()

	runSceneFor(splash, SPLASH_DELAY)

	--initial graphics setup
	love.graphics.setBackgroundColor(0.4, 0.7, 1) --set the background color to a nice blue
	love.window.setMode(WIDTH, HEIGHT) --set the window dimensions to 650 by 650
end
 
function love.update(dt)
	world:update(dt)

	ball.update(dt)
	block.update(dt)
	mic.update(dt)
	goal.update(dt)
	messages.update(dt)
end

function love.keypressed(key, scancode, isrepeat)
	if not isrepeat then
		if key == 'c' then
			runSceneFor(credits, CREDITS_DELAY)
		elseif key == 's' then
			runSceneFor(splash, SPLASH_DELAY)
		elseif key == 'l' then
			messages.toggle()
		elseif key == 'q' then
			love.event.quit()
		elseif key == 'm' then
			mic.toggle()
		end
	end
end
 
function love.draw()
	love.graphics.setColor(0.4, 0.25, 0)
	love.graphics.polygon("fill", wall.body:getWorldPoints(wall.shape_left:getPoints()))
	love.graphics.polygon("fill", wall.body:getWorldPoints(wall.shape_right:getPoints()))

	love.graphics.setColor(0.28, 0.62, 0.05)
	love.graphics.polygon("fill", ground.body:getWorldPoints(ground.shape:getPoints()))
	love.graphics.setColor(0,0,0)
	love.graphics.print(table.concat(messages.keys, '  |  '),
			0, ground.body:getY() - FLOOR_HEIGHT/4)

	love.graphics.setColor(0,0,0)
	love.graphics.print(string.format('%s: %3d', messages.score, goal.score),
			10, 10)

	goal.draw()
	ball.draw()
	block.draw()
	messages.draw()
end

