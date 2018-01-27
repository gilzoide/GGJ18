local VELOCIDADE = 10
local NUM_BLOCKS = 9
local CHAO, RAIO_BOLA
local ALTURA_CHAO = 50
local WIDTH, HEIGHT = 650, 650

local function respawn()
	objects.ball.body:setPosition(WIDTH/2, HEIGHT/2)
	objects.ball.body:setLinearVelocity(0, 0)
end

function love.load()

	love.physics.setMeter(64)
	world = love.physics.newWorld(0, 9.81*64, true)

	objects = {} -- table to hold all our physical objects

	--let's create the ground
	objects.ground = {}
	objects.ground.body = love.physics.newBody(world, WIDTH/2, HEIGHT - ALTURA_CHAO/2) --remember, the shape (the rectangle we create next) anchors to the body from its center, so we have to move it to (650/2, 650-50/2)
	objects.ground.shape = love.physics.newRectangleShape(WIDTH, ALTURA_CHAO) --make a rectangle with a width of 650 and a height of 50
	objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape); --attach shape to body
	CHAO = objects.ground.body:getY() - ALTURA_CHAO/2
	
	--let's create a ball
	objects.ball = {}
	objects.ball.img = love.graphics.newImage("bolota.png")
	RAIO_BOLA = objects.ball.img:getWidth() / 2
	objects.ball.body = love.physics.newBody(world, WIDTH/2, HEIGHT/2, "dynamic")
	objects.ball.shape = love.physics.newCircleShape(RAIO_BOLA)
	objects.ball.fixture = love.physics.newFixture(objects.ball.body, objects.ball.shape, 1) -- Attach fixture to body and give it a density of 1.
	objects.ball.fixture:setRestitution(0.5)

	--let's create a couple blocks to play around with
	objects.blocks = {}
	for i = 1, NUM_BLOCKS do
		local obj = {}
		obj.body = love.physics.newBody(world, i * 55, CHAO, "kinematic")
		obj.shape = love.physics.newRectangleShape(0, 0, 50, 10)
		obj.fixture = love.physics.newFixture(obj.body, obj.shape, 1)
		objects.blocks[i] = obj
	end
	alturas = {}
	for i = 1, NUM_BLOCKS do
		alturas[i] = 0
	end

	--initial graphics setup
	love.graphics.setBackgroundColor(104, 136, 248) --set the background color to a nice blue
	love.window.setMode(WIDTH, HEIGHT) --set the window dimensions to 650 by 650
end
 
local frame = 0
function love.update(dt)
	world:update(dt) --this puts the world into motion
	
	-- checa se bola saiu da tela
	do
		local x, y = objects.ball.body:getPosition()
		if x < 0 or x > WIDTH or y < 0 or y > HEIGHT then
			respawn()
		end
	end
	
	-- mexe blocos para altura desejada
	for i, obj in ipairs(objects.blocks) do
		local y = obj.body:getY()
		local altura = alturas[i]
		obj.body:setLinearVelocity(0, (CHAO - altura - y) * VELOCIDADE)
	end 

	-- RESET de debug
	if love.keyboard.isDown("up") then
		respawn()
	end
	
	-- Update das alturas
	for i = 1, NUM_BLOCKS do
		if love.keyboard.isDown(tostring(i)) then
			alturas[i] = alturas[i] + VELOCIDADE
		end
		alturas[i] = alturas[i] < 0 and 0 or alturas[i] - VELOCIDADE/2
	end
end
 
function love.draw()
	love.graphics.setColor(72/255, 160/255, 14/255)
	love.graphics.polygon("fill", objects.ground.body:getWorldPoints(objects.ground.shape:getPoints()))

	love.graphics.setColor(1,1,1)
	love.graphics.draw(objects.ball.img, objects.ball.body:getX(), objects.ball.body:getY(), nil, nil, nil, RAIO_BOLA, RAIO_BOLA)

	love.graphics.setColor(0.2, 0.2, 0.2)
	for i = 1, NUM_BLOCKS do
		local obj = objects.blocks[i]
		love.graphics.polygon("fill", obj.body:getWorldPoints(obj.shape:getPoints()))
		love.graphics.points(obj.body:getX(), CHAO - alturas[i])
	end
end