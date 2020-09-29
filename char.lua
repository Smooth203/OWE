function newSpriteSheets(sex, body)
    local spritesheets = {
        love.graphics.newImage('assets/player/body/'..sex..'/'..body..'.png'), --body
        --top
        --legs
        --etc all draw in this order
    }
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