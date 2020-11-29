require("defines")

local local_get_item = function(name)
    if name == nil then return nil end
    local items = game.item_prototypes 
    if items then
        return items[name]
    end
    return nil 
    end


local local_print = function(arg, index)
	if index ~= nil then
            game.players[index].print(modmashsplinter.convert_to_string(message))
    else
		for i = 1, #game.players do local p = game.players[i]
			p.print(modmashsplinter.convert_to_string(arg))
		end
    end
end

local local_is_valid = function(entity) return type(entity)=="table" and entity.valid end
local local_is_valid_and_persistant = function(entity)  return local_is_valid(entity) and not entity.to_be_deconstructed(entity.force) end


local local_try_set_recipe = function(entity, recipe)
    local call = function(e, f)
        e.set_recipe(f)
    end
    local status, retval = pcall(call, entity, recipe)
	if status == true then return end
    end


local local_fail_place_entity = function(entity,event,message)
	local etype = entity.type
	local ename = entity.name
	if message == nil then message = {"modmashsplinter.placement-disallowed"} end
	if entity.name == "entity-ghost" then etype = entity.ghost_prototype.type end
	if entity.name == "entity-ghost" then ename = entity.ghost_prototype.name end
	local stack = {name=ename, count=1}
	if entity.type == "entity-ghost" then
		--dont actuall do anything entity destroyed later
	elseif event ~= nil and event.player_index ~= nil then
		local player = game.get_player(event.player_index)
		local inv = player.get_inventory(defines.inventory.character_main)
		if inv and inv.can_insert(stack) then
			inv.insert(stack) 
		else
			entity.surface.spill_item_stack(entity.position, {name=entity.name, count=1})
			entity.order_deconstruction(entity.force, player)
		end
	elseif event ~= nil and event.robot ~= nil then
		entity.surface.spill_item_stack(entity.position, {name=entity.name, count=1})
		entity.order_deconstruction(entity.force, player)
	elseif event ~= nil then
		entity.surface.spill_item_stack(entity.position, {name=entity.name, count=1})
	end
	entity.surface.create_entity{name="flying-text", position = entity.position, text=message , color={r=1,g=0.25,b=0.5}}
	entity.destroy()
	end

local local_get_entity_size = function(entity)
	if entity == nil then return {1,1} end	
	if entity.prototype.selection_box ~= nil then
        local size = {
                entity.prototype.selection_box["right_bottom"]["x"] - entity.prototype.selection_box["left_top"]["x"],
                entity.prototype.selection_box["right_bottom"]["y"] - entity.prototype.selection_box["left_top"]["y"]}
		if entity.direction == 0 or entity.direction == 4 then return size end
		return { size[2],size[1]}
	end
	return {1,1} 
	end

local local_get_entities_to_northwest = function(entity, type, size)
    local wh = size or local_get_entity_size(entity)
	if wh == {0, 0} then wh = { 1, 1 } end
    local w,h = 0.5* wh[1], 0.5 * wh[2]
	if type ~= nil then return entity.surface.find_entities_filtered{area = {{entity.position.x-w, entity.position.y-(h+0.5)}, {entity.position.x-(w+0.5), entity.position.y-h}}, type = type} end
	return entity.surface.find_entities({{entity.position.x-w, entity.position.y-(h+0.5)}, {entity.position.x-(w+0.5), entity.position.y-h}}) 
    end

local local_get_entities_to_northeast = function(entity, type, size)
    local wh = size or local_get_entity_size(entity)
	if wh == {0, 0} then wh = { 1, 1 } end
    local w,h = 0.5* wh[1], 0.5 * wh[2]
	if type ~= nil then return entity.surface.find_entities_filtered{area = {{entity.position.x+w, entity.position.y-(h+0.5)}, {entity.position.x+(w+0.5), entity.position.y-h}}, type = type} end
	return entity.surface.find_entities({{entity.position.x+w, entity.position.y-(h+0.5)}, {entity.position.x+(w+0.5), entity.position.y-h}}) 
    end

local local_get_entities_to_north = function(entity, type, size)
    local wh = size or local_get_entity_size(entity)
    local w,h = (0.5 * wh[1]) - 0.2, 0.5 * wh[2]
	if type ~= nil then return entity.surface.find_entities_filtered{area = {{entity.position.x-w, entity.position.y-(h+0.5)}, {entity.position.x+w, entity.position.y-h}}, type = type} end
	return entity.surface.find_entities({{entity.position.x-w, entity.position.y-(h+0.5)}, {entity.position.x+w, entity.position.y-h}})
    end

local local_get_entities_to_south = function(entity, type, size)
    local wh = size or local_get_entity_size(entity)
    local w,h = (0.5 * wh[1]) - 0.2, 0.5 * wh[2]
	if type ~= nil then return entity.surface.find_entities_filtered{area = {{entity.position.x-w, entity.position.y+h}, {entity.position.x+w, entity.position.y+h+(0.5)}}, type = type} end
	return entity.surface.find_entities({{entity.position.x-w, entity.position.y+h}, {entity.position.x+w, entity.position.y+h+(0.5)}}) 
    end

local local_get_entities_to_east = function(entity, type, size)
    local wh = size or local_get_entity_size(entity)
    local w,h = 0.5 * wh[1], (0.5 * wh[2]) - 0.2
	if type ~= nil then return entity.surface.find_entities_filtered{area = {{entity.position.x+w, entity.position.y-h}, {entity.position.x+(w+0.5), entity.position.y+h}}, type = type} end
	return entity.surface.find_entities({{entity.position.x+w, entity.position.y-h}, {entity.position.x+(w+0.5), entity.position.y+h}}) 
    end

local local_get_entities_to_west = function(entity, type, size)
    local wh = size or local_get_entity_size(entity)
    local w,h = 0.5 * wh[1], (0.5 * wh[2]) - 0.2
	if type ~= nil then return entity.surface.find_entities_filtered{area = {{entity.position.x-(w+0.5), entity.position.y-h}, {entity.position.x-w, entity.position.y+h}}, type = type} end
	return entity.surface.find_entities({{entity.position.x-(w+0.5), entity.position.y-h}, {entity.position.x-w, entity.position.y+h}}) 
    end

local local_get_entities_to_southeast = function(entity, type, size)
    local wh = size or local_get_entity_size(entity)
    local w,h  = 0.5 * wh[1], 0.5 * wh[2]
	if type ~= nil then return entity.surface.find_entities_filtered{area = {{entity.position.x+w, entity.position.y-h}, {entity.position.x+(w+0.5), entity.position.y+(h+0.5)}}, type = type} end
	return entity.surface.find_entities({{entity.position.x+w, entity.position.y-h}, {entity.position.x+(w+0.5), entity.position.y+(h+0.5)}}) 
    end

local local_get_entities_to_southwest = function(entity, type, size)
    local wh = size or local_get_entity_size(entity)
    local w,h = 0.5 * wh[1], 0.5 * wh[2]
	if type ~= nil then return entity.surface.find_entities_filtered{area = {{entity.position.x-w, entity.position.y-h}, {entity.position.x-(w+0.5), entity.position.y+(h+0.5)}}, type = type} end
	return entity.surface.find_entities({{entity.position.x-w, entity.position.y-h}, {entity.position.x-(w+0.5), entity.position.y+(h+0.5)}})
    end

local local_get_entities_to = function(direction, entity, type, size)
    local wh = size or local_get_entity_size(entity)
	if d == defines.direction.north then return local_get_entities_to_north(entity, type,wh) end
	if d == defines.direction.northeast then return local_get_entities_to_northeast(entity, type,wh) end
	if d == defines.direction.east then return local_get_entities_to_east(entity, type,wh) end
	if d == defines.direction.southeast then return local_get_entities_to_southeast(entity, type,wh) end
	if d == defines.direction.south then return local_get_entities_to_south(entity, type,wh) end
	if d == defines.direction.southwest then return local_get_entities_to_southwest(entity, type,wh) end
	if d == defines.direction.west then return local_get_entities_to_west(entity, type,wh) end
	if d == defines.direction.northwest then return local_get_entities_to_northwest(entity, type,wh) end
	return {} 
    end

modmashsplinter.get_item = local_get_item
modmashsplinter.print = local_print
modmashsplinter.is_valid = local_is_valid
modmashsplinter.entity.is_valid_and_persistant = local_is_valid_and_persistant

modmashsplinter.entity.try_set_recipe = local_try_set_recipe

modmashsplinter.fail_place_entity = local_fail_place_entity

modmashsplinter.entity.get_entity_size = local_get_entity_size
modmashsplinter.entity.get_entities_to = local_get_entities_to
modmashsplinter.entity.get_entities_to_northwest = local_get_entities_to_northwest
modmashsplinter.entity.get_entities_to_norteast = local_get_entities_to_norteast
modmashsplinter.entity.get_entities_to_north = local_get_entities_to_north
modmashsplinter.entity.get_entities_to_east = local_get_entities_to_east
modmashsplinter.entity.get_entities_to_south = local_get_entities_to_south
modmashsplinter.entity.get_entities_to_west = local_get_entities_to_west
modmashsplinter.entity.get_entities_to_southeast = local_get_entities_to_southeast
modmashsplinter.entity.get_entities_to_southwest = local_get_entities_to_southwest