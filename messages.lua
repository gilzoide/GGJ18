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

local RESIZE_SPEED = 2
local MAX_RESIZE = 4

local messages = {}

local pt = {
	title = "maTrACA ESSA BOLA",
	micerror = {
		"Erro",
		"Erro ao reconhecer o microfone.\nJogue usando o mouse/touch",
	},
	score = "Pontuação",
	keys = {
		"'C' Créditos",
		"'S' Splash GGJ",
		"'L' Translate to english" .. '\n' ..
		"'M' Ligar/desligar entrada pelo microfone",
		"'Q' Sair do jogo",
	},
}
local en = {
	title = "Shout that ball",
	micerror = {
		"Error",
		"Error setting microphone up.\nPlay with the mouse/touch",
	},
	score = "Score",
	keys = {
		"'C' Credits",
		"'S' Splash GGJ",
		"'L' Traduzir para o português" .. '\n' ..
		"'M' Toggle microphone input",
		"'Q' Quit the game",
	},
}

messages.__index = en
function messages.toggle()
	messages.__index = messages.__index == en and pt or en
end

function messages.setup()
	messages.font = love.graphics.newFont("font.ttf", 50)
	messages.txt = love.graphics.newText(messages.font, [[
 RAÇA CAASO!
XUPA FEDERAL!]])
end

local xupa_federupa
function messages.update(dt)
	if love.keyboard.isDown('x') then
		xupa_federupa = 'always'
		messages.dt = (messages.dt or 0) + dt
	else
		xupa_federupa = nil
		messages.dt = nil
	end
end

function messages.draw()
	if xupa_federupa then
		local w, h = messages.txt:getDimensions()
		local scale = (messages.dt * RESIZE_SPEED) % MAX_RESIZE
		love.graphics.setColor(1, 1, 0)
		love.graphics.draw(messages.txt, WIDTH/2, HEIGHT/2,
				nil, scale, scale, w/2, h/2)
	end
end

return setmetatable(messages, messages)
