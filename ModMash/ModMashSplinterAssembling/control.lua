require("prototypes.scripts.defines") 
if not global.modmashsplinterassembling then global.modmashsplinterassembling = {} end

local print  = modmashsplinterassembling.util.print
local table_contains = modmashsplinterassembling.util.table.contains

local local_on_player_spawned = function(event)
	
	local player = game.get_player(event.player_index)
	if player.character == nil then return end
	if global.modmashsplinterassembling.players == nil then global.modmashsplinterassembling.players = {} end
	if table_contains(global.modmashsplinterassembling.players,player) then return end
	local stack = {name  = "assembling-machine-burner", count = 1}
	local inv = player.get_inventory(defines.inventory.character_main)
	if inv and inv.can_insert(stack) then inv.insert(stack) end
end	

local local_cutscene_cancelled = function(event)
	if remote.interfaces["freeplay"] then 
		local_on_player_spawned(event)
	end
end

local local_on_configuration_changed = function(event) 	
	if settings.startup["setting-assembling-machine-burner-only"].value == "No" then
		local changed = event.mod_changes and event.mod_changes["modmashsplinterassembling"]
		if changed then
			for index, force in pairs(game.forces) do
				if force.technologies["automation"].researched then
				force.recipes["assembling-machine-f"].enabled = true
				end
			end
		end
	 end
	 end

script.on_configuration_changed(local_on_configuration_changed)

script.on_event({defines.events.on_player_joined_game,defines.events.on_player_created},local_on_player_spawned)
script.on_event(defines.events.on_cutscene_cancelled,local_cutscene_cancelled)

script.on_init(function() remote.call("modmashsplinterregenerative","register_regenerative","assembling-machine-5") end)
script.on_load(function() remote.call("modmashsplinterregenerative","register_regenerative","assembling-machine-5") end)

