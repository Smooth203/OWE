animals = {}
animalUnsaveables = {}
local animalCounts = {}
local animalTypes = {
	'turkey',
}

local turkey = require 'entities/animals/turkey'

function newAnimal(name, id, x, y)
	return animals[name](id, x, y)
end

function animals.getUnsaveables(animal)
	return getAnimalUnsaveables(animal)
end

getAnimalUnsaveables = function(animal)

	animal.canvas = love.graphics.newCanvas(animal.w, animal.h)
	animal.spritesheet = love.graphics.newImage('assets/animals/' .. animal.name .. '.png')

	function animal.draw(self)
		love.graphics.rectangle('line', math.floor(World:get('x')+(animal.worldX)), math.floor(World:get('y')+(animal.worldY)), animal.w, animal.h)
		love.graphics.draw(animal.canvas, math.floor(World:get('x')+(animal.worldX)), math.floor(World:get('y')+(animal.worldY)), 0, 1, 1, 0, 0)
	end

	function animal.update(self, dt)

		animal.state = 'walk'
		animal.animSpeed = 0.02

		--anim
		animal.char = newAnimalChar(animal.facing)
		love.graphics.setCanvas(animal.canvas)

			love.graphics.clear()
			pcall(function()
				love.graphics.draw(animal.spritesheet, animal.activeChar, 0, 0)
			end)

		love.graphics.setCanvas()
		if animal.state == 'idle' then
			animal.activeChar = animal.char[math.floor(animal.animState)]
			animal.animState = animal.animState + 1 * animal.animSpeed
		    if animal.animState > 3 then
		    	animal.animState = 0
		    end
		elseif animal.state == 'walk' then
			--anim
		    animal.activeChar = animal.char[math.floor(animal.animState)]
		    animal.animState = animal.animState + 1 * animal.animSpeed
		    if animal.animState > 3 then
		    	animal.animState = 0
		    end
		end

		print(animal.animState)
		-- moving
		if animal.worldX > animal.targetX*World:get('tileSize') then
			animal.worldX = animal.worldX - 1
		elseif animal.worldX < animal.targetX*World:get('tileSize') then
			animal.worldX = animal.worldX + 1
		else
			animal.speed = 1
		end
		if animal.worldY > animal.targetY*World:get('tileSize') then
			animal.worldY = animal.worldY - 1
		elseif animal.worldY < animal.targetY*World:get('tileSize') then
			animal.worldY = animal.worldY + 1
		else
			animal.speed = 1
		end

		-- random grazing
		if animal.grazingValue == globalTimer then
			
			math.randomseed(os.time())
			animal.targetX = math.random(animal.x-10, animal.x+10)
			animal.targetY = math.random(animal.y-10, animal.y+10)

			animal.grazingValue = love.math.random(0, 105)
		end

		-- startling
		local player = Entities:getPlayer()
		if col(player.x-player.w/2,player.y-player.h/2,player.w,player.h, World:get('x')+animal.worldX-World:get('tileSize')*1,World:get('y')+animal.worldY-World:get('tileSize')*1,World:get('tileSize')*10,World:get('tileSize')*10) then
			
			math.randomseed(os.time())
			animal.targetX = math.random(animal.x-50, animal.x+50)
			animal.targetY = math.random(animal.y-50, animal.y+50)
			animal.speedM = 2
		end
	end
end

function newAnimalChar(facing)
	local x,y
	if facing == 'down' then -- walking
		x,y = 0, 2
	elseif facing == 'left' then
		x,y = 0, 1
	elseif facing == 'up' then
		x,y = 0, 0
	elseif facing == 'right' then
		x,y = 0, 3
	elseif facing == 'downI' then -- idle
		x,y = 0, 6
	elseif facing == 'leftI' then
		x,y = 0, 5
	elseif facing == 'upI' then
		x,y = 0, 4
	elseif facing == 'rightI' then
		x,y = 0, 7
	end

	local char = {}

	for i = 0, 3 do
		char[i] = love.graphics.newQuad(i*(128), y*(128), 128, 128, 512, 1024)
	end

	return char
end

function updateAnimals()

	if globalTimer == 0 then

		for i, animalType in ipairs(animalTypes) do
			if not animalCounts[animalType] then
				animalCounts[animalType] = 0
			end
		end

		for i, animalType in ipairs(animalTypes) do
			if animalCounts[animalType] < 99999 then
				math.randomseed(os.time())
				local spawnX = love.math.random(0, World:get('w'))
				math.randomseed(os.time()+1)
				local spawnY = love.math.random(0, World:get('h'))
				if World:getTile(spawnX, spawnY).texture ~= 4 and not col(math.floor(World:get('x')+(spawnX*World:get('tileSize'))), math.floor(World:get('y')+(spawnY*World:get('tileSize'))),World:get('w'),World:get('h'), 0,0,sw,sh) then
					
					Entities:addEntity(newAnimal(animalType, love.timer.getTime(), spawnX, spawnY), Entities:getPlayerIndex()-1)
					animalCounts[animalType] = animalCounts[animalType] + 1
				end
			end
		end

	end
end