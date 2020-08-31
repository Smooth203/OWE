require 'TSerial'

function save()

	print('SAVING..')
	--local inv, equipped = Ui:get('inv')

	local saveDataRaw = {
		Entities:get(), -- index:1
		World:get()[1], -- info like x,y etc index:2
		Ui:get('inv'), -- inv etc index:3&4 (inv&equip)
	}
	local saveData = TSerial.pack(saveDataRaw, 0, true)
	local file = io.open('save/save.txt', 'w')
	file:write(saveData)
	io.close(file)

	local worldDataRaw = {
		World:get()[2] -- tiles
	}
	--local worldData = TSerial.pack(worldDataRaw, 0, true)
	local tCount = #worldDataRaw[1].tiles
	local datas = {
		{},
		{},
		{},
		{},
		{}
	}
	for i, tile in ipairs(worldDataRaw[1].tiles) do
		if i > 0 and i <= (tCount/5) then
			table.insert(datas[1], tile)
		elseif i > (tCount/5) and i <= 2*(tCount/5) then
			table.insert(datas[2], tile)
		elseif i > 2*(tCount/5) and i <= (tCount/5)*3 then
			table.insert(datas[3], tile)
		elseif i > (tCount/5)*3 and i <= (tCount/5)*4 then
			table.insert(datas[4], tile)
		elseif i > (tCount/5)*4 and i <= (tCount/5)*5 then
			table.insert(datas[5], tile)
		end
	end
	for i, data in ipairs(datas) do
		worldData = TSerial.pack(data, 0, true)
		local file = io.open('save/world'..i..'.txt', 'w')
		file:write(worldData)
		io.close(file)
	end
	print('SAVED!')
end

loadGame = function()
	print('LOADING..')
	--get world tile data
	local world = {}
	for i = 1, 5 do
		local file = io.open('save/world'..i..'.txt', 'r')
		local rawWorldData = TSerial.unpack(file:read("*all"), true)
		io.close(file)
		for i, tile in ipairs(rawWorldData) do
			table.insert(world, tile)
		end
	end
	--get entities, inv&equipped, and world info
	local file = io.open('save/save.txt', 'r')
	local rawData = TSerial.unpack(file:read("*all"), true)
	io.close(file)

	World:load(world, rawData[2])
	Entities:load(rawData[1])
	Ui:load(rawData[3], rawData[4])

	rawWorldData = nil
	rawData = nil
	
	print('LOADED!')
end