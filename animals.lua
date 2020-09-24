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
		animalCounts = {}

		for i, animalType in ipairs(animalTypes) do
			if animalCounts[animalType] then
				for i, e in ipairs(Entities:get()) do
					if e.Type == 'animal' then
						animalCounts[e.name] = animalCounts[e.name] + 1
					end
				end
			else
				animalCounts[animalType] = 0
			end
		end

		for i, animalType in ipairs(animalTypes) do
			for i = 0, 10 do
				if animalCounts[animalType] <= 5 then
					Entities:addEntity(newAnimal(animalType, love.timer.getTime(), math.random(200, 400), math.random(200, 400)))
					animalCounts[animalType] = animalCounts[animalType] + 1
					print(animalType..' +1')
				end
			end
		end
	end
end