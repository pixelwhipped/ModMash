log("Entering control.lua")

if not coffee then coffee = {} end

if not coffee.force_configuration_change then coffee.force_configuration_change = false end
if not coffee.ticks then coffee.ticks = {} end
if not coffee.ticks_low then coffee.ticks_low = {} end
if not coffee.ticks_med then coffee.ticks_med = {} end
if not coffee.ticks_high then coffee.ticks_high = {} end

if not coffee.on_added then coffee.on_added = {} end
if not coffee.on_added_by_name then coffee.on_added_by_name = {} end
if not coffee.on_removed then coffee.on_removed = {} end
if not coffee.on_removed_by_name then coffee.on_removed_by_name = {} end
if not coffee.on_pick_up then coffee.on_pick_up = {} end
if not coffee.on_pick_up_by_name then coffee.on_pick_up_by_name = {} end
if not coffee.on_init then coffee.on_init = {} end
if not coffee.on_load then coffee.on_load = {} end 
if not coffee.on_start then coffee.on_start = {} end
if not coffee.on_player_cursor_stack_changed then coffee.on_player_cursor_stack_changed = {} end
if not coffee.on_damage then coffee.on_damage = {} end 
if not coffee.on_damage_by_name then coffee.on_damage_by_name = {} end 
if not coffee.on_research then coffee.on_research = {} end 
if not coffee.on_selected then coffee.on_selected = {} end 
if not coffee.on_selected_by_name then coffee.on_selected_by_name = {} end 
if not coffee.on_spawned then coffee.on_spawned = {} end 
if not coffee.on_spawned_by_name then coffee.on_spawned_by_name = {} end 
if not coffee.on_chunk_charted then coffee.on_chunk_charted = {} end 
if not coffee.on_post_entity_died then coffee.on_post_entity_died = {} end 
if not coffee.on_gui_click then coffee.on_gui_click = {} end
if not coffee.on_player_spawned then coffee.on_player_spawned = {} end
if not coffee.on_adjust then coffee.on_adjust = {} end
if not coffee.on_adjust_by_name then coffee.on_adjust_by_name = {} end
if not coffee.on_player_rotated_entity then coffee.on_player_rotated_entity = {} end
if not coffee.on_player_rotated_entity_by_name then coffee.on_player_rotated_entity_by_name = {} end
if not coffee.on_configuration_changed then coffee.on_configuration_changed = {} end
if not coffee.on_train_changed_state then coffee.on_train_changed_state = {} end
if not coffee.on_ai_command_completed then coffee.on_ai_command_completed = {} end
if not coffee.on_trigger_created_entity then coffee.on_trigger_created_entity = {} end
if not coffee.on_entity_cloned then coffee.on_entity_cloned = {} end
if not coffee.on_player_used_capsule then coffee.on_player_used_capsule = {} end


local run_init = false

require("prototypes.scripts.defines") 
local build_events = coffee.events.on_build
local remove_events = coffee.events.on_remove
local item_pick_up_events = coffee.events.on_pick_up_item
local allow_pickup_rotations = coffee.defines.names.allow_pickup_rotations
local allow_fishing = coffee.defines.names.allow_fishing

local low_priority = coffee.events.low_priority
local medium_priority = coffee.events.medium_priority
local high_priority = coffee.events.high_priority

local is_map_editor = false

--[[standardized script controls]]

coffee.register_script = function(script)
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
		table.insert(coffee.on_init,script.on_init)
	end
	if script.on_configuration_changed ~= nil then 
		log("Registering configuration changed event")
		table.insert(coffee.on_configuration_changed,script.on_configuration_changed)
	end
	if script.on_gui_click ~= nil then 
		log("Registering gui click event")
		table.insert(coffee.on_gui_click,script.on_gui_click)
	end
	if script.on_load ~= nil then 
		log("Registering load event")
		table.insert(coffee.on_load,script.on_load)
	end
	if script.on_start ~= nil then 
		log("Registering start event")
		table.insert(coffee.on_start,script.on_start)
	end
	if script.on_added~= nil then 
		log("Registering spawned event")
		table.insert(coffee.on_added,script.on_added)
	end
	if script.on_train_changed_state ~= nil then 
		log("Registering train changed state event")
		table.insert(coffee.on_train_changed_state,script.on_train_changed_state)
	end
	if script.on_entity_cloned ~= nil then 
		log("Registering on entity cloned event")
		table.insert(coffee.on_entity_cloned,script.on_entity_cloned)
	end
	
	if script.on_player_cursor_stack_changed~= nil then 
		log("Registering player stack changed event")
		table.insert(coffee.on_player_cursor_stack_changed,script.on_player_cursor_stack_changed)
	end	
	if script.on_removed~= nil then 
		log("Registering removed event")
		table.insert(coffee.on_removed,script.on_removed)
	end
	if script.on_post_entity_died ~= nil then 
		log("Registering post entity died event")
		table.insert(coffee.on_post_entity_died,script.on_post_entity_died)
	end	
	if script.on_damage ~= nil then 
		log("Registering damage event")
		table.insert(coffee.on_damage,script.on_damage)
	end	
	if script.on_trigger_created_entity ~= nil then 
		log("Registering trigger entity created event")
		table.insert(coffee.on_trigger_created_entity,script.on_trigger_created_entity)
	end	
	
	if script.on_pick_up ~= nil then 
		log("Registering pick up event")
		table.insert(coffee.on_pick_up,script.on_pick_up)
	end		
	if script.on_research ~= nil then 
		log("Registering research event")
		table.insert(coffee.on_research,script.on_research)
	end	
	if script.on_selected ~= nil then 
		log("Registering selected event")
		table.insert(coffee.on_selected,script.on_selected)
	end
	if script.on_chunk_charted ~= nil then 
		log("Registering legacy chunk charted event")
		table.insert(coffee.on_chunk_charted,script.on_chunk_charted)
	end
	if script.on_spawned~= nil then 
		log("Registering spawned event")
		table.insert(coffee.on_spawned,script.on_spawned)
	end
	if script.on_player_spawned ~= nil then 
		log("Registering player spawned event")
		table.insert(coffee.on_player_spawned,script.on_player_spawned)
	end
	if script.on_adjust ~= nil then 
		log("Registering adjust event")
		table.insert(coffee.on_adjust,script.on_adjust)
	end
	if script.on_player_rotated_entity ~= nil then 
		log("Registering rotated entity event")
		table.insert(coffee.on_player_rotated_entity,script.on_player_rotated_entity)
	end
	if script.on_ai_command_completed ~= nil then 
		log("Registering ai command completed event")
		table.insert(coffee.on_ai_command_completed,script.on_ai_command_completed)
	end
	if script.on_player_used_capsule ~= nil then 
		log("Registering player used capsule event")
		table.insert(coffee.on_player_used_capsule,script.on_player_used_capsule)
	end
	
	
	if script.on_tick ~= nil then 
		if type(script.on_tick)=="table" and type(script.on_tick.tick) == "function" then
			log("Registering advanced tick event")
			if script.on_tick.priority ~= nil then
				if script.on_tick.priority == low_priority then
					table.insert(coffee.ticks_low,script.on_tick.tick)
				elseif script.on_tick.priority == med_priority then
					table.insert(coffee.ticks_med,script.on_tick.tick)
				elseif script.on_tick.priority == high_priority then
					table.insert(coffee.ticks_high,script.on_tick.tick)
				else
					log("Unknown priority")
					table.insert(coffee.ticks,script.on_tick.tick)
				end
			else
				table.insert(coffee.ticks,script.on_tick.tick)
			end
			if script.on_tick.table ~= nil and type(script.on_tick.table) == "function" and script.on_tick.auto_add_remove~= nil and type(script.on_tick.auto_add_remove) == "table" then 
				for k=1, #script.on_tick.auto_add_remove do local s = script.on_tick.auto_add_remove[k]
					log("Registering auto add remove "..s)
					register_event_for_in(coffee.on_added_by_name, function(entity) table.insert(script.on_tick.table(), entity) end,s)
					register_event_for_in(coffee.on_removed_by_name, function(entity) 
						local t = script.on_tick.table()
						table.remove(table, index_of(t, entity)) 
					end,s)	
				end
			end
		elseif type(script.on_tick) == "function" then
			log("Registering tick event")
			table.insert(coffee.ticks,script.on_tick)
		else
			log("Failed to register tick event")
		end
	end
	if script.names ~=nil then
		for k=1, #script.names do local s = script.names[k]		
			if script.on_added_by_name ~= nil and type(script.on_added_by_name) == "function" then 
				log("Registering added event for ".. s)
				register_event_for_in(coffee.on_added_by_name,script.on_added_by_name,s)
			end
			if script.on_removed_by_name ~= nil and type(script.on_removed_by_name) == "function" then 
				log("Registering removed event for ".. s)
				register_event_for_in(coffee.on_removed_by_name,script.on_removed_by_name,s)
			end
			if script.on_spawned_by_name ~= nil then 
				log("Registering spawned event for ".. s)
				register_event_for_in(coffee.on_spawned_by_name,script.on_spawned_by_name,s)
			end
			if script.on_damage_by_name ~= nil then 
				log("Registering damage event for ".. s)
				register_event_for_in(coffee.on_damage_by_name,script.on_damage_by_name,s)
			end
			if script.on_selected_by_name ~= nil then 
				log("Registering selected event for ".. s)
				register_event_for_in(coffee.on_selected_by_name,script.on_selected_by_name,s)
			end
			if script.on_pick_up_by_name ~= nil then 
				log("Registering pick up event for ".. s)
				register_event_for_in(coffee.on_pick_up_by_name,script.on_pick_up_by_name,s)
			end
			if script.on_adjust_by_name ~= nil then 
				log("Registering adjust event for ".. s)
				register_event_for_in(coffee.on_adjust_by_name,script.on_adjust_by_name,s)
			end
			if script.on_player_rotated_entity_by_name ~= nil then 
				log("Registering rotated entity event for ".. s)
				register_event_for_in(coffee.on_player_rotated_entity_by_name,script.on_player_rotated_entity_by_name,s)
			end
		end
	end
	end

--chunks should possibly be global

--[[Import utils]]
require("prototypes.scripts.util") 
local table_contains = coffee.util.table.contains
local table_index_of = coffee.util.table.index_of
local starts_with  = coffee.util.starts_with
local ends_with  = coffee.util.ends_with
local distance  = coffee.util.distance
local is_valid  = coffee.util.is_valid




--[[Called first time mod is added to current game instance. Called Once]]
local local_on_init = function()
	log("control.local_on_init")
	if global.coffee == nil then global.coffee = {allow_pickup_rotations = false} end	
	for k=1, #coffee.on_init do local v = coffee.on_init[k]		
		v()
	end
	global.coffee.initialized = true 
	end
script.on_init(local_on_init)


--[[Called subsequent times mod is loaded. Called each time except first instance]]
script.on_load(function()
	log("control.on_load")
	for k=1, #coffee.on_load do local v = coffee.on_load[k]		
		v()
	end 
	end)	

script.on_configuration_changed(function(f) 
	if f.mod_changes["coffee"] == nil or f.mod_changes["coffee"].old_version == nil then
		if coffee.force_configuration_change == true then
			log("Forcing update to " .. game.active_mods["coffee"])
			f.mod_changes["coffee"] = 
			{
				new_version = game.active_mods["coffee"],
				old_version = "0.18.00"
			} 
		else
			return
		end
	end

	log("control.on_configuration_changed " .. f.mod_changes["coffee"].old_version .. " -> " .. f.mod_changes["coffee"].new_version)
	for k=1, #coffee.on_configuration_changed do local v = coffee.on_configuration_changed[k]		
		v(f)
	end
	end)

require("prototypes.scripts.coffee")
require("prototypes.scripts.coffee-harvester")

local local_on_standard_entity_event = function(entity, table, table_by_name)	
	if is_map_editor == true then return end
	if is_valid(entity) then			
		for k=1, #table do local v = table[k]		
			v(entity)
		end
		if table_by_name ~= nil then
			local tbl = table_by_name[entity.name]
			if tbl ~= nil then
				for k=1, #tbl do local v = tbl[k]		
					v(entity)
				end
			end
		end
	end end

local local_on_entity_cloned = function (event)
	for k=1, #coffee.on_entity_cloned do local v = coffee.on_entity_cloned[k]		
		v(event)
	end 
end

--[[done]]
local local_on_added = function(event)	
	local_on_standard_entity_event(event.created_entity,coffee.on_added,coffee.on_added_by_name)
	end
--[[done]]
local local_on_spawned = function(event)
	local_on_standard_entity_event(event.entity,coffee.on_spawned,coffee.on_spawned_by_name)
	end
--[[done]]
local local_on_removed = function(event)
	local_on_standard_entity_event(event.entity,coffee.on_removed,coffee.on_removed_by_name)
	end
--[[done]]
local local_on_damage = function(event)
	local_on_standard_entity_event(event.entity,coffee.on_damage,coffee.on_damage_by_name)
	end
--[[done]]
local local_item_pick_up = function(event)
	if is_map_editor == true then return end
	local stack = event.item_stack
	if stack ~= nil then				
		for k=1, #coffee.on_pick_up do local v = coffee.on_pick_up[k]		
			v(stack)
		end
		local tbl = coffee.on_pick_up_by_name[stack.name]
		if tbl ~= nil then
			for k=1, #tbl do local v = tbl[k]		
				v(stack)
			end
		end
	end 
	end
--[[done]]
local local_on_research = function(event)
	for k=1, #coffee.on_research do local v = coffee.on_research[k]
		v(event)
	end 
	end
--[[done]]
local local_on_chunk_charted = function(event)
	if is_map_editor == true then return end
	for k=1, #coffee.on_chunk_charted do local v = coffee.on_chunk_charted[k]
		v(event)
	end 
	end
--[[done]]
local local_on_gui_click = function(event)
	for k=1, #coffee.on_gui_click do local v = coffee.on_gui_click[k]
		v(event)
	end 
	end
--[[done]]
local local_on_player_spawned = function(event)
	if is_map_editor == true then return end
	for k=1, #coffee.on_player_spawned do local v = coffee.on_player_spawned[k]
		v(event)
	end 
	end
--[[done]]
local local_on_start = function()
	log("control.local_on_start")	
	for k=1, #coffee.on_start do local v = coffee.on_start[k]	
		v()
	end 
	return true
	end
--[[done]]
local local_on_tick = function()
	if game.tick > 1 and run_init ~= true then run_init = local_on_start() end
	for k=1, #coffee.ticks do local v = coffee.ticks[k]	
		v()
	end 
	end
--[[done]]
local local_on_tick_low = function()
	for k=1, #coffee.ticks_low do local v = coffee.ticks_low[k]	
		v()
	end 
	end
--[[done]]
local local_on_tick_med = function()
	for k=1, #coffee.ticks_med do local v = coffee.ticks_med[k]	
		v()
	end 
	end
--[[done]]
local local_on_tick_high = function()
	for k=1, #coffee.ticks_high do local v = coffee.ticks_high[k]
		v()
	end 
	end

local local_on_post_entity_died = function(event)
	for k=1, #coffee.on_post_entity_died  do local v = coffee.on_post_entity_died [k]
		v(event)
	end 
	end

local local_on_ai_command_completed	= function(event)
	for k=1, #coffee.on_ai_command_completed do local v = coffee.on_ai_command_completed[k]
		v(event)
	end
end

local local_on_player_used_capsule	= function(event)
	for k=1, #coffee.on_player_used_capsule do local v = coffee.on_player_used_capsule[k]
		v(event)
	end
end


--[[done]]
local local_on_selected = function(event)
	player = game.players[event.player_index]
	entity = player.selected
	if is_valid(entity) ~= true then return end
	for k=1, #coffee.on_selected do local v = coffee.on_selected[k]
		v(player,entity)
	end
	local on_selected_by_name = coffee.on_selected_by_name[entity.name]
	if on_selected_by_name ~= nil then
		for k=1, #on_selected_by_name do local v = on_selected_by_name[k]		
			v(player, entity)
		end
	end
	end

	--[[done]]
local local_on_player_cursor_stack_changed = function(event)
	for k=1, #coffee.on_player_cursor_stack_changed do local v = coffee.on_player_cursor_stack_changed[k]
		v(event)
	end
	end

--[[done]]
local local_on_train_changed_state = function(event)
	for k=1, #coffee.on_train_changed_state do local v = coffee.on_train_changed_state[k]
		v(event)
	end	
	end


local local_on_trigger_created_entity = function(event)					
	local entity = event.entity	
	if entity ~= nil then	
		for k=1, #coffee.on_trigger_created_entity do local v = coffee.on_trigger_created_entity[k]		
			v(event)
		end
	end end
	
--[[done]]
local local_on_player_rotated_entity = function(event)
	local_on_standard_entity_event(event.entity,coffee.on_player_rotated_entity,on_player_rotated_entity_by_name)
	end
	
--[[done]]
local local_on_adjust = function(event)
	player = game.players[event.player_index]
	entity = player.selected
	local_on_standard_entity_event(entity,coffee.on_adjust,coffee.on_adjust_by_name)
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
script.on_event(defines.events.on_train_changed_state,local_on_train_changed_state)
script.on_event(defines.events.on_tick, local_on_tick)
script.on_event(defines.events.on_ai_command_completed, local_on_ai_command_completed)
script.on_event(defines.events.on_trigger_created_entity, local_on_trigger_created_entity)
script.on_event(defines.events.on_player_used_capsule, local_on_player_used_capsule)

script.on_nth_tick(low_priority, local_on_tick_low)
script.on_nth_tick(medium_priority, local_on_tick_med)
script.on_nth_tick(high_priority, local_on_tick_high)

script.on_event(defines.events.on_gui_click, local_on_gui_click)
script.on_event(defines.events.on_selected_entity_changed,local_on_selected)	
script.on_event(defines.events.on_post_entity_died,local_on_post_entity_died)
script.on_event(defines.events.on_player_rotated_entity,local_on_player_rotated_entity) 
script.on_event("automate-target",local_on_adjust)

script.on_event(defines.events.on_entity_cloned,local_on_entity_cloned) 