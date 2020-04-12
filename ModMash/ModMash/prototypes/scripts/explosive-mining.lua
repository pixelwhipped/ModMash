--[[dsync checking No Changes]]

--[[code reviewed 15.10.19]]
log("explosive-mining.lua")
--[[check and import utils]]
if modmash == nil or modmash.util == nil then require("prototypes.scripts.util") end

local is_valid  = modmash.util.is_valid

local local_init = function()	
	if global.modmash.grenade_targets == nil then global.modmash.grenade_targets = {} end	
	end

local local_check_resource = function()
	for i, v in ipairs(global.modmash.grenade_targets) do
		if (v.ticks > 400) or (not v.target.valid) then
			table.remove(global.modmash.grenade_targets, i)
		else
			v.ticks = v.ticks + 1
			local entities = v.target.surface.find_entities_filtered{area = {{v.target.position.x-0.5, v.target.position.y-0.5}, {v.target.position.x-1, v.target.position.y+1}}}
			for i, ent in pairs(entities) do
				if ent.name == "small-scorchmark" then
					if is_valid(v.target) and game.item_prototypes[v.target.name] then
						v.target.surface.spill_item_stack(ent.position, {name=v.target.name, count=50})
						local r = v.target.amount - math.min(50,v.target.amount);
						if r == 0 then
							v.target.destroy()
						else
							v.target.amount = r
						end
					end
					table.remove(global.modmash.grenade_targets, i)
				end
			end
		end
	end
end

local local_action_mining =function (event)
	player = game.players[event.player_index]
	if player ~= nil and player.cursor_stack.valid_for_read then
		if player.cursor_stack.name == "grenade" or player.cursor_stack.name == "cluster-grenade" then
			if grenade ~= nil and player.cursor_stack.count < grenade.count and player.selected ~= nil then
				if player.selected.type == "resource" then
					table.insert(global.modmash.grenade_targets,{target = player.selected,ticks = 0, grenage = {name = player.cursor_stack.name, count = player.cursor_stack.count}})
				end
			end
			grenade = {name = player.cursor_stack.name, count = player.cursor_stack.count}			
		end
	else
	
	if grenade~=nil and player.selected ~= nil then
			if player.selected.type == "resource" then
				table.insert(global.modmash.grenade_targets,{target = player.selected,ticks = 0, grenage = {name = grenade.name, count = grenade.count}})
			end
		end
		grenade = nil
	end
end

modmash.register_script({
	on_init = local_init,
	on_player_cursor_stack_changed = local_action_mining,
	on_tick = local_check_resource
})