local mod_gui =  require("__core__/lualib/mod-gui")

local is_valid  = modmash.util.is_valid

local local_init = function()	
	if global.modmash.landmines == nil then global.modmash.landmines = {} end	
	if global.modmash.landmines.highlights == nil then global.modmash.landmines.highlights = {} end
	end

local local_load = function()	
	if global.modmash.landmines ~= nil then landmines = global.modmash.landmines end
	end

local local_on_configuration_changed = function(f)
	local_init()
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
	local inner_update = function(pi)
		local button_flow =  mod_gui.get_button_flow(game.players[pi])
		
		if #global.modmash.landmines > 0 then
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
	for k=1 , #game.players do
		inner_update(k)
	end	
	end

	
	

local local_landmine_added = function(entity)
	
	if entity.type == "land-mine"  then		
		table.insert(global.modmash.landmines, entity)		
		local_update_gui()
	end	
end

local local_landmine_removed = function(entity)
	if entity.type == "land-mine"  then				
		for k=0, #global.modmash.landmines do local landmine = global.modmash.landmines[k]
			if  landmine == entity then
				table.remove(global.modmash.landmines, index)		
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

function landmine_on_gui_click(event)
	if event.element.name == "landmine-toggle-button" then
		local copy = {}
		for k=1 , #global.modmash.landmines do
			table.insert(copy,global.modmash.landmines[k])
		end
		global.modmash.landmines = {}
		local_update_gui()

		for k = 1, #copy do local landmine = copy[k]
			if is_valid(landmine) then
				local p = landmine.position
				local s = landmine.surface
				local d = local_get_damage(landmine)
				landmine.die()
			end
		end
		
	end
	end

local local_on_entity_selected = function(player,entity)
	local player_index = player.index
	if global.modmash.landmines.highlights == nil then global.modmash.landmines.highlights = {} end
	if is_valid(entity) and entity.name == "nuclear-land-mine" then		
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
			radius = 36
			--left_top = area[1],
			--right_bottom = area[2]
		}
		global.modmash.landmines.highlights[player_index] = id
	elseif global.modmash.landmines.highlights[player_index] ~= nil then
		rendering.destroy(global.modmash.landmines.highlights[player_index])
	end
end

local control = {
	on_init = local_init,
	on_load = local_load,
	on_added = local_landmine_added,
	on_removed = local_landmine_removed,
	on_configuration_changed = local_on_configuration_changed,
	on_selected = local_on_entity_selected
}

modmash.register_script(control)