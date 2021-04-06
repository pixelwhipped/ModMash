require("prototypes.scripts.defines") 
--[[create local references]]
--[[util]]

local is_valid  = modmashsplinterexplosivemining.util.is_valid
local starts_with  = modmashsplinterexplosivemining.util.starts_with
local print  = modmashsplinterexplosivemining.util.print
--[[
local local_init = function()	
	if global.modmashsplinterexplosivemining.grenade_targets == nil then global.modmashsplinterexplosivemining.grenade_targets = {} end	
	end

local local_check_resource = function()
	for i, v in ipairs(global.modmashsplinterexplosivemining.grenade_targets) do
		if (v.ticks > 400) or (not v.target.valid) then
			table.remove(global.modmashsplinterexplosivemining.grenade_targets, i)
		else
			v.ticks = v.ticks + 1
			local entities = v.target.surface.find_entities_filtered{area = {{v.target.position.x-0.5, v.target.position.y-0.5}, {v.target.position.x-1, v.target.position.y+1}}}
			for i, ent in pairs(entities) do
				if starts_with(ent.name,"small-scorchmark") then
					if is_valid(v.target) and game.item_prototypes[v.target.name] then
						v.target.surface.spill_item_stack(ent.position, {name=v.target.name, count=35})
						local r = v.target.amount - math.min(35,v.target.amount);
						if r == 0 then
							v.target.destroy()
						else
							v.target.amount = r
						end
					end
					ent.destroy()
					table.remove(global.modmashsplinterexplosivemining.grenade_targets, i)
					--break
				end
			end
		end
	end
end

local local_action_mining =function (event)
	player = game.players[event.player_index]
	if player ~= nil and player.cursor_stack.valid_for_read then
		if player.cursor_stack.name == "mining-explosive" or player.cursor_stack.name == "grenade" or player.cursor_stack.name == "cluster-grenade" then
			if grenade ~= nil and player.cursor_stack.count < grenade.count and player.selected ~= nil then
				if player.selected.type == "resource" and player.selected.name ~= "uranium-ore" then
					table.insert(global.modmashsplinterexplosivemining.grenade_targets,{target = player.selected,ticks = 0, grenage = {name = player.cursor_stack.name, count = player.cursor_stack.count}})
				end
			end
			grenade = {name = player.cursor_stack.name, count = player.cursor_stack.count}			
		end
	else
	
	if grenade~=nil and player.selected ~= nil then
			if player.selected.type == "resource" and player.selected.name ~= "uranium-ore" then
				table.insert(global.modmashsplinterexplosivemining.grenade_targets,{target = player.selected,ticks = 0, grenage = {name = grenade.name, count = grenade.count}})
			end
		end
		grenade = nil
	end
end--]]

local local_on_script_trigger_effect = function(event)
	if event.effect_id == "explosive-mining-explosion" and  event.target_position ~= nil then
		local surface = game.surfaces[event.surface_index]
		local entities = surface.find_entities_filtered{type={"resource"}, area = {{event.target_position.x-0.5, event.target_position.y-0.5}, {event.target_position.x+0.5, event.target_position.y+0.5}}}
		if #entities >0 then
			for k = 1, #entities do local ent = entities[k]
				if is_valid(ent) and game.item_prototypes[ent.name] and ent.name ~= "uranium-ore" then
					ent.surface.spill_item_stack(ent.position, {name=ent.name, count=35})
					local r = ent.amount - math.min(35,ent.amount);
					if r == 0 then
						ent.destroy()
					else
						ent.amount = r
					end
				end
				return
			end
		else
			local entities = surface.find_entities_filtered{area = {{event.target_position.x-0.5, event.target_position.y-0.5}, {event.target_position.x+0.5, event.target_position.y+0.5}}}
			for k = 1, #entities do local ent = entities[k]
				if is_valid(ent) then
					ent.die()--({raise_destroy = true})
				end
			end
			surface.set_tiles(			
				{
					{name="water",position={x=event.target_position.x-0.5,y=event.target_position.y-0.5}},
					{name="water",position={x=event.target_position.x-0.5,y=event.target_position.y}},
					{name="water",position={x=event.target_position.x-0.5,y=event.target_position.y+0.5}},
					{name="water",position={x=event.target_position.x,y=event.target_position.y-0.5}},
					{name="water",position={x=event.target_position.x,y=event.target_position.y}},
					{name="water",position={x=event.target_position.x,y=event.target_position.y+0.5}},
					{name="water",position={x=event.target_position.x+0.5,y=event.target_position.y-0.5}},
					{name="water",position={x=event.target_position.x+0.5,y=event.target_position.y}},
					{name="water",position={x=event.target_position.x+0.5,y=event.target_position.y+0.5}}
				}	
			)
		end
	end
end

script.on_event(defines.events.on_script_trigger_effect, local_on_script_trigger_effect)
--script.on_init(local_init)
--script.on_event(defines.events.on_tick, local_check_resource)
--script.on_event(defines.events.on_player_cursor_stack_changed,local_action_mining)