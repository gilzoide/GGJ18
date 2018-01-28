local FLOOR_HEIGHT
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
	love.physics.setMeter(64)
	world = love.physics.newWorld(0, 9.81*64, true)

	ground = {}
	ground.img = love.graphics.newImage("ground.png")
	FLOOR_HEIGHT = ground.img:getHeight()
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
	if not mic.setup() then
		love.window.showMessageBox("Error", "Error setting microphone up.\nPlay with the mouse/touch", 'error')
	end
	goal.setup()
	credits.setup()
	splash.setup()

	runSceneFor(splash, SPLASH_DELAY)

	--initial graphics setup
	love.graphics.setBackgroundColor(0.4, 0.7, 1) --set the background color to a nice blue
	love.window.setMode(WIDTH, HEIGHT) --set the window dimensions to 650 by 650
end
 
function love.update(dt)
	world:update(dt)

	if love.keyboard.isDown('c') then
		runSceneFor(credits, CREDITS_DELAY)
	elseif love.keyboard.isDown('s') then
		runSceneFor(splash, SPLASH_DELAY)
	elseif love.keyboard.isDown('h') then
		print('TODO')
	elseif love.keyboard.isDown('q') then
		love.event.quit()
	end
	ball.update(dt)
	block.update(dt)
	mic.update(dt)
	goal.update(dt)
end
 
function love.draw()
	love.graphics.setColor(0.4, 0.25, 0)
	love.graphics.polygon("fill", wall.body:getWorldPoints(wall.shape_left:getPoints()))
	love.graphics.polygon("fill", wall.body:getWorldPoints(wall.shape_right:getPoints()))

	love.graphics.draw(ground.img, 0, ground.body:getY() - FLOOR_HEIGHT/2, nil, nil, nil)

	goal.draw()
	ball.draw()
	block.draw()

	love.graphics.setColor(0,0,0)
	love.graphics.print(string.format('Score: %3d', goal.score),
			10, 10, nil, 2, 2)
end

