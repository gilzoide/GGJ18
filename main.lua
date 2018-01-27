local SPEED = 1
local FLOOR, BALL_RADIUS
local FLOOR_HEIGHT = 50
local WIDTH, HEIGHT = 1024, 650
local BLOCK_WIDTH, BLOCK_HEIGHT = 15, 5
local BLOCK_SPACE = 5
local NUM_BLOCKS = math.floor(WIDTH / (BLOCK_WIDTH + BLOCK_SPACE))

local mic = require 'mic'

local function respawn()
	objects.ball.body:setPosition(BALL_RADIUS / 2, HEIGHT/2)
	objects.ball.body:setLinearVelocity(0, 0)
end

function love.load()

	love.physics.setMeter(64)
	world = love.physics.newWorld(0, 9.81*64, true)

	objects = {} -- table to hold all our physical objects

	--let's create the ground
	objects.ground = {}
	objects.ground.body = love.physics.newBody(world, WIDTH/2, HEIGHT - FLOOR_HEIGHT/2) --remember, the shape (the rectangle we create next) anchors to the body from its center, so we have to move it to (650/2, 650-50/2)
	objects.ground.shape = love.physics.newRectangleShape(WIDTH, FLOOR_HEIGHT) --make a rectangle with a width of 650 and a height of 50
	objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape); --attach shape to body
	FLOOR = objects.ground.body:getY() - FLOOR_HEIGHT/2
	
	--let's create a ball
	objects.ball = {}
	objects.ball.img = love.graphics.newImage("bolota.png")
	BALL_RADIUS = objects.ball.img:getWidth() / 2
	objects.ball.body = love.physics.newBody(world, 0, 0, "dynamic")
	objects.ball.shape = love.physics.newCircleShape(BALL_RADIUS)
	objects.ball.fixture = love.physics.newFixture(objects.ball.body, objects.ball.shape, 1) -- Attach fixture to body and give it a density of 1.
	objects.ball.fixture:setRestitution(0.5)
	respawn()

	--let's create a couple blocks to play around with
	objects.blocks = {}
	for i = 1, NUM_BLOCKS do
		local obj = {}
		obj.body = love.physics.newBody(world, (i - 1) * (BLOCK_WIDTH + BLOCK_SPACE), FLOOR, "kinematic")
		obj.shape = love.physics.newRectangleShape(0, 0, BLOCK_WIDTH, BLOCK_HEIGHT)
		-- obj.shape = love.physics.newCircleShape(BLOCK_WIDTH)
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

	--initial graphics setup
	love.graphics.setBackgroundColor(104, 136, 248) --set the background color to a nice blue
	love.window.setMode(WIDTH, HEIGHT) --set the window dimensions to 650 by 650
end
 
function love.update(dt)
	world:update(dt) --this puts the world into motion
	
	-- checa se bola saiu da tela
	do
		local x, y = objects.ball.body:getPosition()
		if x < 0 or x > WIDTH or y < 0 then
			respawn()
		end
	end
	
	-- mexe blocos para altura desejada
	for i, obj in ipairs(objects.blocks) do
		local y = obj.body:getY()
		local altura = alturas[i]
		obj.body:setLinearVelocity(0, (FLOOR - altura - y) * SPEED)
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
	love.graphics.setColor(72/255, 160/255, 14/255)
	love.graphics.polygon("fill", objects.ground.body:getWorldPoints(objects.ground.shape:getPoints()))

	love.graphics.setColor(1,1,1)
	love.graphics.draw(objects.ball.img, objects.ball.body:getX(), objects.ball.body:getY(),
			objects.ball.body:getAngle(), nil, nil, BALL_RADIUS, BALL_RADIUS)

	love.graphics.setColor(0.2, 0.2, 0.2)
	for i = 1, NUM_BLOCKS do
		local obj = objects.blocks[i]
		love.graphics.polygon("fill", obj.body:getWorldPoints(obj.shape:getPoints()))
		-- local x, y = obj.body:getPosition()
		-- love.graphics.circle("fill", x, y, BLOCK_WIDTH)
	end
end
