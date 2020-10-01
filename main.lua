io.stdout:setvbuf("no") -- live console for ST3

newGame = function()
	World:new()
	Entities:new()
	Ui:new()
	World:updateWorld()
end

require('conf')
require 'saveload'
require 'world'
require 'entities'
require 'ui'
require 'menu'
gameState = 'menu'
paused = 0

profileDebug = false

function love.load()

	if profileDebug then
		love.profiler = require('profile') 
  		love.profiler.start()
  		love.frame = 0
  	end

  	--global timer dec -- counts down 100 seconds then repeats
	globalTimerMax = 100
  	globalTimerFloat = globalTimerMax
  	globalTimer = math.floor(globalTimerFloat)

	sw, sh = love.graphics.getDimensions()
	titleFont = love.graphics.newFont(25)
	font = love.graphics.newFont(12)
	math.randomseed(os.time())

	if gameState == 'menu' then
		Menu:load()
	end
end

function love.draw()
	love.graphics.setDefaultFilter('nearest', 'nearest')
	love.graphics.setFont(font)
	if gameState == 'game' then

		World:draw()
		Entities:draw()
		
		-- love.graphics.setColor(World:timeColour())
		-- love.graphics.rectangle('fill', 0, 0, sw, sh)
		-- love.graphics.setColor(1,1,1,1)
		
		Ui:draw()
	else
		Menu:draw()
	end

	love.graphics.print("FPS: "..love.timer.getFPS(), 10, 20)

	if profileDebug then
		print(love.report or "Please wait...")
	end
end

function love.update(dt)
	sw, sh = love.graphics.getDimensions()
	if gameState == 'game' then
		Ui:update(dt)
		if paused == 0 then
			World:update(dt)
			Entities:update(dt)
			
			--global timer
			globalTimerFloat = globalTimerFloat - 10 * dt
			if globalTimerFloat < 0 then
				globalTimerFloat = globalTimerMax
			end
			globalTimer = math.floor(globalTimerFloat)

		end
	else
		Menu:update(dt)
	end

	if profileDebug then
		love.frame = love.frame + 1
		  if love.frame%100 == 0 then
		    love.report = love.profiler.report(20)
		    love.profiler.reset()
		  end
	end


end

function love.mousepressed(x,y,button)
	if gameState == 'game' then
		Ui:mousepressed(x,y,button)
		if paused == 0 then
			Entities:mousepressed(x,y,button)
		end
	else
		Menu:mousepressed(x,y,button)
	end
end

function love.keypressed(key)
	if gameState == 'game' then
		Ui:keypressed(key)
		if paused == 0 then
			Entities:keypressed(key)
			if key == 'f5' then
				save()
			end
		end
	else
		Menu:keypressed(key)
	end
end

function love.keyreleased(key)
	if gameState == 'game' then
		--Ui:keyreleased(key)
		if paused == 0 then
			Entities:keyreleased(key)
			if key == 'f5' then
				save()
			end
		end
	else
	--	Menu:keyreleased(key)
	end
end

-- custom funcs
function col(x1,y1,w1,h1, x2,y2,w2,h2)
	if x1 < x2+w2 and x2 < x1+w1 and y1 < y2+h2 and y2 < y1+h1 then
		return true
	else
		return false
	end
end

function tlen(table)
	local count = 0
	for _ in pairs(table) do count = count + 1 end
	return count
end

function pickMax(a, b)
	if a > b then
		return a
	else
		return b
	end
end