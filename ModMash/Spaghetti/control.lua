log("Entering control.lua")

require("prototypes.scripts.util") 
require("prototypes.scripts.defines") 

local build_events = spaghetti.events.on_build
local remove_events = spaghetti.events.on_remove
local initial_expected_entitites_in_tiles = spaghetti.defines.defaults.initial_expected_entitites_in_tiles
local initial_distance = spaghetti.defines.defaults.initial_distance

local run_init = false

local table_contains = spaghetti.util.table.contains
local table_index_of = spaghetti.util.table.index_of
local table_remove = spaghetti.util.table_remove 
local starts_with  = spaghetti.util.starts_with
local ends_with  = spaghetti.util.ends_with
local distance  = spaghetti.util.distance
local is_valid  = spaghetti.util.is_valid
local get_entity_size = spaghetti.util.get_entity_size

--[[Called first time mod is added to current game instance. Called Once]]
local local_on_init = function()
	log("control.local_on_init")
	if global.spaghetti == nil then global.spaghetti = 
	{
		start_entities = {},
		shown_welcome = false,
		distance = spaghetti.defines.defaults.initial_distance,
		expected_entitites_in_tiles = initial_expected_entitites_in_tiles
	} 
	end	
	end
script.on_init(local_on_init)


--[[Called subsequent times mod is loaded. Called each time except first instance]]
script.on_load(function()
	log("control.on_load")
	end)

script.on_configuration_changed(function(f) 
	if f.mod_changes["spaghetti"] == nil or f.mod_changes["spaghetti"].old_version == nil or f.mod_changes["spaghetti"].new_version == nil then return end
	log("control.on_configuration_changed " .. f.mod_changes["spaghetti"].old_version .. " -> " .. f.mod_changes["spaghetti"].new_version)
	global.spaghetti.shown_welcome = false 
	end)

local local_check_distances = function(start_entities,entity )
	for i = 1, #start_entities do
		local p1 = start_entities[i].position
		local p2 = entity.position
		if distance(p1.x,p1.y,p2.x,p2.y) > global.spaghetti.distance then return false end
	end
	return true
	end

local local_check_surface_distances = function(entity)
	local dist = global.spaghetti.distance/2
	local neg_dist = dist * -1
	local entities = entity.surfaces.find_entities_filtered{area = {{-neg_dist, -neg_dist}, {dist, dist}}, force = "player"}
	local sum = 0
	for i = 1, #entities do
		local size = get_entity_size(entities[i])
		local tiles = size[1]*size[2]
		sum = sum + tiles
	end
	return sum >= global.spaghetti.expected_entitites_in_tiles
	end

local local_on_added = function(event)
	if is_valid(event.created_entity) == false return end
	if #start_entities < global.spaghetti.expected_entitites_in_tiles then 
		if #start_entities == 0 then 
			table.insert(global.spaghetti.start_entities,event.created_entity) 
		elseif local_check_distances(global.spaghetti.start_entities,event.created_entity) then
			table.insert(global.spaghetti.start_entities,event.created_entity)
		elseif local_check_surface_distances(global.spaghetti.start_entities,event.created_entity) == false then
			if entity.name == "entity-ghost" or entity.name == "tile-ghost" then
				entity.destroy()
			if event.player_index then
				entity.surface.spill_item_stack(entity.position, {name=entity.name, count=1})
				entity.destroy()
			end
		end
		
	end
	end

local local_on_removed = function(event)
	if is_valid(event.created_entity) == false return end
	if table_contains(global.spaghetti.start_entities,event.created_entity) then table_remove(global.spaghetti.start_entities,event.created_entity) end
	end

local local_on_research = function(event)
	end

local local_on_gui_click = function(event)
	if event.element and event.element.valid and starts_with(event.element.name, "spaghetti-show-welcome-btn") then    
		game.players[event.player_index].gui.center["spaghetti-show-welcome"].destroy()
		game.tick_paused = false
	end
	end

local local_show_welcome = function()
	if global.spaghetti.shown_welcome == true then return end
	if settings.startup["spaghetti-show-welcome"].value ~= true and #game.connected_players ~= 1 then return end
	game.tick_paused = true
	local welcome = game.players[1].gui.center.add{ type="frame", name="spaghetti-show-welcome", direction = "vertical", caption="Welcome to Spaghetti" }
	welcome.style.width = 310
	local string = "Spaghetti challenge will force builings closer togeather. \n\nEntites can be placed initally but \nmust be within 32 tiles of each other.\nAfter that time and expected qty of entites\nare rquired to be withing range of the next."
	local text = welcome.add{type = "label", caption = string}
	text.style.width = 300
	text.style.single_line = false
	local options = welcome.add{type="flow",direction = "horizontal"}
	options.style.width = 300
	options.add{type = "button", name="spaghetti-show-welcome-btn",style = "confirm_button", caption="Ok"}		
	global.spaghetti.shown_welcome = true
	end	

local local_on_start = function()
	log("control.local_on_start")	
	local_show_welcome()
	return true
	end

local local_on_tick = function()
	if game.tick > 1 and run_init ~= true then run_init = local_on_start() end
	end

script.on_event(build_events, local_on_added)
script.on_event(remove_events, local_on_removed)
script.on_event(defines.events.on_research_finished, local_on_research)
script.on_event(defines.events.on_tick, local_on_tick)
script.on_event(defines.events.on_gui_click, local_on_gui_click)