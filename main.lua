local SPEED = 2
local FLOOR, BALL_RADIUS
local FLOOR_HEIGHT = 50
WIDTH, HEIGHT = 1024, 700
local BLOCK_WIDTH, BLOCK_HEIGHT = 10, 5
local BLOCK_SPACE = 8
local WALL_WIDTH = 10
local NUM_BLOCKS = math.ceil(WIDTH / (BLOCK_WIDTH + BLOCK_SPACE))

local mic = require 'mic'
local goal = require 'goal'

local function respawn()
	objects.ball.body:setPosition(BALL_RADIUS / 2, BALL_RADIUS)
	objects.ball.body:setLinearVelocity(0, 0)
end

function love.load()
	love.physics.setMeter(64)
	world = love.physics.newWorld(0, 9.81*64, true)

	objects = {}

	-- Ground
	objects.ground = {}
	objects.ground.body = love.physics.newBody(world, WIDTH/2, HEIGHT - FLOOR_HEIGHT/2, 'static')
	objects.ground.shape = love.physics.newRectangleShape(WIDTH, FLOOR_HEIGHT)
	objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape)
	FLOOR = objects.ground.body:getY() - FLOOR_HEIGHT/2

	-- Walls
	objects.wall = {}
	objects.wall.body = love.physics.newBody(world, 0, HEIGHT/2, 'static')
	objects.wall.shape_left = love.physics.newRectangleShape(0, 0, WALL_WIDTH, HEIGHT)
	objects.wall.shape_right = love.physics.newRectangleShape(WIDTH, 0, WALL_WIDTH, HEIGHT)
	objects.wall.fixture_left = love.physics.newFixture(objects.wall.body, objects.wall.shape_left)
	objects.wall.fixture_right = love.physics.newFixture(objects.wall.body, objects.wall.shape_right)
	
	-- Ball
	objects.ball = {}
	objects.ball.img = love.graphics.newImage("bolota.png")
	BALL_RADIUS = objects.ball.img:getWidth() / 2
	objects.ball.body = love.physics.newBody(world, 0, 0, "dynamic")
	objects.ball.shape = love.physics.newCircleShape(BALL_RADIUS)
	objects.ball.fixture = love.physics.newFixture(objects.ball.body, objects.ball.shape, 1)
	objects.ball.fixture:setRestitution(0.5)
	objects.ball.fixture:setUserData("bolota")
	respawn()

	--let's create a couple blocks to play around with
	objects.blocks = {}
	for i = 1, NUM_BLOCKS do
		local obj = {}
		obj.body = love.physics.newBody(world, (i - 1) * (BLOCK_WIDTH + BLOCK_SPACE), FLOOR, "kinematic")
		-- obj.shape = love.physics.newRectangleShape(0, 0, BLOCK_WIDTH, BLOCK_HEIGHT)
		obj.shape = love.physics.newCircleShape(BLOCK_WIDTH)
		obj.fixture = love.physics.newFixture(obj.body, obj.shape, 1)
		objects.blocks[i] = obj
	end
	alturas = {}
	for i = 1, NUM_BLOCKS do
		alturas[i] = 0
	end

	if not mic.setup() then
		love.window.showMessageBox("Error", "Error setting microphone up!", 'error')
		love.event.quit(1)
	end
	goal.setup()

	--initial graphics setup
	love.graphics.setBackgroundColor(0.4, 0.7, 1) --set the background color to a nice blue
	love.window.setMode(WIDTH, HEIGHT) --set the window dimensions to 650 by 650
end
 
function love.update(dt)
	world:update(dt) --this puts the world into motion
	
	-- checa se bola saiu da tela
	do
		local x, y = objects.ball.body:getPosition()
		if x < 0 or x > WIDTH or y < -BALL_RADIUS then
			respawn()
			goal.points = goal.points - 1
			if goal.points == -1 then
				love.window.showMessageBox("Parabéns!", "Você é um lixo =D", "warning")
			end
		end
	end
	
	-- mexe blocos para altura desejada
	for i, obj in ipairs(objects.blocks) do
		local y = obj.body:getY()
		local block_height = alturas[i]
		obj.body:setLinearVelocity(0, (FLOOR - block_height - y) * SPEED)
	end 

	-- RESET de debug
	if love.keyboard.isDown("up") then
		respawn()
	end
	
	-- Block heights update
	for i = 1, NUM_BLOCKS do
		alturas[i] = alturas[i] < 0 and 0 or alturas[i] - SPEED/2
	end

	mic.update(dt)
end
 
function love.draw()
	love.graphics.setColor(0.4, 0.25, 0)
	love.graphics.polygon("fill", objects.wall.body:getWorldPoints(objects.wall.shape_left:getPoints()))
	love.graphics.polygon("fill", objects.wall.body:getWorldPoints(objects.wall.shape_right:getPoints()))

	love.graphics.setColor(0.28, 0.62, 0.05)
	love.graphics.polygon("fill", objects.ground.body:getWorldPoints(objects.ground.shape:getPoints()))

	goal.draw()

	love.graphics.setColor(1,1,1)
	love.graphics.draw(objects.ball.img, objects.ball.body:getX(), objects.ball.body:getY(),
			objects.ball.body:getAngle(), nil, nil, BALL_RADIUS, BALL_RADIUS)

	love.graphics.setColor(0.2, 0.2, 0.2)
	for i = 1, NUM_BLOCKS do
		local obj = objects.blocks[i]
		-- love.graphics.polygon("fill", obj.body:getWorldPoints(obj.shape:getPoints()))
		local x, y = obj.body:getPosition()
		love.graphics.circle("fill", x, y, BLOCK_WIDTH)
	end

	love.graphics.setColor(0,0,0)
	love.graphics.print(string.format('Points: %3d', goal.points),
			10, 10, nil, 2, 2)
end
