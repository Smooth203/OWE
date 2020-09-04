local Items = require 'items'
message = {
	active = false,
	timer = 0,
	x = 0,
	y = 0
}

Ui = {
	get = function(self, p)
		if p == 'mouse' then
			return self.mouse
		elseif p == 'inv' then
			return self.inv, self.equipped
		end
	end,

	loadUnsaveables = function(self)
		self.inv = {}
		self.invSlotSize = 80
		self.mouse = {
			x = love.mouse.getX(),
			y = love.mouse.getY(),
			tileX = math.floor(((love.mouse.getX())-World:get('x'))/World:get('tileSize')),
			tileY = math.floor(((love.mouse.getY())-World:get('y'))/World:get('tileSize')),
			tile = {}
		}
	end,

	new = function(self)
		Ui:loadUnsaveables()
		--Inv & Equipped
		for i = 1, 5 do
			local slot = {
				location = 'inv',
				id = i,
				isEmpty = true,
				showOptions = false,
				item = {}
			}
			table.insert(self.inv, slot)
		end
		self.equipped = {
			location = 'equipped',
			isEmpty = true,
			showOptions = false,
			item = {}
		}
	end,

	load = function(self, inv, equipped)
		Ui:loadUnsaveables()
		self.inv = inv
		for i, slot in pairs(self.inv) do
			if slot.item.name then
				slot.item.img = love.graphics.newImage(slot.item.imgPath)
			end
		end
		self.equipped = equipped
		if self.equipped.item.name then
			self.equipped.item.img = love.graphics.newImage(self.equipped.item.imgPath)
		end
	end,

	draw = function(self)
		love.graphics.setColor(0.8, 0.8, 0.8, 1)
		love.graphics.rectangle('fill', (sw/2)-(self.invSlotSize*(#self.inv/2)), sh-self.invSlotSize, self.invSlotSize*(#self.inv), self.invSlotSize)

		for i, slot in pairs(self.inv) do
			local slotX, slotY = (sw/2)-(self.invSlotSize*(#self.inv/2))+((i-1)*self.invSlotSize), sh-self.invSlotSize
			love.graphics.setColor(0,0,0,1)
			love.graphics.rectangle('line', slotX, slotY, self.invSlotSize, self.invSlotSize)
			love.graphics.setColor(1,1,1,1)
			if slot.item.img then
				love.graphics.draw(slot.item.img, slotX, slotY)
			end
			if slot.item.quant then
				love.graphics.setColor(0,0,0,1)
				love.graphics.print(slot.item.quant, slotX, slotY)
				love.graphics.setColor(1,1,1,1)
			end
			if slot.showOptions then
				love.graphics.rectangle('fill', slotX, slotY-(self.invSlotSize/2), self.invSlotSize, self.invSlotSize/2)
				love.graphics.rectangle('fill', slotX, slotY-(self.invSlotSize/2)*2, self.invSlotSize, self.invSlotSize/2)
				love.graphics.rectangle('fill', slotX, slotY-(self.invSlotSize/2)*3, self.invSlotSize, self.invSlotSize/2)
				love.graphics.setColor(0,0,0,1)
				love.graphics.print('Drop', slotX, slotY-(self.invSlotSize/2))
				love.graphics.print('Use', slotX, slotY-(self.invSlotSize/2)*2)
				love.graphics.print('Equip', slotX, slotY-(self.invSlotSize/2)*3)
			end
		end

		--equipped
		love.graphics.setColor(0.8, 0.8, 0.8, 1)
		love.graphics.rectangle('fill', sw-self.invSlotSize, sh-self.invSlotSize, self.invSlotSize, self.invSlotSize)
		love.graphics.setColor(0,0,0,1)
		love.graphics.rectangle('line', sw-self.invSlotSize, sh-self.invSlotSize, self.invSlotSize, self.invSlotSize)
		love.graphics.setColor(1,1,1,1)
		if self.equipped.item.img then
			love.graphics.draw(self.equipped.item.img, sw-self.invSlotSize, sh-self.invSlotSize)
			love.graphics.setColor(0,0,0,1)
			love.graphics.print(self.equipped.item.quant, sw-self.invSlotSize, sh-self.invSlotSize)
			love.graphics.setColor(1,1,1,1)
		end
		if self.equipped.item.quant then
				love.graphics.setColor(0,0,0,1)
				love.graphics.print(self.equipped.item.quant, sw-self.invSlotSize, sh-self.invSlotSize)
				love.graphics.setColor(1,1,1,1)
			end
		if self.equipped.showOptions then
			love.graphics.rectangle('fill', sw-self.invSlotSize, sh-self.invSlotSize-(self.invSlotSize/2), self.invSlotSize, self.invSlotSize/2)
			love.graphics.rectangle('fill', sw-self.invSlotSize, sh-self.invSlotSize-(self.invSlotSize/2)*2, self.invSlotSize, self.invSlotSize/2)
			love.graphics.rectangle('fill', sw-self.invSlotSize, sh-self.invSlotSize-(self.invSlotSize/2)*3, self.invSlotSize, self.invSlotSize/2)
			love.graphics.setColor(0,0,0,1)
			love.graphics.print('Drop', sw-self.invSlotSize, sh-self.invSlotSize-(self.invSlotSize/2))
			love.graphics.print('Use', sw-self.invSlotSize, sh-self.invSlotSize-(self.invSlotSize/2)*2)
			love.graphics.print('Un-Equip', sw-self.invSlotSize, sh-self.invSlotSize-(self.invSlotSize/2)*3)
		end

		if message.active then
			love.graphics.setColor(0,0,0,1)
			love.graphics.rectangle('fill', message.x, message.y, font:getWidth(message.text), font:getHeight(message.text))
			love.graphics.setColor(1,1,1,1)
			love.graphics.print(message.text, message.x, message.y)
		end		

		if paused then
			love.graphics.setColor(0.4,0.4,0.4,0.5)
			love.graphics.rectangle('fill', 0,0,sw,sh)
			love.graphics.setColor(1,1,1,1)
			love.graphics.rectangle('fill', (sw/2)-100, (sh/2)-50, 200, 100)
			love.graphics.setColor(0,0,0,1)
			love.graphics.setFont(titleFont)
			love.graphics.print('Save & Quit', ((sw/2)-titleFont:getWidth('Save & Quit')/2),((sh/2)-titleFont:getHeight('Save & Quit')/2))
			love.graphics.setFont(font)
		end

		if World:get('time').min < 10 then
			love.graphics.print(World:get('time').hour..":0"..math.floor(World:get('time').min), (sw/2)-(font:getWidth(World:get('time').hour..":0"..math.floor(World:get('time').min)))/2, 10)
		else
			love.graphics.print(World:get('time').hour..":"..math.floor(World:get('time').min), (sw/2)-(font:getWidth(World:get('time').hour..":0"..math.floor(World:get('time').min)))/2, 10)
		end

		love.graphics.setColor(1,1,1,1)

	end,

	update = function(self, dt)
		if not paused then
			Ui:updateMouse()

			--message
			if message.timer > 0 then
				message.timer = message.timer - dt
			else
				message.active = false
			end

		end
	end,

	slotsFilled = function(self)
		local count = 0
		for i, slot in ipairs(self.inv) do
			if slot.item.name then
				count = count + 1
			end
		end
		return count
	end,

	updateMouse = function(self)
		self.mouse.x, self.mouse.y = love.mouse.getPosition()
		self.mouse.tileX, self.mouse.tileY = math.floor(((self.mouse.x)-World:get('x'))/World:get('tileSize')), math.floor(((self.mouse.y)-World:get('y'))/World:get('tileSize'))
		self.mouse.tile = World:getTile(self.mouse.tileX, self.mouse.tileY)
	end,

	mousepressed = function(self, x, y, button)
		if button == 1 then
			if not paused then
				--Inv
				for i, slot in ipairs(self.inv) do
					local slotX, slotY = (sw/2)-(self.invSlotSize*(#self.inv/2))+((i-1)*self.invSlotSize), sh-self.invSlotSize
					if col(x,y,0,0, slotX, slotY, self.invSlotSize, self.invSlotSize) then
						--inv
						if slot.isEmpty == false then
							if slot.showOptions == true then
								slot.showOptions = false
							else
								for i, slot in pairs(self.inv) do
									slot.showOptions = false
								end
								slot.showOptions = true
							end
						end
					elseif col(x,y,0,0, slotX, slotY-(self.invSlotSize/2), self.invSlotSize, self.invSlotSize/2) and slot.showOptions == true then
						Ui:dropItem(slot)
						print('Dropped')
					elseif col(x,y,0,0, slotX, slotY-(self.invSlotSize/2)*2, self.invSlotSize, self.invSlotSize/2) and slot.showOptions == true then
						print('Used')
					elseif col(x,y,0,0, slotX, slotY-(self.invSlotSize/2)*3, self.invSlotSize, self.invSlotSize/2) and slot.showOptions == true then
						if slot.item.equip then
							Ui:swapItem(slot, self.equipped)
							print('Equipped')
						else
							Ui:Message('Cannot Equip ' .. slot.item.name, (sw/2)-(font:getWidth('Cannot Equip ' .. slot.item.name)/2), sh/2, 2)
							print('Not Equippable')
						end
						slot.showOptions = false
					end
				end
				--equip
				if col(x,y,0,0, sw-self.invSlotSize, sh-self.invSlotSize, self.invSlotSize, self.invSlotSize) then
					--EquippedOptions
					if self.equipped.showOptions == true then
						self.equipped.showOptions = false
					else
						self.equipped.showOptions = true
					end
				elseif col(x,y,0,0, sw-self.invSlotSize, sh-self.invSlotSize-(self.invSlotSize/2), self.invSlotSize, self.invSlotSize/2) and self.equipped.showOptions == true then
					Ui:dropItem(self.equipped)
					print('Dropped')
				elseif col(x,y,0,0, sw-self.invSlotSize, sh-self.invSlotSize-(self.invSlotSize/2)*2, self.invSlotSize, self.invSlotSize/2) and self.equipped.showOptions == true then
					print('Used')
				elseif col(x,y,0,0, sw-self.invSlotSize, sh-self.invSlotSize-(self.invSlotSize/2)*3, self.invSlotSize, self.invSlotSize/2) and self.equipped.showOptions == true then

					--Ui:swapItem(self.equipped, 'inv', string.lower(self.equipped.item.name))
					Ui:unequip()
					print('Un-Equipped')
				end
			else
				if col(x,y,0,0, (sw/2)-100,(sh/2)-50,200,100) then
					save()
					love.event.quit()
				end
			end
		elseif button == 2 then
			if not paused then
				for i, slot in ipairs(self.inv) do
					local slotX, slotY = (sw/2)-(self.invSlotSize*(#self.inv/2))+((i-1)*self.invSlotSize), sh-self.invSlotSize
					if col(x,y,0,0, slotX, slotY-(self.invSlotSize/2), self.invSlotSize, self.invSlotSize/2) and slot.showOptions == true then
						Ui:dropItem(slot, 1)
						slot.showOptions = false
					end
				end
			end
		end
	end,

	keypressed = function(self, key)
		if key == 'escape' then
			if paused then
				paused = false
			else
				paused = true
			end
		end
	end,

	addItem = function(self, Item, to, toSlot, fromFloor, quant)
		local item = getItemCopy(Item)
		local img = love.graphics.newImage(item.imgPath)
		local complete = false
		if to == 'inv' then
			if toSlot == nil then
				for i, slot in ipairs(self.inv) do
					if slot.isEmpty then
						slot.item = item
						slot.item.img = img
						if not fromFloor then
							if quant == nil then
								slot.item.quant = slot.item.quant + 1
							else
								slot.item.quant = quant
							end
						else
							slot.item.quant = quant
						end
						slot.isEmpty = false
						complete = true
						break
					elseif slot.item.name == item.name then
						if not fromFloor then
							if quant == nil then
								slot.item.quant = slot.item.quant + 1
							else
								slot.item.quant = slot.item.quant + quant
							end
						else
							slot.item.quant = slot.item.quant + quant
						end
						complete = true
						break
					end
				end
			else
				if item then
					if self.inv[toSlot].item.isEmpty then
						self.inv[toSlot].item = item
						self.inv[toSlot].item.img = img
						if not fromFloor then
							if quant == nil then
								 self.inv[toSlot].item.quant = self.inv[toSlot].item.quant + 1
							else
								self.inv[toSlot].item.quant = quant
							end
						else
							self.inv[toSlot].item.quant = quant
						end
						self.inv[toSlot].isEmpty = false
					else
						if not fromFloor then
							if quant == nil then
								self.inv[toSlot].item.quant = self.inv[toSlot].item.quant + 1
							else
								self.inv[toSlot].item.quant = self.inv[toSlot].item.quant + quant
							end
						else
							self.inv[toSlot].item.quant = self.inv[toSlot].item.quant + quant
						end
					end
				end
			end
		elseif to == 'equipped' then
			self.equipped.item = item
			self.equipped.item.img = img
			self.equipped.item.quant = quant
			complete = true
		end
		if complete then
			return true
		end
	end,

	destroyItem = function(self, slot)
		slot.item = {}
		slot.showOptions = false
		slot.isEmpty = true
	end,

	dropItem = function(self, slot, amount)
		if amount == nil then
			Entities:dropItem(string.lower(slot.item.name), Entities:getPlayer().x, Entities:getPlayer().y, slot.item.quant)
			Ui:destroyItem(slot)
		else
			Entities:dropItem(string.lower(slot.item.name), Entities:getPlayer().x, Entities:getPlayer().y, amount)
			slot.item.quant = slot.item.quant - amount
			if slot.item.quant == 0 then
				Ui:destroyItem(slot)
			end
		end
	end,

	swapItem = function(self, from, to, item)
		local tmp = to.item.name
		Ui:addItem(string.lower(from.item.name), to.location, nil, nil, from.item.quant)
		Ui:destroyItem(from)
		if tmp ~= nil then
			Ui:addItem(string.lower(tmp), 'inv')
		end
	end,

	unequip = function(self)
		Ui:addItem(string.lower(self.equipped.item.name), 'inv')
		Ui:destroyItem(self.equipped)
	end,

	Message = function(self, text, x, y, seconds)

		--reset
		message.active = false
		message.timer = 0
		message.x = 0
		message.y = 0

		--set
		message.text = text
		message.x = x
		message.y = y
		message.timer = seconds
		message.active = true
	end,
}