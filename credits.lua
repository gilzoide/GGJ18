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

