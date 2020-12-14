local buttonTexts = {
	'New',
	'Load',
	'Settings'
}
local buttonFuncs = {
	newGame,
	loadGame,
	settingsMenu,
}
local buttonStates = {
	'game',
	'game',
	'settings',
}

Menu = {

	load = function(self)
		--Main
		self.buttons = {}
		self.buttonsW, self.buttonsH = 300, 50
		self.buttonsX, self.buttonsY = (sw/2)-(self.buttonsW/2), (sh/2)-(self.buttonsH*3)
		for i = 1, 3 do
			local button = {
				x = self.buttonsX,
				y = self.buttonsY + i*self.buttonsH*2,
				w = self.buttonsW,
				h = self.buttonsH,
				text = buttonTexts[i],
				func = buttonFuncs[i],
				state = buttonStates[i],
			}
			table.insert(self.buttons, button)
		end
	end,

	draw = function(self)
		love.graphics.setFont(titleFont)
		love.graphics.print('OWE3', (sw/2)-titleFont:getWidth('OWE3')/2, sh/8)
		for i, button in ipairs(self.buttons) do
			love.graphics.rectangle('fill', button.x, button.y, button.w, button.h)
			love.graphics.setColor(0,0,0,1)
			love.graphics.print(button.text, (button.x+button.w/2)-(titleFont:getWidth(button.text)/2), (button.y+button.h/2)-(titleFont:getHeight(button.text)/2))
			love.graphics.setColor(1,1,1,1)
		end
		love.graphics.setFont(font)
	end,

	update = function(self, dt)
		
	end,

	mousepressed = function(self, x, y, button)
		for i, button in ipairs(self.buttons) do
			if col(x,y,0,0, button.x,button.y,button.w,button.h) then
				local s,e = pcall(button.func)
				if s then
					gameState = button.state
				end
				print(s,e)
			end
		end
	end,

	keypressed = function(self, key)
		
	end,
}