animals = {}
animalUnsaveables = {}
local animalCounts = {}
local animalTypes = {
	'deer',
}

local deer = require 'animal_deer'

function newAnimal(name, id, x, y)
	return animals[name](id, x, y)
end

function animals.getUnsaveables(animal)
	return getAnimalUnsaveables(animal)
end

getAnimalUnsaveables = function(animal)
	function animal.draw(self)
		love.graphics.rectangle('fill', math.floor(World:get('x')+(animal.worldX)), math.floor(World:get('y')+(animal.worldY)), animal.w, animal.h)
	end

	function animal.update(self, dt)

		--animal.x = animal.worldX/World:get('tileSize')
		--animal.y = animal.worldY/World:get('tileSize')


		-- moving
		if animal.worldX > animal.targetX*World:get('tileSize') then
			animal.worldX = animal.worldX - 1
		elseif animal.worldX < animal.targetX*World:get('tileSize') then
			animal.worldX = animal.worldX + 1
		end
		if animal.worldY > animal.targetY*World:get('tileSize') then
			animal.worldY = animal.worldY - 1
		elseif animal.worldY < animal.targetY*World:get('tileSize') then
			animal.worldY = animal.worldY + 1
		end

		-- random grazing
		if animal.grazingValue == globalTimer%50 then
			
			math.randomseed(os.time())
			animal.targetX = math.random(animal.x-5, animal.x+5)
			animal.targetY = math.random(animal.y-5, animal.y+5)

			animal.grazingValue = love.math.random(0, 15)
		end

		-- startling


	end
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