local credits = {}

function credits.setup()
	credits.img = love.graphics.newImage("credits.png")
	credits.width, credits.height = credits.img:getDimensions()
end

function credits.draw()
	love.graphics.setColor(1,1,1)
	love.graphics.draw(credits.img, WIDTH/2, HEIGHT/2, nil, nil, nil,
			credits.width/2, credits.height/2)
end

return credits

