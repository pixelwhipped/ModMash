log("coffee.lua")
--[[check and import utils]]
if coffee == nil or coffee.util == nil then require("prototypes.scripts.util") end
if not coffee.defines then require ("prototypes.scripts.defines") end

--[[defines]]
local priority = coffee.defines.defaults.coffee_decrease_per_nth_tick
	
--[[create local references]]
local players = nil

--[[util]]
local starts_with  = coffee.util.starts_with
local table_contains = coffee.util.table.contains

local local_init = function()	
	if global.coffee == nil then global.coffee = {} end	
	if global.coffee.players == nil then global.coffee.players = {} end		
	players = global.coffee.players
	end

local local_load = function()	
	players = global.coffee.players
	end

local local_on_player_spawned = function(event)
	local player = game.get_player(event.player_index)
	if global.coffee == nil then global.coffee = {} end	
	if global.coffee.players == nil then global.coffee.players = {} end		
	players = global.coffee.players
	players[player] = {value=100,id=nil}
end	

local local_update_player = function(k,m)
		local player = game.get_player(k)
		if player ~= nil and player.valid then
			players[k].value = math.max(players[k].value-1+0,0)
			local level = players[k].value/100.0
			local mod = level * 3
			player.character_running_speed_modifier = mod
			local text = string.rep("●", math.ceil(level * 5 + 0.1))
			local color = {r = 1 - level, g = level, b = 0, a = 0.5}
			if players[k].id ~=nil then rendering.destroy(players[k].id) end
			players[k].id = rendering.draw_text{
				text = text,
				surface = player.surface,
				target = player.character,
				color = color,
				time_to_live = priority,
				alignment = "center",
				scale = 0.5,
			}
			--[[
			/c game.player.print(game.player.character_running_speed_modifier)
			/c game.player.character_running_speed_modifier = 3]]
		end
end

local local_tick = function()	
	if #players == 0 then
		for i = 1, #game.players do local p = game.players[i]
			players[i] = {value=100,id=nil}
		end
	end
	for k=1, #players do 
		local_update_player(k,0)		
	end
end


local local_on_player_used_capsule = function(event)
	if #players == 0 then
		for i = 1, #game.players do local p = game.players[i]
			players[i].value = 100
		end
	end
	if event.item.name == "coffee-low-grade" then
		players[event.player_index].value = math.min(math.max(players[event.player_index].value+2,0),100)
	end
	if event.item.name == "coffee-high-grade" then
		players[event.player_index].value = math.min(math.max(players[event.player_index].value+6,0),100)
	end	
	local_update_player(event.player_index,1)	
end

coffee.register_script({
	on_init = local_init,
	on_load = local_load,
	on_player_spawned = local_on_player_spawned,
	on_tick = {
		priority = priority,
		tick = local_tick
		},
	on_player_used_capsule = local_on_player_used_capsule
})