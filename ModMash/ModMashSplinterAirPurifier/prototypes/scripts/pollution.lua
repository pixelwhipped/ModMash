local print  = modmashsplinterairpurifier.util.print
local is_valid  = modmashsplinterairpurifier.util.is_valid
--[[defines]]
local chunks_per_tick  = modmashsplinterairpurifier.defines.pollution_chunks_per_tick 
local pollution_min_evolution_factor = modmashsplinterairpurifier.defines.pollution_min_evolution_factor
local pollution_reduce_evolution_factor = modmashsplinterairpurifier.defines.pollution_reduce_evolution_factor
local force_enemy = modmashsplinterairpurifier.util.defines.names.force_enemy
--[[Setup volatile structures]]

--[[unitialized globals]]
local pollution = nil
local check_chunks = nil
--[[ensure globals]]
local local_init = function()	
	if global.modmashsplinterairpurifier.pollution == nil then global.modmashsplinterairpurifier.pollution = {} end
	if global.modmashsplinterairpurifier.pollution.check_chunks == nil then global.modmashsplinterairpurifier.pollution.check_chunks = {} end
	pollution = global.modmashsplinterairpurifier.pollution
	check_chunks = global.modmashsplinterairpurifier.pollution.check_chunks
	end

local local_load = function()	
	--if global.modmashsplinterairpurifier ~= nil then 
		pollution = global.modmashsplinterairpurifier.pollution
		check_chunks = global.modmashsplinterairpurifier.pollution.check_chunks
	--end
	end

local local_reset_surface_chunk_detail = function(event)
		if global.modmashsplinterairpurifier.pollution == nil then global.modmashsplinterairpurifier.pollution = {} end
		global.modmashsplinterairpurifier.pollution.check_chunks = {} 
		pollution.pollution_update_index = 1
		pollution.pollution_can_reduce = true

		end

local local_check_pollution = function()

	if settings.startup["setting-check-pollution"].value ~= "Enabled" then return end
	if global.modmashsplinterairpurifier.pollution_high == nil then global.modmashsplinterairpurifier.pollution_high = false end
	if game.forces[force_enemy].evolution_factor >= 0.8 then global.modmashsplinterairpurifier.pollution_high = true end
	if game.forces[force_enemy].evolution_factor <= 0.79 and global.modmashsplinterairpurifier.pollution_high == true then 
		for i = 1, #game.players do local p = game.players[i]
			p.unlock_achievement("blue-skies")
		end		
	end
	if game.forces[force_enemy].evolution_factor < pollution_min_evolution_factor then return end	
	if global.modmashsplinterairpurifier.pollution == nil then global.modmashsplinterairpurifier.pollution = {} end
	if global.modmashsplinterairpurifier.pollution.check_chunks == nil then global.modmashsplinterairpurifier.pollution.check_chunks = {} end
	pollution = global.modmashsplinterairpurifier.pollution
	check_chunks = global.modmashsplinterairpurifier.pollution.check_chunks
	if pollution.pollution_update_index == nil then 
		pollution.pollution_update_index = 1 
	end
	if pollution.pollution_can_reduce == nil then
		pollution.pollution_can_reduce = true
	end
	
	local index = pollution.pollution_update_index
	local numiter = 1	
	
	if #check_chunks == 0 then
		for _, surface in pairs(game.surfaces) do
			local allow = true
			if surface.map_gen_settings.property_expression_names["tile:deepwater:probability"] ~= nil then
				if type(surface.map_gen_settings.property_expression_names["tile:deepwater:probability"])  == "number" then
					if surface.map_gen_settings.property_expression_names["tile:deepwater:probability"]< -100 then allow = false end
				else
					if tonumber(surface.map_gen_settings.property_expression_names["tile:deepwater:probability"]) < -100 then allow = false end
				end
			end
			if surface.map_gen_settings.property_expression_names["tile:water:probability"] ~= nil then
				if type(surface.map_gen_settings.property_expression_names["tile:water:probability"])  == "number" then
					if surface.map_gen_settings.property_expression_names["tile:water:probability"]< -100 then allow = false end
				else
					if tonumber(surface.map_gen_settings.property_expression_names["tile:water:probability"]) < -100 then allow = false end
				end
			end
			if surface.map_gen_settings.property_expression_names["tile:water-shallow:probability"] ~= nil then
				if type(surface.map_gen_settings.property_expression_names["tile:water-shallow:probability"])  == "number" then
					if surface.map_gen_settings.property_expression_names["tile:water-shallow:probability"]< -100 then allow = false end
				else
					if tonumber(surface.map_gen_settings.property_expression_names["tile:water-shallow:probability"]) < -100 then allow = false end
				end
			end
			if surface.map_gen_settings.property_expression_names["tile:water-mud:probability"] ~= nil then
				if type(surface.map_gen_settings.property_expression_names["tile:water-mud:probability"])  == "number" then
					if surface.map_gen_settings.property_expression_names["tile:water-mud:probability"]< -100 then allow = false end
				else
					if tonumber(surface.map_gen_settings.property_expression_names["tile:water-mud:probability"]) < -100 then allow = false end
				end
			end
			if allow then
				for c in surface.get_chunks() do
					table.insert(check_chunks,{chunk = c, surface = surface})
				end
			end
		end
	end

	if pollution.pollution_check_done == true then 		
		if pollution.pollution_can_reduce == true then
			if game.forces[force_enemy].evolution_factor > pollution_min_evolution_factor  then
				game.forces[force_enemy].evolution_factor = game.forces[force_enemy].evolution_factor - pollution_reduce_evolution_factor
			end		
		end
		pollution.pollution_can_reduce = nil
		pollution.pollution_update_index = nil
		pollution.pollution_check_done = false
		check_chunks = {} -- rebuild
		return
	end
	
	for k=index, #check_chunks do local chunk = check_chunks[k]
	    if is_valid(chunk.surface) == false or is_valid(chunk.chunk) == false then
			--Somthing buggered up the surface
			check_chunks = {}
			return
		end
		local x = chunk.chunk.x * 32
		local y = chunk.chunk.y * 32
		if chunk.surface.get_pollution({x,y}) > 0 then 
			if chunk.surface.count_entities_filtered{force=force_enemy,area = {{x,y},{x+32,y+32}}} > 0 then
				pollution.pollution_can_reduce = false
				pollution.pollution_update_index = 1
				pollution.check_chunks = nil
				pollution.pollution_check_done = true
				break
			end
		end
		numiter = numiter + 1
		if numiter >= chunks_per_tick then			
			pollution.pollution_update_index = k+1
			return
		end		
	end
	pollution.pollution_check_done = true
	end

script.on_event({defines.events.on_surface_created,defines.events.on_surface_deleted},local_reset_surface_chunk_detail)
script.on_event(defines.events.on_tick,local_check_pollution)
script.on_init(local_init)
script.on_load(local_load)