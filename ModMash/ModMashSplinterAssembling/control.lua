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


script.on_event({defines.events.on_player_joined_game,defines.events.on_player_created},local_on_player_spawned)
script.on_event(defines.events.on_cutscene_cancelled,local_cutscene_cancelled)

script.on_init(function() remote.call("modmashsplinterregenerative","register_regenerative","assembling-machine-5") end)
script.on_load(function() remote.call("modmashsplinterregenerative","register_regenerative","assembling-machine-5") end)

