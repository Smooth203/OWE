-- deer = {
-- 	new = function(self, id, x, y)
-- 		self.id = id
-- 		self.Type = 'animal'
-- 		self.name = 'deer'
-- 		self.maxHealth = 100
-- 		self.health = self.maxHealth
-- 		self.x = x
-- 		self.y = y
-- 		self.w = 32
-- 		self.h = 32
-- 		return self
-- 	end,

-- 	draw = function(self)
-- 		love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
-- 	end,
-- }

animalUnsaveables['deer'] = function(animal)
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
		if animal.grazingValue == globalTimer%15 then
			
			math.randomseed(os.time())
			animal.targetX = math.random(animal.x-5, animal.x+5)
			animal.targetY = math.random(animal.y-5, animal.y+5)

			animal.grazingTimer = love.math.random(0, 15)
		end

		-- startling


	end
end

animals['deer'] = function(id, x, y)
	animal = {}
	animal.id = id
	animal.Type = 'animal'
	animal.name = 'deer'
	animal.maxHealth = 100
	animal.health = animal.maxHealth
	animal.x = x -- tiles
	animal.y = y -- tiles
	animal.worldX = animal.x*World:get('tileSize')
	animal.worldY = animal.y*World:get('tileSize')
	animal.w = 32
	animal.h = 32

	animal.targetX = animal.x
	animal.targetY = animal.y

	animal.grazingValue = love.math.random(0, 15)

	animalUnsaveables['deer'](animal)

	return animal
end