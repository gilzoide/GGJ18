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
