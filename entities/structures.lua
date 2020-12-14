structures = {}

local tree = require 'entities/tree'

function newStructure(id, name, x, y)
	return structures[name](id, x, y)
end

function structures.getUnsaveables(t, name)
	return getUnsaveables(t, name)
end