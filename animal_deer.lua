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
		love.graphics.rectangle('fill', animal.x, animal.y, animal.w, animal.h)
	end
end

animals['deer'] = function(id, x, y)
	animal = {}
	animal.id = id
	animal.Type = 'animal'
	animal.name = 'deer'
	animal.maxHealth = 100
	animal.health = animal.maxHealth
	animal.x = x
	animal.y = y
	animal.w = 32
	animal.h = 32

	animalUnsaveables['deer'](animal)

	return animal
end