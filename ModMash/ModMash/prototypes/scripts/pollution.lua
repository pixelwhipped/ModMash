--[[dsync checking 
ok only locals are reference to global
]]

--[[code reviewed 6.10.19
	Used defines for enitity name references
	use is valid]]
log("pollution.lua")
--[[check and import utils]]
if modmash == nil or modmash.util == nil then require("prototypes.scripts.util") end
if not modmash.defines then require ("prototypes.scripts.defines") end
local is_valid = modmash.util.is_valid 

--[[defines]]
local chunks_per_tick  = modmash.defines.defaults.pollution_chunks_per_tick 
local pollution_min_evolution_factor = modmash.defines.defaults.pollution_min_evolution_factor
local pollution_reduce_evolution_factor = modmash.defines.defaults.pollution_reduce_evolution_factor
local force_enemy = modmash.defines.names.force_enemy
--[[Setup volatile structures]]

--[[unitialized globals]]
local pollution = nil
local check_chunks = nil
--[[ensure globals]]
local local_init = function()	
	log("pollution local_init")
	if global.modmash.pollution == nil then global.modmash.pollution = {} end
	if global.modmash.pollution.check_chunks == nil then global.modmash.pollution.check_chunks = {} end
	pollution = global.modmash.pollution
	check_chunks = global.modmash.pollution.check_chunks
	end

local local_load = function()	
	log("pollution local_load")
	pollution = global.modmash.pollution
	check_chunks = global.modmash.pollution.check_chunks
	end

local local_check_pollution = function()
	if settings.startup["modmash-check-pollution"].value ~= "Enabled" then return end
	if game.forces["enemy"].evolution_factor < pollution_min_evolution_factor then return end	
	if global.modmash.pollution == nil then global.modmash.pollution = {} end
	if global.modmash.pollution.check_chunks == nil then global.modmash.pollution.check_chunks = {} end
	pollution = global.modmash.pollution
	check_chunks = global.modmash.pollution.check_chunks
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
			for c in surface.get_chunks() do
				table.insert(check_chunks,{chunk = c, surface = surface})
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


modmash.register_script({
	on_init = local_init,
	local_load = local_load,
	on_tick = local_check_pollution,
})