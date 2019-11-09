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
		start_sum = 0,
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
	--local ret = true
	local hypot = math.sqrt(math.pow(global.spaghetti.distance,2)*2)
	for i = 1, #start_entities do
		local e = start_entities[i]
		if is_valid(e) then
			--local size = get_entity_size(e)
			--local tiles = size[1]*size[2]
			--global.spaghetti.start_sum = global.spaghetti.start_sum + tiles
			local p1 = e.position
			local p2 = entity.position
			if distance(p1.x,p1.y,p2.x,p2.y) >  hypot then 
				--ret = false 
				return false
			end
		end
	end
	return true
	end

local local_check_surface_distances = function(entity)
	local dist = math.sqrt(math.pow(global.spaghetti.distance,2)*2)
	--local posistion = {x=entity.bounding_box["left_top"]["x"],y=entity.bounding_box["left_top"]["x"]}
	--spaghetti.util.print(posistion.x.." "posistion.y)
	local entities = entity.surface.find_entities_filtered{area = {{entity.position.x-dist,entity.position.y-dist}, {entity.position.x+dist,entity.position.y+dist}}, force = "player"}
	local sum = 0
	local count = 0
	for i = 1, #entities do
		local e = entities[i]
		if is_valid(e) then
			if e.name ~= "character" then
				local size = get_entity_size(e)
				local tiles = size[1]*size[2]
				sum = sum + tiles
				count = count + 1
			end
		end
	end
	--spaghetti.util.print("Adding more "..count.. " "..sum.." "..global.spaghetti.expected_entitites_in_tiles)
	return sum >= global.spaghetti.expected_entitites_in_tiles
	end

local allow_any = {"splitter","transport-belt","underground-belt","pipe","pipe-to-ground","offshore-pump"}
local local_on_added = function(event)
	if is_valid(event.created_entity) == false then return end		
		if #global.spaghetti.start_entities == 0 or (global.spaghetti.start_sum < global.spaghetti.expected_entitites_in_tiles and local_check_distances(global.spaghetti.start_entities,event.created_entity)) then
			
			if event.created_entity.name ~= "entity-ghost" and event.created_entity.name ~= "tile-ghost" then
				local size = get_entity_size(event.created_entity)
				local tiles = size[1]*size[2]
				--spaghetti.util.print(size)
				global.spaghetti.start_sum = global.spaghetti.start_sum + tiles
				table.insert(global.spaghetti.start_entities,event.created_entity)
			else
				if table_contains(allow_any,event.created_entity.type) == false then
					event.created_entity.destroy()
				end
			end			
			--spaghetti.util.print("Adding intial "..global.spaghetti.start_sum.. " "..global.spaghetti.expected_entitites_in_tiles)

		elseif local_check_surface_distances(event.created_entity) == false then
			if event.created_entity.name == "entity-ghost" or event.created_entity.name == "tile-ghost" then
				if table_contains(allow_any,event.created_entity.type) == false then
					event.created_entity.destroy()
				end
			elseif event.player_index then
				if table_contains(allow_any,event.created_entity.type) == false then
					event.created_entity.surface.spill_item_stack(event.created_entity.position, {name=event.created_entity.name, count=1})
					event.created_entity.destroy()
				end
			end
		end
		
	--end
	end

local local_on_removed = function(event)
	if is_valid(event.entity) == false then return end
	local entities = global.spaghetti.start_entities
	if table_contains(entities,event.entity) then 
		local size = get_entity_size(event.entity)
		local tiles = size[1]*size[2]
		global.spaghetti.start_sum = math.max(0, global.spaghetti.start_sum - tiles)
		for i = #entities, 1, -1 do	
			if entities[i] == event.entity then
				table.remove(entities,i)
				break
			end
		end
		--table_remove(,event.entity) 
	end
	end

local local_on_research = function(event)
	if starts_with(event.research.name,"extend-build-range") then
		if global.spaghetti.distance == nil then global.spaghetti.distance = initial_distance end
		global.spaghetti.distance =  global.spaghetti.distance + 16		
	end	
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

local local_on_selected = function(event)
	 local player = game.players[event.player_index]
	 if player.selected == nil then return end
	-- spaghetti.util.print( player.selected.force.name)
end

script.on_event(build_events, local_on_added)
script.on_event(remove_events, local_on_removed)
script.on_event(defines.events.on_research_finished, local_on_research)
script.on_event(defines.events.on_tick, local_on_tick)
script.on_event(defines.events.on_gui_click, local_on_gui_click)
script.on_event(defines.events.on_selected_entity_changed,local_on_selected)