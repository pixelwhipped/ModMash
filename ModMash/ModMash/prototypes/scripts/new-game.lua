log("new-game.lua")
--[[check and import utils]]
if modmash == nil or modmash.util == nil then require("prototypes.scripts.util") end
if not modmash.defines then require ("prototypes.scripts.defines") end

--[[defines]]
	
--[[create local references]]
--[[util]]
local starts_with  = modmash.util.starts_with
local table_contains = modmash.util.table.contains

local local_init = function()
	global.modmash.shown_welcome = false
	end

local local_start = function()
	if global.modmash.shown_welcome == true then return end
	if settings.startup["modmash-show-welcome"].value ~= true and #game.connected_players ~= 1 then return end
		game.tick_paused = true
		local welcome = game.players[1].gui.center.add{ type="frame", name="modmash-show-welcome", direction = "vertical", caption="Welcome to ModMash" }
		welcome.style.width = 310
		local string = "ModMash add new or extends recipes and add's many new features. \n\n Quick Tip(s)\n"
		string = string .. "Refine raw ore that can be smelted\ninto twice the plates.\n\n"
		string = string .. "Press ".. settings.startup["modmash-setting-adjust-binding"].value .. " to adjust entites\n"
		string = string .. "Place inserters by water to start fishing\n"
		string = string .. "Throw a grenade at some raw resources\n\n"
		string = string .. "Press ".. settings.startup["modmash-setting-adjust-binding"].value .. " over bot to toggle different modes\n\n"
		string = string .. "Now with Tech Loot, find a crashed lab to unlock new technologies. Move mouse over to activate.\n\n"
		string = string .. "New Valkyries!  Defence robots for roboports.\n\n"
		local text = welcome.add{type = "label", caption = string}
		text.style.width = 300
		text.style.single_line = false
	--	local refine = welcome.add{type="flow",direction = "horizontal"}
	--	refine.style.width = 300
		--refine.add{
		 -- type = "button",
		 -- name = "ore-refinery-button",
		 -- style = "ore-refinery-image-button-style",
		 -- state = true
		--}
		--refine.add{type="sprite", name="ore-refinery-spr"}
		--refine.add{type = "label", caption = "Refine raw ore that can be smelted\ninto twice the plates"}
		local options = welcome.add{type="flow",direction = "horizontal"}
		options.style.width = 300
		options.add{type = "button", name="modmash-show-welcome-btn",style = "confirm_button", caption="Ok"}		
		global.modmash.shown_welcome = true
	end		

local local_on_gui_click = function(event)
  if event.element and event.element.valid and starts_with(event.element.name, "modmash-show-welcome-btn") then    
	game.players[event.player_index].gui.center["modmash-show-welcome"].destroy()
    game.tick_paused = false
  end
end

local local_on_player_spawned = function(event)
	local player = game.get_player(event.player_index)
	if global.modmash.players == nil then global.modmash.players = {} end
	if table_contains(global.modmash.players,player) then return end
	local stack = {name  = "assembling-machine-1", count = 1}
	local inv = player.get_inventory(defines.inventory.character_main)
	if inv.can_insert(stack) then inv.insert(stack) end
end	

modmash.register_script({
	on_init = local_init,
	on_start = local_start,
	on_gui_click = local_on_gui_click,
	on_player_spawned = local_on_player_spawned	
})