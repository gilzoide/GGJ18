local GOAL_RADIUS
local GOAL_Y = 50

local goal = {}
goal.points = 0

local function beginContact(a, b, coll)
	if a:getUserData() == "cesta" and b:getUserData() == "bolota" or
			a:getUserData() == "bolota" and b:getUserData() == "cesta" then
		goal.points = goal.points + 1
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

return goal
