--[[
if not util then require("prototypes.scripts.util") end

local fluid_research_level = nil

local local_get_fluid_research_level = function()
		for k=4, 7 do
			if game.players[1].force.technologies["fluid-handling-".. k].researched then
				local r = game.players[1].force.technologies["fluid-handling-".. (k+1)]
				if r == nil then 
					fluid_research_level = k
					return k 
				end
				if r.researched ~= true then 
					fluid_research_level = k
					return fluid_research_level
				end
			end
		end
	return fluid_research_level
end

local local_pipes_research = function(event)		
	if util.starts_with(event.research.name,"fluid-handling-") and game.players[1].force.technologies["fluid-handling-3"].researched then
		
		fluid_research_level = nil
		if local_get_fluid_research_level() ~= nil then
			for name, recipe in pairs(game.players[1].force.recipes) do 
				local proto = game.entity_prototypes[name]
				if proto ~= nil then
					if proto.type == "pipe-to-ground" then
						if recipe.enabled then util.log("disable " .. recipe.name) end
						recipe.enabled = false							
						if util.ends_with(name, "-level-"..(fluid_research_level-2)) then 
							recipe.enabled = true 
							if recipe.enabled then util.log("enable " .. recipe.name) end
						end
					end
				end
				---
			end
		end
	end		
end

local local_pipes_pick_up = function(event)
	player = game.players[event.player_index];
	if player ~= nil and player.cursor_stack.valid_for_read then
		local proto = game.entity_prototypes[player.cursor_stack.name]
		if proto ~= nil then
			if proto.type == "pipe-to-ground" then
				if fluid_research_level == nil then return end		
				if fluid_research_level <= 3 then return end
				if util.ends_with(player.cursor_stack.name, "-level-"..(fluid_research_level-2)) then return end
				if fluid_research_level == 4 and player.cursor_stack.name == "pipe-to-ground" then
					local stack = {name = "pipe-to-ground-level-2", count = player.cursor_stack.count}
					player.cursor_stack.clear()
					player.cursor_stack.set_stack(stack) 
				elseif util.index_of(player.cursor_stack.name, '-level-') ~= nil then
					local n = player.cursor_stack.name
					n = n:sub( 1, util.index_of(n, '-level-'))	
					local stack = {name = n .. "level-"..(fluid_research_level-2), count = player.cursor_stack.count}
					player.cursor_stack.clear()
					player.cursor_stack.set_stack(stack) 	
				else
					local stack = {name = player.cursor_stack.name .. "-level-"..(fluid_research_level-2), count = player.cursor_stack.count}	
					player.cursor_stack.clear()
					player.cursor_stack.set_stack(stack)
				end
			end
		end
	end
end
]]
--[[
if modmash.ticks ~= nil then	
	if script ~= nil then
		table.insert(modmash.on_research,local_pipes_research)
		table.insert(modmash.on_player_cursor_stack_changed,local_pipes_pick_up)		
	end
end]]