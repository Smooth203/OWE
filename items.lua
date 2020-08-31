items = {
	-- example = {
	-- 	name = 'Example',
	-- 	imgPath = 'assets/example.png',
	-- 	equip = {
	-- 		dmgMultiplier = 1,
	-- 		attackMultiplier = 1
	-- 	}
	-- },
	flower = {
		name = 'Flower',
		imgPath = 'assets/flower.png',
		quant = 0,
		equip = {
			dmgMultiplier = 1,
			attackMultiplier = 1
		}
	},
	wood = {
		name = 'Wood',
		imgPath = 'assets/wood.png',
		quant = 0,
	},
	stick = {
		name = 'Stick',
		imgPath = 'assets/stick.png',
		quant = 0,
		equip = {
			dmgMultiplier = 1,
			attackMultiplier = 1.15
		}
	},
	rock = {
		name = 'Rock',
		imgPath = 'assets/rock.png',
		quant = 0,
		equip = {
			dmgMultiplier = 2,
			attackMultiplier = 2
		}
	},
}

function getItemCopy(item)
	local copy = {}
	for i,v in pairs(items[item]) do
		copy[i] = v
	end
	return copy
end

function newItem(item, x, y, Quant)
	local itemData = items[item]
	local Item = {

		load = function(self)
			self.Type = 'item'
			self.collect = false
			self.id = love.timer.getTime()
			self.x = x
			self.y = y
			self.data = itemData
			self.quant = Quant
			self.data.img = love.graphics.newImage(self.data.imgPath)
			self.w = self.data.img:getWidth()
			self.h = self.data.img:getHeight()
			self.tile = World:getTile(math.floor(((x)-World:get('x'))/World:get('tileSize')),math.floor(((y)-World:get('y'))/World:get('tileSize')))
			self.collisions = {
				inRadius = false
			}
		end,

		draw = function(self)
			love.graphics.draw(self.data.img, self.x, self.y, 0, 0.25, 0.25)
			if self.collisions.inRadius then
				love.graphics.rectangle('fill', self.x-20, self.y-30, 80, 25)
				love.graphics.setColor(0,0,0,1)
				love.graphics.print("Pick Up: 'E'", self.x-12.5, self.y-30)
				love.graphics.setColor(1,1,1,1)
			end
			love.graphics.print(self.quant, self.x, self.y)
		end,

		update = function(self,dt)
			if self.collect then
				--print(math.abs(self.x-Entities:getPlayer().x)*500)
				local x,y = Entities:getPlayer().x-self.x, Entities:getPlayer().y-self.y
				local dist = math.sqrt( (x*x) + (y*y) )
				--local cosAngle = ((dist*dist)+(c*c)-(a*a))/(2*dist*c)

				local angle = math.atan2(y, x)

				if dist > 5 then
					self.x = self.x + math.cos(angle) * dt * 500 / (dist/10)
					self.y = self.y + math.sin(angle) * dt * 500 / (dist/10)
				elseif dist <= 5 then
					self.x = Entities:getPlayer().x
					self.y = Entities:getPlayer().y
				end

				-- if self.x > Entities:getPlayer().x+3 then
				-- 	self.x = self.x - 5 * dt / math.abs(self.x-Entities:getPlayer().x)*500
				-- elseif self.x < Entities:getPlayer().x-3 then
				-- 	self.x = self.x + 5 * dt / math.abs(self.x-Entities:getPlayer().x)*500
				-- else
				-- 	self.x = Entities:getPlayer().x
				-- end
				-- if self.y > Entities:getPlayer().y+3 then
				-- 	self.y = self.y - 5 * dt / math.abs(self.y-Entities:getPlayer().y)*500
				-- elseif self.y < Entities:getPlayer().y-3 then
				-- 	self.y = self.y + 5 * dt / math.abs(self.y-Entities:getPlayer().y)*500
				-- else
				-- 	self.y = Entities:getPlayer().y
				-- end
				if self.x == Entities:getPlayer().x and self.y == Entities:getPlayer().y then
					Ui:addItem(string.lower(self.data.name), 'inv', nil, true, self.quant)
					self.collect = true
					Entities:removeEntity(self.id)
				end
			else
				self.x, self.y = math.floor((World:get('x')+(self.tile.x*World:get('tileSize')))), math.floor(World:get('y')+(self.tile.y*World:get('tileSize')))
			end
		end,

		keypressed = function(self,key)
			if key == 'e' and self.collisions.inRadius then
				self.collect = true
			end
		end,

		collision = function(self,with)
			--within pickup radius
			if col(self.x-World:get('tileSize'),self.y-World:get('tileSize'),3*World:get('tileSize'),3*World:get('tileSize'), with.x,with.y,with.w,with.h) then
				self.collisions.inRadius = true
			else
				self.collisions.inRadius = false
			end
		end,
	}
	Item:load()
	return Item
end