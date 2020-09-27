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

	math.randomseed(os.time()) -------------------------------------------THIS
	animal.grazingValue = math.random(0, 15)

	getAnimalUnsaveables(animal)

	return animal
end