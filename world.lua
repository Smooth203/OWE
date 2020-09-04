local Noise = require 'noise'
local scale = 10

World = {
	get = function(self, p)
		if p == 'all' or p == nil then	
			local worldInfo = {
				{
					x = self.x,
					y = self.y,
					w = self.w,
					h = self.h,
					time = self.time,
					chunkSize = self.chunkSize
				},
				{
					tiles = self.world
				}
			}
			return worldInfo
		elseif p == 'x' then
			return self.x
		elseif p == 'y' then
			return self.y
		elseif p == 'w' then
			return self.w
		elseif p == 'h' then
			return self.h
		elseif p == 'tileSize' then
			return self.tileSize
		elseif p == 'tileset' then
			return self.tileset
		elseif p == 'batch' then
			return self.batch
		elseif p == 'map' then
			return self.map
		elseif p == 'time' then
			return self.time
		end
	end,

	load = function(self, world, info)
		self.x = info.x -- in terms of tiles
		self.y = info.y
		self.w = info.w
		self.h = info.h
		self.world = world
		self.time = info.time

		self.chunkSize = info.chunkSize
		
		self.active = true
		self.Textures = require 'textures'
		self.tileset = love.graphics.newImage('assets/terrain.png')
		self.batch = love.graphics.newSpriteBatch(self.tileset, self.w*self.h)
		self.map = love.graphics.newSpriteBatch(self.tileset, self.w*self.h)
		self.tileSize = 32
		--quads
		self.quads = {}
		for _, texture in pairs(textures) do
			local t = texture
			self.quads[t.value] = love.graphics.newQuad(t.x*self.tileSize, t.y*self.tileSize, self.tileSize, self.tileSize, self.tileset:getWidth(), self.tileset:getHeight())
		end
		World:updateWorld(true)
	end,

	new = function(self)
		self.active = true
		self.Textures = require 'textures'
		self.tileset = love.graphics.newImage('assets/terrain.png')
		self.tileSize = 32

		self.x = 0
		self.y = 0
		self.w = 500
		self.h = 500
		self.world = {}
		self.tileCount = 0

		self.chunkSize = 50

		self.time = {
			hour = 16,
			min = 58,
			speed = 1,
			colourScale = {
				value = 0,
				dir = 1,
				--c2 = {1,0.8,0.2,1},
				c2 = {0.98,0.84,0.65,1},
				c1 = {1,1,1,1}
			}
		}
		
		self.batch = love.graphics.newSpriteBatch(self.tileset, self.w*self.h)
		self.map = love.graphics.newSpriteBatch(self.tileset, self.w*self.h)

		--quads
		self.quads = {}
		for _, texture in pairs(textures) do
			local t = texture
			self.quads[t.value] = love.graphics.newQuad(t.x*self.tileSize, t.y*self.tileSize, self.tileSize, self.tileSize, self.tileset:getWidth(), self.tileset:getHeight())
		end
		--WORLD GEN
		for x = 0, self.w do
			for y = 0, self.h do
				distX =	math.abs(x-(self.w * 0.5)-0)
				distY = math.abs(y-(self.h * 0.5)-0)
				dist = math.sqrt((distX*distX) + (distY*distY)) -- circular
				maxW = self.w * 0.5 - 10
				delta = dist / maxW
				gradient = delta * delta

				self.world[x] = self.world[x] or {}
				xCoord = x/self.w * scale
				yCoord = y/self.h * scale
				zCoord = scale
				self.heightmap = love.math.noise(xCoord+love.timer.getTime(),yCoord+love.timer.getTime(),zCoord)* pickMax(0, 1-gradient)
				local tex = 1
				if self.heightmap <= 0.25 then
					tex = 4 -- set water
				elseif self.heightmap > 0.25 and self.heightmap <= 0.35 then
					tex = 5 -- beach
				end
				if tex ~= 4 then
					local rn = love.math.random(1,100)
					if self.heightmap > 0.35 then
						-- in grassland
						if rn == 1 then
							tex = 3 -- flowers
						elseif rn == 2 then
							tex = 6 -- small stone
						elseif rn == 3 or rn == 4 then
							tex = 2
						end
					elseif self.heightmap > 0.55 then
						--in inner land
						if rn == 1 then
							tex = 7 -- large stone
						end
					end
				end
				self.world[x][y] = {
					x = x,
					y = y,					
					texture = tex,
					heightmapValue = self.heightmap
				}
			end
		end
		World:updateWorld(true)
	end,

	draw = function(self)
		--love.graphics.draw(self.batch, math.floor(self.x), math.floor(self.y), 0,  1, 1)

		love.graphics.draw(self.batch, math.floor((((self.x/self.tileSize)%1))*self.tileSize), math.floor((((self.y/self.tileSize)%1))*self.tileSize), 0,  1, 1)
	end,

	update = function (self, dt)
		self.time.min = self.time.min + 0.5 * dt * self.time.speed
		if self.time.min >= 60 then
			self.time.min = 0
			self.time.hour = self.time.hour + 1
			self.time.colourScale.value = self.time.colourScale.value + self.time.colourScale.dir
			if self.time.hour >= 24 then
				self.time.hour = 0
			end
		end
		if self.time.hour >= 0 and self.time.hour < 12 then
			self.time.colourScale.dir = 1
		elseif self.time.hour >= 12 and self.time.hour < 24 then
		    self.time.colourScale.dir = -1
		end
	end,

	timeColour = function(self)
		local colour = {}

		if self.time.hour >= 17 and self.time.hour < 21 then
			if self.time.hour < 18 then
				for i,v in ipairs(self.time.colourScale.c1) do
					if v > self.time.colourScale.c2[i] then
						colour[i] = self.time.colourScale[i] - 1
					end
				end
			end
		else
			--colour = self.time.colourScale.c1
		end

		return table.unpack(colour)
	end,

	move = function(self, dx, dy)
		local oldX, oldY = self.x, self.y
		self.x = self.x + dx
		self.y = self.y + dy
		
		if math.floor(self.x) ~= math.floor(oldX) or math.floor(self.y) ~= math.floor(oldY) then
			World:updateWorld()
		end
	end,

	moveTo = function(self, x, y)
		self.x = x
		self.y = y
		World:updateWorld()
	end,

	getTile = function(self, tx, ty)
		for x = 0, self.w do
			if x == tx then
				for y = 0, self.h do
					if y == ty then
						if x >= 0 and y >= 0 then
							local tile = self.world[tx][ty]
							return tile
						end
					end
				end
			end
		end
		local tile = {x=-9999999,y=-9999999}
		return tile
	end,

	setTile = function(self, tx, ty, to)
		for x = 0, self.w do
			if x == tx then
				for y = 0, self.h do
					if y == ty then
						if x >= 0 and y >= 0 then
							self.world[tx][ty].texture = to
							World:updateWorld()
						end
					end
				end
			end
		end
	end,

	updateWorld = function(self, init)
		self.batch:clear()
		for x = -1, (sw/self.tileSize) do
			for y = -1, (sh/self.tileSize) do
				pcall(function()
					local mx,my = x-((self.x/self.tileSize)), y-((self.y/self.tileSize))
					local tile = self.world[math.floor(mx)+1][math.floor(my)+1]
					self.batch:add(self.quads[tile.texture], x*self.tileSize, y*self.tileSize)
				end)
			end
		end
		if init then
			for x = -1, self.w do
				for y = -1, self.h do
					pcall(function()
						local tile = self.world[x+1][y+1]
						self.map:add(self.quads[tile.texture], x*self.tileSize, y*self.tileSize)
						World:checkTiles(tile,0.25,0.35,4,5)
						World:checkTiles(tile,0.35,0.5,5,1)
					end)
				end
			end
		end

		self.batch:flush()
	end,

	checkTiles = function(self, tile, lBound, uBound, checkFor, setTo)
		local tile = tile
		local x,y = tile.x, tile.y
		if tile.heightmapValue > lBound and tile.heightmapValue <= uBound then
			if self.world[x][y-1].texture == checkFor then
				if self.world[x-1][y].texture == checkFor then
					tile.texture = tonumber(setTo .. '.1') --top left
				elseif self.world[x+1][y].texture == checkFor then
					tile.texture = tonumber(setTo .. '.7') -- top right
				else
					tile.texture = tonumber(setTo .. '.4') -- top middle
				end
			elseif self.world[x][y+1].texture == checkFor then
				if self.world[x-1][y].texture == checkFor then
					tile.texture = tonumber(setTo .. '.3') -- bottom left
				elseif self.world[x+1][y].texture == checkFor then
					tile.texture = tonumber(setTo .. '.9') -- bottom right
				else
					tile.texture = tonumber(setTo .. '.6') --bottom middle
				end
			elseif self.world[x-1][y].texture == checkFor then
				tile.texture = tonumber(setTo .. '.2') -- left
			elseif self.world[x+1][y].texture == checkFor then
				tile.texture = tonumber(setTo .. '.8') -- right
			else
				if self.world[x-1][y-1].texture == checkFor then
					tile.texture = tonumber(setTo .. '.04') -- inner top left
				elseif self.world[x-1][y+1].texture == checkFor then
					tile.texture = tonumber(setTo .. '.03') -- inner bottom left
				elseif self.world[x+1][y-1].texture == checkFor then
					tile.texture = tonumber(setTo .. '.02') -- inner top right
				elseif self.world[x+1][y+1].texture == checkFor then
					tile.texture = tonumber(setTo .. '.01') -- inner bottom right
				else
					tile.texture = setTo
				end
			end
		end
	end
}