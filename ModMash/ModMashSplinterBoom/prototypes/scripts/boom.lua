require ("prototypes.scripts.defines")

local mod_gui = require("__core__/lualib/mod-gui")

local is_valid  = modmashsplinterboom.util.is_valid
local print = modmashsplinterboom.util.print

local local_init = function()	
	if global.modmashsplinterboom.landmines == nil then global.modmashsplinterboom.landmines = {} end	
	if global.modmashsplinterboom.landmines.highlights == nil then global.modmashsplinterboom.landmines.highlights = {} end
	end

local local_load = function()	
	if global.modmashsplinterboom.landmines ~= nil then landmines = global.modmashsplinterboom.landmines end
	end

local local_create_element = function(parent,type,name,caption,tooltip)
	if not (parent and parent.valid) then return nil end
	local element = {}
	element.type    = type
	element.name    = name
	element.caption = caption
	element.tooltip = tooltip
	return element
	end
	
local local_add_sprite_button = function(parent, name, sprite, tooltip, style)
	local element = local_create_element(parent,"sprite-button", name, nil,tooltip)
	if element == nil then return nil end
	element.style = style or "button"
	element.sprite = sprite
	return parent.add(element)
	end

local local_update_gui = function()
	local inner_update_by_surface = function(pi)
		local player = game.players[pi]
		local surface = game.players[pi].surface

		local button_flow =  mod_gui.get_button_flow(player)
		local any = false
		for k=1 , #global.modmashsplinterboom.landmines do local lm = global.modmashsplinterboom.landmines[k]
			if is_valid(lm) and lm.surface == player.surface then
				any = true
				break
			end			
		end
		if any == true then
			for k = #button_flow.children, 1, -1 do
				local button = button_flow.children[k]
				if button and button.name == "landmine-toggle-button" then
					return
				end
			end
			local_add_sprite_button(button_flow, "landmine-toggle-button","landmine-button-gui",{"gui.modmash-landmine-detonate-tooltip"},"landmine-icon-button")
		else
			for k = #button_flow.children, 1, -1 do
				local button = button_flow.children[k]
				if button and button.name == "landmine-toggle-button" then
					button.destroy()
					return
				end
			end
		end
	end

	local inner_update = function(pi)
		local button_flow =  mod_gui.get_button_flow(game.players[pi])
		
		if #global.modmashsplinterboom.landmines > 0 then
			for k = #button_flow.children, 1, -1 do
				local button = button_flow.children[k]
				if button and button.name == "landmine-toggle-button" then
					return
				end
			end
			local_add_sprite_button(button_flow, "landmine-toggle-button","landmine-button-gui",{"gui.modmash-landmine-detonate-tooltip"},"landmine-icon-button")
		else
			for k = #button_flow.children, 1, -1 do
				local button = button_flow.children[k]
				if button and button.name == "landmine-toggle-button" then
					button.destroy()
					return
				end
			end
		end
	end
	if settings.global["setting-surface-detination"].value == "Current" then
		for k=1 , #game.players do
			inner_update_by_surface(k)
		end	
	else
		for k=1 , #game.players do
			inner_update(k)
		end	
	end
	end

local local_landmine_added = function(entity)
	if entity.type == "land-mine"  then		
		table.insert(global.modmashsplinterboom.landmines, entity)		
		local_update_gui()
	end	
end

local local_landmine_removed = function(entity)
	if entity.type == "land-mine"  then				
		for k=0, #global.modmashsplinterboom.landmines do local landmine = global.modmashsplinterboom.landmines[k]
			if  landmine == entity then
				table.remove(global.modmashsplinterboom.landmines, index)		
				local_update_gui()
				return
			end
		end
	end	
	local_update_gui()
end

local local_damage_table = {}
local_damage_table["land-mine"] = {damage=250,area=1.75}
local_damage_table["nuclear-land-mine"] = {damage=400,area=4}


local local_get_damage = function(landmine)
	if local_damage_table[landmine.name] ~= nil then return local_damage_table[landmine.name] end
	return {damage=250,area=1.75}
end

local local_landmine_on_gui_click = function(event)
	if event.element.name == "landmine-toggle-button" then
		local copy = {}
		for k=1 , #global.modmashsplinterboom.landmines do
			table.insert(copy,global.modmashsplinterboom.landmines[k])
		end
		global.modmashsplinterboom.landmines = {}
		
		if settings.global["setting-surface-detination"].value == "Current" then
			local surface = game.players[event.player_index].surface
			for k = 1, #copy do local landmine = copy[k]			
				if is_valid(landmine) and landmine.surface == surface then
					local p = landmine.position
					local s = landmine.surface
					local d = local_get_damage(landmine)
					landmine.die()
				else
					table.insert(global.modmashsplinterboom.landmines,landmine)
				end
			end
		else

			for k = 1, #copy do local landmine = copy[k]
			
				if is_valid(landmine) then
					local p = landmine.position
					local s = landmine.surface
					local d = local_get_damage(landmine)
					landmine.die()
				end
			end
		end
		local_update_gui()
	end
	end

local local_on_player_changed_surface = function(event)
	local_update_gui()
	end
local local_on_runtime_mod_setting_changed = function(event)
	local_update_gui()
	end

	

local local_on_entity_selected = function(event)
	local player = game.players[event.player_index]
	local entity = player.selected	
	local player_index = player.index
	if global.modmashsplinterboom.landmines.highlights == nil then global.modmashsplinterboom.landmines.highlights = {} end
	if is_valid(entity) and entity.name == "nuclear-land-mine" then		
		if global.modmashsplinterboom.landmines.highlights[player_index] ~= nil then
			rendering.destroy(global.modmashsplinterboom.landmines.highlights[player_index])
		end
		local id = rendering.draw_circle
		{
			surface = entity.surface,
			players = {player},
			filled = true,
			color = {r = 1, g = 0.1, b = 0, a = 0.1},
			draw_on_ground = true,
			width = 36,
			filled = false,
			target = entity,
			only_in_alt_mode = false,
			radius = 36,
			time_to_live = 60*10
		}
		global.modmashsplinterboom.landmines.highlights[player_index] = id
	elseif global.modmashsplinterboom.landmines.highlights[player_index] ~= nil then
		rendering.destroy(global.modmashsplinterboom.landmines.highlights[player_index])
	end
end


local local_land_mine_filter = { {filter = "type", type = "land-mine" }}
script.on_init(local_init)
script.on_load(local_load)

script.on_event(defines.events.on_runtime_mod_setting_changed,local_on_runtime_mod_setting_changed)

script.on_event(defines.events.on_player_changed_surface,local_on_player_changed_surface)

script.on_event(defines.events.on_selected_entity_changed,local_on_entity_selected)

script.on_event(defines.events.on_entity_died,
	function(event) 
		if is_valid(event.entity) then local_landmine_removed(event.entity) end 
	end,local_land_mine_filter)

script.on_event(defines.events.on_robot_mined_entity,
	function(event) 
		if is_valid(event.entity) then local_landmine_removed(event.entity) end 
	end,local_land_mine_filter)

script.on_event(defines.events.on_player_mined_entity,
	function(event) 
		if is_valid(event.entity) then local_landmine_removed(event.entity) end 
	end,local_land_mine_filter)
script.on_event(defines.events.script_raised_revive,
	function(event) 
		if is_valid(event.entity) then local_landmine_added(event.entity) end 
	end,local_land_mine_filter)
script.on_event(defines.events.on_robot_built_entity,
	function(event) 
		if is_valid(event.created_entity) then local_landmine_added(event.created_entity) end 
	end,local_land_mine_filter)
script.on_event(defines.events.on_built_entity,
	function(event) 
		if is_valid(event.created_entity) then local_landmine_added(event.created_entity) end 
	end,local_land_mine_filter)
script.on_event(defines.events.script_raised_built,
	function(event) 
		if is_valid(event.created_entity) then local_landmine_added(event.entity) end 
	end,local_land_mine_filter)

script.on_event(defines.events.on_gui_click, local_landmine_on_gui_click)