require("__core__/lualib/mod-gui")

local landmines = nil

local local_init = function()	
	if global.modmash.landmines == nil then global.modmash.landmines = {} end	
	landmines = global.modmash.landmines
	end

local local_load = function()	
	if global.modmash.landmines ~= nil then
		landmines = global.modmash.landmines
	end
	end

local local_on_configuration_changed = function(f)
	if f.mod_changes["modmash"].old_version < "0.18.39" then	
		global.modmash.landmines = {}	
		landmines = global.modmash.landmines
	end
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
		
		if #landmines > 0 then
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
		table.insert(landmines, entity)		
		local_update_gui()
	end	
end

local local_landmine_removed = function(entity)
	if entity.type == "land-mine"  then				
		for index, landmine in pairs(landmines) do
			if  landmine == entity then
				table.remove(landmines, index)		
				local_update_gui()
				return
			end
		end
	end	
	local_update_gui()
end

function landmine_on_gui_click(event)
	if event.element.name == "landmine-toggle-button" then
		local copy = {}
		for k=1 , #landmines do
			table.insert(copy,landmines[k])
		end
		landmines = {}
		local_update_gui()

		for k = 1, #copy do local landmine = copy[k]
			--if landmine ~= nil then
			local p = landmine.position
			local s = landmine.surface
			landmine.die()
			s.create_entity({ name = "grenade-explosion" , position = p })
			--end
		end
		
	end
	end

local control = {
	on_init = local_init,
	on_load = local_load,
	on_added = local_landmine_added,
	on_removed = local_landmine_removed,
	on_configuration_changed = local_on_configuration_changed,
}

modmash.register_script(control)