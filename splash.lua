local splash = {}

function splash.setup()
	splash.img = love.graphics.newImage("splashscreen.jpg")
	splash.width, splash.height = splash.img:getDimensions()
end

function splash.draw()
	love.graphics.setColor(1,1,1)
	love.graphics.draw(splash.img, WIDTH/2, HEIGHT/2, nil, nil, nil,
			splash.width/2, splash.height/2)
end

return splash
