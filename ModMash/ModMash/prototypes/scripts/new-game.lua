log("new-game.lua")
--[[check and import utils]]
--[[defines]]	
--[[create local references]]
--[[util]]
local starts_with  = modmash.util.starts_with
local table_contains = modmash.util.table.contains

local local_on_player_spawned = function(event)
	local player = game.get_player(event.player_index)
	if global.modmash.players == nil then global.modmash.players = {} end
	if table_contains(global.modmash.players,player) then return end
	local stack = {name  = "assembling-machine-burner", count = 1}
	local inv = player.get_inventory(defines.inventory.character_main)
	if inv and inv.can_insert(stack) then inv.insert(stack) end
end	

modmash.register_script({
	on_player_spawned = local_on_player_spawned	
})