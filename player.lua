local char = require 'char'

function player_getUnsaveables(player)

	player.img = love.graphics.newImage(player.imgPath)

	function player.save(self)
		local data = player
		return data
	end

	function player.draw(self)
		love.graphics.draw(player.canvas, player.x, player.y, 0, 1, 1, 32, 32)
		
		if col(Ui:get('mouse').x,Ui:get('mouse').y,0,0, player.x-100, player.y-100,200,200) then
			love.graphics.rectangle('line', (Ui:get('mouse').tile.x*32)+World:get('x'), (Ui:get('mouse').tile.y*32)+World:get('y'), 32, 32)
		end

		-- love.graphics.print(math.floor((player.x+player.img:getWidth()/2)-World:get('x'))..", "..math.floor((player.y+player.img:getHeight()/2)-World:get('y')), 10, 50)
		-- love.graphics.print(math.floor(((player.x+player.img:getWidth()/2)-World:get('x'))/World:get('tileSize'))..", "..math.floor(((player.y+player.img:getHeight()/2)-World:get('y'))/World:get('tileSize')), 10, 70)
	end

	function player.update(self, dt)
		player.move(dt)

		if player.stoppedX and player.stoppedY then
			player.state = 'idle'
			player.char = newChar('down')
		else
			player.state = 'walk'
		end

		player.worldX = player.x - World:get('x')*World:get('tileSize')
		player.worldY = player.y - World:get('y')*World:get('tileSize')
		player.screenX, player.screenY = player.x, player.y

		player.camAdjust(dt)

		--char
		local state = 0
		if player.state == 'idle' then
		elseif player.state == 'walk' then
		    ?>
		    
		end
		love.graphics.setCanvas(player.canvas)
			love.graphics.clear()
			love.graphics.draw(player.spritesheets[1], player.char[1], 0, 0)
		love.graphics.setCanvas()
		--World:getTile(math.floor((player.x-World:get('x'))/World:get('tileSize')), math.floor((player.y-World:get('y'))/World:get('tileSize')))
	end

	function player.mousepressed(self, x, y, button)
		if button == 1 then
			local tile = Ui:get('mouse').tile
			if col(Ui:get('mouse').x,Ui:get('mouse').y,0,0, player.x-100, player.y-100,200,200) then
				--Checks for structure at coords. If not, check the ground interactions
				local _, equipped = Ui:get('inv')
				if not Entities:action(x,y,button,equipped) then
					if tile.texture == 3 then
						if Ui:addItem('flower', 'inv') then
							World:setTile(tile.x, tile.y, 1)
						end
					elseif tile.texture == 6 then
						if Ui:addItem('rock', 'inv') then
							World:setTile(tile.x, tile.y, 1)
						end
					end
					print()
					print(tile.x, tile.y)
				end
			end
		end
	end

	function player.keypressed(self, key)
		if key == player.control.down then
			player.char = newChar('down')
		elseif key == player.control.left then
		    player.char = newChar('left')
		elseif key == player.control.up then
		    player.char = newChar('up')
		elseif key == player.control.right then
		    player.char = newChar('right')
		end
	end

	function player.camAdjust(dt)
		if player.stoppedX and player.stoppedY then
			player.timer = player.timer - dt
			if player.timer < 0 then
				if player.x > sw/2 then
					player.x = player.x - 50 * dt
					World:move(-50 * dt, 0)
				end
				if player.x < sw/2 then
					player.x = player.x + 50 * dt
					World:move(50 * dt, 0)
				end
				if player.y > sh/2 then
					player.y = player.y - 50 * dt
					World:move(0, -50 * dt)
				end
				if player.y < sh/2 then
					player.y = player.y + 50 * dt
					World:move(0, 50 * dt)
				end
				player.timer = 0
			end
		else
			player.timer = 100
		end
	end

	function player.move(dt)
		if player.x+player.img:getWidth() >= sw/3 and player.x <= sw -(sw /3) then
			if love.keyboard.isDown(player.control.left) then
				player.x = player.x - player.speed * dt
				player.r = math.pi
				player.stoppedX = false
			elseif love.keyboard.isDown(player.control.right) then
				player.x = player.x + player.speed * dt
				player.r = 0
				player.stoppedX = false
			else
				player.stoppedX = true
			end
		end
		if player.x+player.img:getWidth() > sw-(sw/3) then
			player.x = sw-(sw/3)-player.img:getHeight()
			World:move(-player.speed * dt, 0)
		elseif player.x < sw/3 then
			player.x = sw/3
			World:move(player.speed * dt, 0)
		end
			
		if player.y+player.img:getHeight() >= sh/3 and player.y <= sh-(sh/3) then
			if love.keyboard.isDown(player.control.up) then
				player.y = player.y - player.speed * dt
				player.r = 3*math.pi/2
				player.stoppedY = false
			elseif love.keyboard.isDown(player.control.down) then
				player.y = player.y + player.speed * dt
				player.r = math.pi/2
				player.stoppedY = false
			else
				player.stoppedY = true
			end
		end
		if player.y+player.img:getHeight() > sh-(sh/3) then
			player.y = sh-(sh/3)-player.img:getHeight()
			World:move(0, -player.speed * dt)
		elseif player.y < sh/3 then
			player.y = sh/3
			World:move(0, player.speed * dt)
		end
	end
end


function newPlayer(name, x, y, control, imgPath)

	if control == 'wasd' then
		up = 'w'
		left = 'a'
		down = 's'
		right = 'd'
	elseif control == 'arrow' then
		up = 'up'
		left = 'left'
		down = 'down'
		right = 'right'
	end

	local tmpTiles = {}
	while not canSpawn do
		for mx = 0, World:get('w') do
			for my = 0, World:get('h') do
				if World:getTile(mx,my).texture ~= 4 then
					local tile = {x = mx, y = my}
					table.insert(tmpTiles, tile)
					canSpawn = true
				end
			end
		end
	end
	local rn = love.math.random(1, #tmpTiles)
	for i, tile in pairs(tmpTiles) do
		if i == rn then
			posx = tile.x
			posy = tile.y
		end
	end

	local player = {
		id = love.timer.getTime(),
		Type = 'player',
		name = name,
		x = x,
		y = y,
		w = 64,
		h = 64,
		speed = 100,
		control = {
			up = up,
			left = left,
			down = down,
			right = right
		},
		imgPath = imgPath,
		spritesheets = newSpriteSheets('male' ,'light'),
		state = 'idle',
		r = 0,
		timer = 100
	}
	player.char = newChar('down')
	player.canvas = love.graphics.newCanvas(player.w, player.h)
	player.worldX = player.x - World:get('x')*World:get('tileSize')
	player.worldY = player.y - World:get('y')*World:get('tileSize')

	player_getUnsaveables(player)
	World:moveTo(-posx*World:get('tileSize'), -posy*World:get('tileSize'))

	return player
end