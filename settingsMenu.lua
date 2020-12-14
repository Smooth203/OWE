local buttons = {}
local buttonTexts = {
	'Fullscreen',
	'Borderless Fullscreen',
	'Back'
}

function saveFS(bool)
	local file = io.open('save/FS_settings.txt', 'w')
	file:write(bool)
	io.close(file)
end

local buttonFuncs = {
	function()
		love.mouse.setPosition(sw/2, sh/2)
		if love.window.getFullscreen() == true then
			love.window.setFullscreen(false)
			saveFS('false')
		else
			love.window.setFullscreen(true)
			saveFS('true')
		end
		love.event.quit('restart')
	end,
	function()
		love.mouse.setPosition(sw/2, sh/2)
		if love.window.getFullscreen() == true then
			love.window.setFullscreen(false)
			saveFS('false2')
		else
			love.window.setFullscreen(true, 'desktop')
			saveFS('true2')
		end
		love.event.quit('restart')
	end,
	function() love.event.quit('restart') end,
}
local buttonStates = {
	'game',
	'game',
	'settings',
}

function settingsLoad()
	buttonsW, buttonsH = 300, 50
	buttonsX, buttonsY = (sw/2)-(buttonsW/2), (sh/2)-(buttonsH*3)
	for i = 1, 3 do
		local button = {
			x = buttonsX,
			y = buttonsY + i*buttonsH*2,
			w = buttonsW,
			h = buttonsH,
			text = buttonTexts[i],
			func = buttonFuncs[i],
			state = buttonStates[i],
		}
		table.insert(buttons, button)
	end	
end

function settingsDraw()
	love.graphics.setFont(titleFont)
	love.graphics.print('OWE3', (sw/2)-titleFont:getWidth('OWE3')/2, sh/8)
	for i, button in ipairs(buttons) do
		love.graphics.rectangle('fill', button.x, button.y, button.w, button.h)
		love.graphics.setColor(0,0,0,1)
		love.graphics.print(button.text, (button.x+button.w/2)-(titleFont:getWidth(button.text)/2), (button.y+button.h/2)-(titleFont:getHeight(button.text)/2))
		love.graphics.setColor(1,1,1,1)
	end
	love.graphics.setFont(font)
end

function settingsMousepressed(x,y,button)
	for i, button in ipairs(buttons) do
		if col(x,y,0,0, button.x,button.y,button.w,button.h) then
			local s,e = pcall(button.func)
			if s then
				gameState = button.state
			end
			print(s,e)
		end
	end
end