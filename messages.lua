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

return setmetatable(messages, messages)
