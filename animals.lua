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
	return animalUnsaveables[name](animal)
end

function updateAnimals()
	if globalTimer%10 == 0 then -- if multiple of 10 then x%10 = 0
		for i, animalType in ipairs(animalTypes) do
			if not animalCounts[animalType] then
				animalCounts[animalType] = 0
			end
		end

		for i, animalType in ipairs(animalTypes) do
			for i = 0, 10 do
				if animalCounts[animalType] < 15 then
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
end