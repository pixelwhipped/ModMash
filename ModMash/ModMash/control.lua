--[[Code check 29.2.20
no changes
--]]
log("Entering control.lua")
--[[Setup volatile structures]]
if not modmash then modmash = {} end
--potential desync issue
if not modmash.force_configuration_change then modmash.force_configuration_change = false end
if not modmash.ticks then modmash.ticks = {} end
if not modmash.ticks_low then modmash.ticks_low = {} end
if not modmash.ticks_med then modmash.ticks_med = {} end
if not modmash.ticks_high then modmash.ticks_high = {} end

if not modmash.on_added then modmash.on_added = {} end
if not modmash.on_added_by_name then modmash.on_added_by_name = {} end
if not modmash.on_removed then modmash.on_removed = {} end
if not modmash.on_removed_by_name then modmash.on_removed_by_name = {} end
if not modmash.on_pick_up then modmash.on_pick_up = {} end
if not modmash.on_pick_up_by_name then modmash.on_pick_up_by_name = {} end
if not modmash.on_init then modmash.on_init = {} end
if not modmash.on_load then modmash.on_load = {} end 
if not modmash.on_start then modmash.on_start = {} end
if not modmash.on_player_cursor_stack_changed then modmash.on_player_cursor_stack_changed = {} end
if not modmash.on_damage then modmash.on_damage = {} end 
if not modmash.on_damage_by_name then modmash.on_damage_by_name = {} end 
if not modmash.on_research then modmash.on_research = {} end 
if not modmash.on_selected then modmash.on_selected = {} end 
if not modmash.on_selected_by_name then modmash.on_selected_by_name = {} end 
if not modmash.on_spawned then modmash.on_spawned = {} end 
if not modmash.on_spawned_by_name then modmash.on_spawned_by_name = {} end 
if not modmash.on_chunk_charted then modmash.on_chunk_charted = {} end 
if not modmash.on_chunk_generated then modmash.on_chunk_generated = {} end 
if not modmash.on_post_entity_died then modmash.on_post_entity_died = {} end 
if not modmash.on_gui_click then modmash.on_gui_click = {} end
if not modmash.on_player_spawned then modmash.on_player_spawned = {} end
if not modmash.on_adjust then modmash.on_adjust = {} end
if not modmash.on_adjust_by_name then modmash.on_adjust_by_name = {} end
if not modmash.on_player_rotated_entity then modmash.on_player_rotated_entity = {} end
if not modmash.on_player_rotated_entity_by_name then modmash.on_player_rotated_entity_by_name = {} end
if not modmash.on_configuration_changed then modmash.on_configuration_changed = {} end
if not modmash.on_train_changed_state then modmash.on_train_changed_state = {} end
if not modmash.on_ai_command_completed then modmash.on_ai_command_completed = {} end
if not modmash.on_trigger_created_entity then modmash.on_trigger_created_entity = {} end
if not modmash.on_entity_cloned then modmash.on_entity_cloned = {} end


local run_init = false

require("prototypes.scripts.defines") 
local build_events = modmash.events.on_build
local remove_events = modmash.events.on_remove
local item_pick_up_events = modmash.events.on_pick_up_item
local allow_pickup_rotations = modmash.defines.names.allow_pickup_rotations
local allow_fishing = modmash.defines.names.allow_fishing

local low_priority = modmash.events.low_priority
local medium_priority = modmash.events.medium_priority
local high_priority = modmash.events.high_priority

local is_map_editor = false

--[[standardized script controls]]

modmash.register_script = function(script)
	local index_of = function(table,value)
		for k, v in pairs(table) do 
			if v == value then 
				return k 
			end
		end return nil 
		end
	local register_event_for_in = function(event_table,func,name)
		if event_table[name] == nil then
			event_table[name] = {func}
		else
			table.insert(event_table[name],func)
		end
		end
	if script.on_init ~= nil then 
		log("Registering init event")
		table.insert(modmash.on_init,script.on_init)
	end
	if script.on_configuration_changed ~= nil then 
		log("Registering configuration changed event")
		table.insert(modmash.on_configuration_changed,script.on_configuration_changed)
	end
	if script.on_gui_click ~= nil then 
		log("Registering gui click event")
		table.insert(modmash.on_gui_click,script.on_gui_click)
	end
	if script.on_load ~= nil then 
		log("Registering load event")
		table.insert(modmash.on_load,script.on_load)
	end
	if script.on_start ~= nil then 
		log("Registering start event")
		table.insert(modmash.on_start,script.on_start)
	end
	if script.on_added~= nil then 
		log("Registering spawned event")
		table.insert(modmash.on_added,script.on_added)
	end
	if script.on_train_changed_state ~= nil then 
		log("Registering train changed state event")
		table.insert(modmash.on_train_changed_state,script.on_train_changed_state)
	end
	if script.on_entity_cloned ~= nil then 
		log("Registering on entity cloned event")
		table.insert(modmash.on_entity_cloned,script.on_entity_cloned)
	end
	
	if script.on_player_cursor_stack_changed~= nil then 
		log("Registering player stack changed event")
		table.insert(modmash.on_player_cursor_stack_changed,script.on_player_cursor_stack_changed)
	end	
	if script.on_removed~= nil then 
		log("Registering removed event")
		table.insert(modmash.on_removed,script.on_removed)
	end
	if script.on_post_entity_died ~= nil then 
		log("Registering post entity died event")
		table.insert(modmash.on_post_entity_died,script.on_post_entity_died)
	end	
	if script.on_damage ~= nil then 
		log("Registering damage event")
		table.insert(modmash.on_damage,script.on_damage)
	end	
	if script.on_trigger_created_entity ~= nil then 
		log("Registering trigger entity created event")
		table.insert(modmash.on_trigger_created_entity,script.on_trigger_created_entity)
	end	
	
	if script.on_pick_up ~= nil then 
		log("Registering pick up event")
		table.insert(modmash.on_pick_up,script.on_pick_up)
	end		
	if script.on_research ~= nil then 
		log("Registering research event")
		table.insert(modmash.on_research,script.on_research)
	end	
	if script.on_selected ~= nil then 
		log("Registering selected event")
		table.insert(modmash.on_selected,script.on_selected)
	end
	if script.on_chunk_charted ~= nil then 
		log("Registering legacy chunk charted event")
		table.insert(modmash.on_chunk_charted,script.on_chunk_charted)
	end
	if script.on_chunk_generated ~= nil then 
		log("Registering legacy chunk generated event")
		table.insert(modmash.on_chunk_generated,script.on_chunk_generated)
	end
	if script.on_spawned~= nil then 
		log("Registering spawned event")
		table.insert(modmash.on_spawned,script.on_spawned)
	end
	if script.on_player_spawned ~= nil then 
		log("Registering player spawned event")
		table.insert(modmash.on_player_spawned,script.on_player_spawned)
	end
	if script.on_adjust ~= nil then 
		log("Registering adjust event")
		table.insert(modmash.on_adjust,script.on_adjust)
	end
	if script.on_player_rotated_entity ~= nil then 
		log("Registering rotated entity event")
		table.insert(modmash.on_player_rotated_entity,script.on_player_rotated_entity)
	end
	if script.on_ai_command_completed ~= nil then 
		log("Registering ai command completed event")
		table.insert(modmash.on_ai_command_completed,script.on_ai_command_completed)
	end
	
	if script.on_tick ~= nil then 
		if type(script.on_tick)=="table" and type(script.on_tick.tick) == "function" then
			log("Registering advanced tick event")
			if script.on_tick.priority ~= nil then
				if script.on_tick.priority == low_priority then
					table.insert(modmash.ticks_low,script.on_tick.tick)
				elseif script.on_tick.priority == med_priority then
					table.insert(modmash.ticks_med,script.on_tick.tick)
				elseif script.on_tick.priority == high_priority then
					table.insert(modmash.ticks_high,script.on_tick.tick)
				else
					log("Unknown priority")
					table.insert(modmash.ticks,script.on_tick.tick)
				end
			else
				table.insert(modmash.ticks,script.on_tick.tick)
			end
			if script.on_tick.table ~= nil and type(script.on_tick.table) == "function" and script.on_tick.auto_add_remove~= nil and type(script.on_tick.auto_add_remove) == "table" then 
				for k=1, #script.on_tick.auto_add_remove do local s = script.on_tick.auto_add_remove[k]
					log("Registering auto add remove "..s)
					register_event_for_in(modmash.on_added_by_name, function(entity) table.insert(script.on_tick.table(), entity) end,s)
					register_event_for_in(modmash.on_removed_by_name, function(entity) 
						local t = script.on_tick.table()
						table.remove(table, index_of(t, entity)) 
					end,s)	
				end
			end
		elseif type(script.on_tick) == "function" then
			log("Registering tick event")
			table.insert(modmash.ticks,script.on_tick)
		else
			log("Failed to register tick event")
		end
	end
	if script.names ~=nil then
		for k=1, #script.names do local s = script.names[k]		
			if script.on_added_by_name ~= nil and type(script.on_added_by_name) == "function" then 
				log("Registering added event for ".. s)
				register_event_for_in(modmash.on_added_by_name,script.on_added_by_name,s)
			end
			if script.on_removed_by_name ~= nil and type(script.on_removed_by_name) == "function" then 
				log("Registering removed event for ".. s)
				register_event_for_in(modmash.on_removed_by_name,script.on_removed_by_name,s)
			end
			if script.on_spawned_by_name ~= nil then 
				log("Registering spawned event for ".. s)
				register_event_for_in(modmash.on_spawned_by_name,script.on_spawned_by_name,s)
			end
			if script.on_damage_by_name ~= nil then 
				log("Registering damage event for ".. s)
				register_event_for_in(modmash.on_damage_by_name,script.on_damage_by_name,s)
			end
			if script.on_selected_by_name ~= nil then 
				log("Registering selected event for ".. s)
				register_event_for_in(modmash.on_selected_by_name,script.on_selected_by_name,s)
			end
			if script.on_pick_up_by_name ~= nil then 
				log("Registering pick up event for ".. s)
				register_event_for_in(modmash.on_pick_up_by_name,script.on_pick_up_by_name,s)
			end
			if script.on_adjust_by_name ~= nil then 
				log("Registering adjust event for ".. s)
				register_event_for_in(modmash.on_adjust_by_name,script.on_adjust_by_name,s)
			end
			if script.on_player_rotated_entity_by_name ~= nil then 
				log("Registering rotated entity event for ".. s)
				register_event_for_in(modmash.on_player_rotated_entity_by_name,script.on_player_rotated_entity_by_name,s)
			end
		end
	end
	end

--chunks should possibly be global

--[[Import utils]]
require("prototypes.scripts.util") 
local table_contains = modmash.util.table.contains
local table_index_of = modmash.util.table.index_of
local starts_with  = modmash.util.starts_with
local ends_with  = modmash.util.ends_with
local distance  = modmash.util.distance
local is_valid  = modmash.util.is_valid
local is_valid_and_persistant  = modmash.util.is_valid_and_persistant


--[[Called first time mod is added to current game instance. Called Once]]
local local_on_init = function()
	log("control.local_on_init")
	if global.modmash == nil then global.modmash = {allow_pickup_rotations = false} end	
	for k=1, #modmash.on_init do local v = modmash.on_init[k]		
		v()
	end
	global.modmash.initialized = true 
	end
script.on_init(local_on_init)


--[[Called subsequent times mod is loaded. Called each time except first instance]]
script.on_load(function()
	log("control.on_load")
	for k=1, #modmash.on_load do local v = modmash.on_load[k]		
		v()
	end 
	end)	

script.on_configuration_changed(function(f) 
	if f.mod_changes["modmash"] == nil or f.mod_changes["modmash"].old_version == nil then
		if modmash.force_configuration_change == true then
			log("Forcing update to " .. game.active_mods["modmash"])
			f.mod_changes["modmash"] = 
			{
				new_version = game.active_mods["modmash"],
				old_version = "0.17.0"
			} 
		else
			return
		end
	end

	log("control.on_configuration_changed " .. f.mod_changes["modmash"].old_version .. " -> " .. f.mod_changes["modmash"].new_version)
	global.modmash.shown_welcome = false 
	if f.mod_changes["modmash"].old_version < "0.17.61" then	
		log("control.on_configuration_changed(repair needed)")
		local_on_init()
		for k=1, #modmash.on_configuration_changed do local v = modmash.on_configuration_changed[k]		
			v(f)
		end
		for k=1, #modmash.on_load do local v = modmash.on_load[k]		
			v()
		end 
	else
		for k=1, #modmash.on_configuration_changed do local v = modmash.on_configuration_changed[k]		
			v(f)
		end
	end
	end)

require("prototypes.scripts.loot")
require("prototypes.scripts.regenerative")
require("prototypes.scripts.explosive-mining")
require("prototypes.scripts.valves")
require("prototypes.scripts.wind-trap")
require("prototypes.scripts.discharge-pump")
require("prototypes.scripts.fishing-inserter")
require("prototypes.scripts.recycling")
require("prototypes.scripts.droid")
require("prototypes.scripts.loader")
require("prototypes.scripts.biter-neuro-toxin")
require("prototypes.scripts.pollution")
require("prototypes.scripts.biter-spawner")
require("prototypes.scripts.new-game")
require("prototypes.scripts.subspace-transport")
require("prototypes.scripts.valkyrie")
require("prototypes.scripts.underground")

local local_on_standard_entity_event = function(entity, table, table_by_name, event)	
	if is_map_editor == true then return end
	if is_valid(entity) then			
		for k=1, #table do local v = table[k]		
			v(entity,event)
		end
		if table_by_name ~= nil and is_valid_and_persistant(entity) then
			local tbl = table_by_name[entity.name]
			if tbl ~= nil then
				for k=1, #tbl do local v = tbl[k]		
					v(entity,event)
				end
			end
		end
	end end

local local_on_entity_cloned = function (event)
	for k=1, #modmash.on_entity_cloned do local v = modmash.on_entity_cloned[k]		
		v(event)
	end 
end

--[[done]]
local local_on_added = function(event)	
	local_on_standard_entity_event(event.created_entity,modmash.on_added,modmash.on_added_by_name,event)
	end
--[[done]]
local local_on_spawned = function(event)
	local_on_standard_entity_event(event.entity,modmash.on_spawned,modmash.on_spawned_by_name,event)
	end
--[[done]]
local local_on_removed = function(event)
	local_on_standard_entity_event(event.entity,modmash.on_removed,modmash.on_removed_by_name,event)
	end
--[[done]]
local local_on_damage = function(event)
	local_on_standard_entity_event(event.entity,modmash.on_damage,modmash.on_damage_by_name,event)
	end
--[[done]]
local local_item_pick_up = function(event)
	if is_map_editor == true then return end
	local stack = event.item_stack
	if stack ~= nil then				
		for k=1, #modmash.on_pick_up do local v = modmash.on_pick_up[k]		
			v(stack,event)
		end
		local tbl = modmash.on_pick_up_by_name[stack.name]
		if tbl ~= nil then
			for k=1, #tbl do local v = tbl[k]		
				v(stack,event)
			end
		end
	end 
	end
--[[done]]
local local_on_research = function(event)
	for k=1, #modmash.on_research do local v = modmash.on_research[k]
		v(event)
	end 
	end
--[[done]]
local local_on_chunk_charted = function(event)
	if is_map_editor == true then return end
	for k=1, #modmash.on_chunk_charted do local v = modmash.on_chunk_charted[k]
		v(event)
	end 
	end
local local_on_chunk_generated = function(event)
	if is_map_editor == true then return end
	for k=1, #modmash.on_chunk_generated do local v = modmash.on_chunk_generated[k]
		v(event)
	end 
	end
--[[done]]
local local_on_gui_click = function(event)
	for k=1, #modmash.on_gui_click do local v = modmash.on_gui_click[k]
		v(event)
	end 
	end
--[[done]]
local local_on_player_spawned = function(event)
	if is_map_editor == true then return end
	for k=1, #modmash.on_player_spawned do local v = modmash.on_player_spawned[k]
		v(event)
	end 
	end
--[[done]]
local local_on_start = function()
	log("control.local_on_start")	
	for k=1, #modmash.on_start do local v = modmash.on_start[k]	
		v()
	end 
	return true
	end
--[[done]]
local local_on_tick = function()
	if game.tick > 1 and run_init ~= true then run_init = local_on_start() end
	for k=1, #modmash.ticks do local v = modmash.ticks[k]	
		v()
	end 
	end
--[[done]]
local local_on_tick_low = function()
	for k=1, #modmash.ticks_low do local v = modmash.ticks_low[k]	
		v()
	end 
	end
--[[done]]
local local_on_tick_med = function()
	for k=1, #modmash.ticks_med do local v = modmash.ticks_med[k]	
		v()
	end 
	end
--[[done]]
local local_on_tick_high = function()
	for k=1, #modmash.ticks_high do local v = modmash.ticks_high[k]
		v()
	end 
	end

local local_on_post_entity_died = function(event)
	for k=1, #modmash.on_post_entity_died  do local v = modmash.on_post_entity_died [k]
		v(event)
	end 
	end

local local_on_ai_command_completed	= function(event)
	for k=1, #modmash.on_ai_command_completed do local v = modmash.on_ai_command_completed[k]
		v(event)
	end
end

--[[done]]
local local_on_selected = function(event)
	player = game.players[event.player_index]
	entity = player.selected
	if is_valid(entity) ~= true then return end
	for k=1, #modmash.on_selected do local v = modmash.on_selected[k]
		v(player,entity)
	end
	local on_selected_by_name = modmash.on_selected_by_name[entity.name]
	if on_selected_by_name ~= nil then
		for k=1, #on_selected_by_name do local v = on_selected_by_name[k]		
			v(player, entity)
		end
	end
	end

	--[[done]]
local local_on_player_cursor_stack_changed = function(event)
	for k=1, #modmash.on_player_cursor_stack_changed do local v = modmash.on_player_cursor_stack_changed[k]
		v(event)
	end
	end

--[[done]]
local local_on_train_changed_state = function(event)
	for k=1, #modmash.on_train_changed_state do local v = modmash.on_train_changed_state[k]
		v(event)
	end	
	end


local local_on_trigger_created_entity = function(event)					
	local entity = event.entity	
	if entity ~= nil then	
		for k=1, #modmash.on_trigger_created_entity do local v = modmash.on_trigger_created_entity[k]		
			v(event)
		end
	end end
	
--[[done]]
local local_on_player_rotated_entity = function(event)
	local_on_standard_entity_event(event.entity,modmash.on_player_rotated_entity,on_player_rotated_entity_by_name)
	end
	
--[[done]]
local local_on_adjust = function(event)
	player = game.players[event.player_index]
	entity = player.selected
	local_on_standard_entity_event(entity,modmash.on_adjust,modmash.on_adjust_by_name)
	end

script.on_event(defines.events.on_player_toggled_map_editor,function(event)
	if is_map_editor == true then is_map_editor = false
	else is_map_editor = true end
	end)


script.on_event({on_player_joined_game,defines.events.on_player_created},local_on_player_spawned)
script.on_event(build_events, local_on_added)
script.on_event(remove_events, local_on_removed)
script.on_event(item_pick_up_events, local_item_pick_up)
script.on_event(defines.events.on_entity_damaged,local_on_damage)
script.on_event(defines.events.on_research_finished, local_on_research)
script.on_event(defines.events.on_player_cursor_stack_changed,local_on_player_cursor_stack_changed)
script.on_event(defines.events.on_entity_spawned, local_on_spawned)
script.on_event(defines.events.on_chunk_charted,local_on_chunk_charted)
script.on_event(defines.events.on_chunk_generated,local_on_chunk_generated)
script.on_event(defines.events.on_train_changed_state,local_on_train_changed_state)
script.on_event(defines.events.on_tick, local_on_tick)
script.on_event(defines.events.on_ai_command_completed, local_on_ai_command_completed)
script.on_event(defines.events.on_trigger_created_entity, local_on_trigger_created_entity)

script.on_nth_tick(low_priority, local_on_tick_low)
script.on_nth_tick(medium_priority, local_on_tick_med)
script.on_nth_tick(high_priority, local_on_tick_high)

script.on_event(defines.events.on_gui_click, local_on_gui_click)
script.on_event(defines.events.on_selected_entity_changed,local_on_selected)	
script.on_event(defines.events.on_post_entity_died,local_on_post_entity_died)
script.on_event(defines.events.on_player_rotated_entity,local_on_player_rotated_entity) 
script.on_event("automate-target",local_on_adjust)

script.on_event(defines.events.on_entity_cloned,local_on_entity_cloned) 