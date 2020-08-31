structures = {}

local tree = require 'tree'

function newStructure(id, name, x, y)
	return structures[name](id, x, y)
end

function structures.getUnsaveables(t, name)
	return getUnsaveables(t, name)
end