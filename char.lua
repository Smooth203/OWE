function newSpriteSheets(sex, body, shirt, pants, torso, legs)
	
	local spritesheets = {}

	pcall(function()
		spritesheets[1] = love.graphics.newImage('assets/player/'..sex..'/body/'..body..'.png') --body
	end)
	pcall(function()
		spritesheets[2] = love.graphics.newImage('assets/player/'..sex..'/clothes/torso_'..shirt..'.png') --shirt
	end)
	pcall(function()
		spritesheets[3] = love.graphics.newImage('assets/player/'..sex..'/clothes/legs_'..pants..'.png') --pants
	end)
	pcall(function()
		spritesheets[4] = love.graphics.newImage('assets/player/'..sex..'/armour/torso_'..torso..'.png') --torso
	end)
	pcall(function()
		spritesheets[5] = love.graphics.newImage('assets/player/'..sex..'/armour/legs_'..legs..'.png') --legs
	end)

	return spritesheets
end

function newChar(facing)

	local x,y
	if facing == 'down' then -- walking
		x,y = 0, 10
	elseif facing == 'left' then
		x,y = 0, 9
	elseif facing == 'up' then
		x,y = 0, 8
	elseif facing == 'right' then
		x,y = 0, 11
	elseif facing == 'downAttack' then -- attack
		x,y = 0, 14
	elseif facing == 'leftAttack' then
		x,y = 0, 13
	elseif facing == 'upAttack' then
		x,y = 0, 12
	elseif facing == 'rightAttack' then
		x,y = 0, 15
	end

	local char = {}

	for i = 0, 8 do
		char[i] = love.graphics.newQuad(i*(64), y*(64), 64, 64, 832, 1344)
	end

	return char
end