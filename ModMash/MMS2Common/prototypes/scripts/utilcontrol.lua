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
            game.players[index].print(mms2.convert_to_string(message))
    else
		for i = 1, #game.players do local p = game.players[i]
			p.print(mms2.convert_to_string(arg))
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
	if message == nil then message = {"mms2common.placement-disallowed"} end
	if entity.name == "entity-ghost" then etype = entity.ghost_prototype.type end
	if entity.name == "entity-ghost" then ename = entity.ghost_prototype.name end
	if ename == "rail-planner" or ename == "straight-rail" or ename == "curved-rail" then
		ename = "rail"
	end
	local stack = {name=ename, count=1}
	if entity.type == "entity-ghost" or entity.type == "tile-ghost" then
		--dont actually do anything entity destroyed later
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
	if direction == defines.direction.north then return local_get_entities_to_north(entity, type,wh) end
	if direction == defines.direction.northeast then return local_get_entities_to_northeast(entity, type,wh) end
	if direction == defines.direction.east then return local_get_entities_to_east(entity, type,wh) end
	if direction == defines.direction.southeast then return local_get_entities_to_southeast(entity, type,wh) end
	if direction == defines.direction.south then return local_get_entities_to_south(entity, type,wh) end
	if direction == defines.direction.southwest then return local_get_entities_to_southwest(entity, type,wh) end
	if direction == defines.direction.west then return local_get_entities_to_west(entity, type,wh) end
	if direction == defines.direction.northwest then return local_get_entities_to_northwest(entity, type,wh) end
	return {} 
    end

local local_transfer_fluid = function(from, findex, to, tindex, amount, max)
	if from == nil or to == nil then return end
    local from_boxes = from.fluidbox
    local from_box = from_boxes[findex]
    local to_boxes = to.fluidbox
    local to_box = to_boxes[tindex]
	if from_box == nil then return end
	if to_box == nil then
		if from_box.amount <= amount then

            from_boxes[findex] = nil
            to_boxes[tindex] = from_box
		else  				
			from_box.amount = from_box.amount - amount
            from_boxes[findex] = from_box

            from_box.amount = amount
            to_boxes[tindex] = from_box

        end
	else
		local tcap = to_boxes.get_capacity(tindex) - to_box.amount

        local tfer = math.min(tcap, math.min(from_box.amount, amount))
		if tfer <=0 then return end
        from_box.amount = math.max(from_box.amount - tfer,1)

        from_boxes[1] = from_box
        from_box.amount = to_box.amount + tfer
        to_boxes[tindex] = from_box

    end
	end
local local_transfer_fluid_and_convert = function(from, findex, to, tindex, amount, max, totype, temp)
	if from == nil or to == nil then return end
    local from_boxes = from.fluidbox
    local from_box = from_boxes[findex]
    local to_boxes = to.fluidbox
    local to_box = to_boxes[tindex]
	if temp == nil then temp = game.fluid_prototypes[totype] end
    local fluid_prototype = game.fluid_prototypes[totype]
	if from_box == nil then return end
	if to_box == nil then 
		if from_box.amount <= amount then
            from_boxes[findex] = nil					
			if local_is_int(temp) then from_box.temperature = temp end
            from_box.name = totype
            to_boxes[tindex] = from_box					
		else		
            from_box.amount = from_box.amount - amount
            from_boxes[findex] = from_box
            from_box.amount = amount					
			if local_is_int(temp) then from_box.temperature = temp end
            from_box.name = totype
            to_boxes[tindex] = from_box
        end
	else

        local tcap = to_boxes.get_capacity(tindex) - to_box.amount
        local tfer = math.min(tcap, math.min(from_box.amount, amount))
		if tfer <=0 then return end
        from_box.amount = math.max(from_box.amount - tfer, 1)
        from_boxes[1] = from_box
        from_box.amount = to_box.amount + tfer
		if local_is_int(temp) then from_box.temperature = temp end
        from_box.name = totype
        to_boxes[tindex] = from_box
    end
	end
local local_get_connected_input_fluid = function(entity, box)
    local call = function(e, b)
		if not e.fluidbox or b > #e.fluidbox then return nil end	
		local inpipe = e.fluidbox.get_connections(b)	
		if inpipe == nil then return nil end
		for i = 1, #inpipe do local ip = inpipe[i]	
			if ip ~= nil then			
				for j = 1, #ip do local jp = ip[j]
					if jp ~= nil and local_is_valid(ip.owner) and ip.owner.fluidbox ~= nil then
						for m = 1, #ip.owner.fluidbox do mp = ip.owner.fluidbox.get_connections(m)	
							if mp ~= nil then
								for mx = 1, #mp do mpx = mp[mx]
									if mpx.owner == e then
										return { entity = ip.owner, box = m}
                                    end
                                end
                            end
                        end

                    end
                end

            end
        end

    end
    local status, retval = pcall(call, entity, box)
	if status == true then return retval end
	end
local local_addable_fluid = function(entity, amount, index)
    local cap = 100
	if entity.fluidbox[index].get_capacity then
        cap = entity.fluidbox[index].get_capacity(index)
    end
    local avail = cap - entity.fluidbox[index].amount
	return math.min(avail, math.abs(amount)) 
	end
local local_removeable_fluid = function(fluid, amount) return math.min(fluid.amount, math.abs(amount)) end
local local_change_fluidbox_fluid = function(entity, amount, pollution)
    local delta = 0
    local used = 0
    local abs_amount = math.abs(amount)
    if entity.fluidbox ~= nil then
		for i = 1, #entity.fluidbox do	
			local fluid = entity.fluidbox[i]
			if fluid ~= nil and fluid.amount > 0 then
                local innerDelta = 0
				if amount< 0 then
                    innerDelta = local_removeable_fluid(fluid, amount)
                    fluid.amount = fluid.amount-innerDelta
					if fluid.amount <= 0 then
                        entity.fluidbox[i] = nil			
					else
                        entity.fluidbox[i] = fluid
                    end
				else
                    innerDelta = local_addable_fluid(entity, amount, i)
                    fluid.amount = fluid.amount - innerDelta
					if fluid.amount <= 0 then
                        entity.fluidbox[i] = nil			
					else
                        entity.fluidbox[i] = fluid
                    end
                end
                used = used + innerDelta 
				if pollution ~= nil and fluid.name ~= "water" then
					entity.surface.pollute(entity.position,pollution)
                end
				if used >= amount then
					if(amount< 0) then return used* -1 end
					return used
                end
            end
        end
    end
	if(amount< 0) then return used* -1 end
	return used
	end
local local_clear_fluid_recipe = function(entity)
	local call = function(e)
		local sum = 0
		for i = 1, #e.fluidbox do local f = e.fluidbox[i]
			if f ~= nil then sum = sum + f.amount end
		end
		if sum == 0 then e.set_recipe(nil) end
	end
	if entity.get_recipe() == nil then return true end
	local status, retval = pcall(call,entity)
	if status == true then return end
	end

mms2.get_item = local_get_item
mms2.print = local_print
mms2.is_valid = local_is_valid
mms2.entity.is_valid_and_persistant = local_is_valid_and_persistant

mms2.entity.try_set_recipe = local_try_set_recipe

mms2.fail_place_entity = local_fail_place_entity

mms2.entity.get_entity_size = local_get_entity_size
mms2.entity.get_entities_to = local_get_entities_to
mms2.entity.get_entities_to_northwest = local_get_entities_to_northwest
mms2.entity.get_entities_to_norteast = local_get_entities_to_norteast
mms2.entity.get_entities_to_north = local_get_entities_to_north
mms2.entity.get_entities_to_east = local_get_entities_to_east
mms2.entity.get_entities_to_south = local_get_entities_to_south
mms2.entity.get_entities_to_west = local_get_entities_to_west
mms2.entity.get_entities_to_southeast = local_get_entities_to_southeast
mms2.entity.get_entities_to_southwest = local_get_entities_to_southwest

mms2.fluid.transfer_fluid = local_transfer_fluid
mms2.fluid.transfer_fluid_and_convert = local_transfer_fluid_and_convert
mms2.fluid.get_connected_input_fluid = local_get_connected_input_fluid
mms2.fluid.change_fluidbox_fluid = local_change_fluidbox_fluid
mms2.fluid.clear_fluid_recipe = local_clear_fluid_recipe
