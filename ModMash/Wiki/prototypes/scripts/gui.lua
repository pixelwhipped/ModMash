if not wiki then wiki = {} end
if not wiki.events then wiki.events = {} end
if not wiki.events.click_events then wiki.events.click_events = {} end
if not wiki.events.select_events then wiki.events.select_events = {} end
if not wiki.pointers then wiki.pointers = {} end
if not wiki.topics then wiki.topics = {} end
if not wiki.mods then 
	wiki.mods = {"All"} 
end


if not wiki.descriptions then wiki.descriptions = {} end

require("prototypes.scripts.util")
require("__core__/lualib/mod-gui")

local table_contains = wiki.util.table_contains

local local_get_others_table = function(name, caption, tooltip, others)
	if type(name) == "table" then
		others = name
		name = others.name
	elseif type(caption) == "table" then 
		others = caption
		caption = others.caption
	elseif type(tooltip) == "table" then 
		others = tooltip
		tooltip = others.tooltip
	elseif not others then
		others = {}
	end
	return others
	end

local local_get_element_by_name = function(player_index, name)
	if not wiki.pointers[player_index] then wiki.pointers[player_index] = {} end
	if wiki.pointers[player_index][name] and wiki.pointers[player_index][name].valid then
		return wiki.pointers[player_index][name]
	end
	return nil
	end

local local_set_element_by_name = function(player_index, element, name)
	if not wiki.pointers[player_index] then wiki.pointers[player_index] = {} end
	if element and element.valid then
		name = name or element.name
		wiki.pointers[player_index][name] = element
	end
	end

local local_add_element = function(parent, e_type, name, caption, tooltip, others)
	if not (parent and parent.valid) then return nil end
	-- construct the element
	local element = {}
	element.type    = others.type or e_type
	element.name    = others.name or name
	element.caption = others.caption or caption
	element.tooltip = others.tooltip or tooltip
	element.enabled = others.enabled
	element.ignored_by_interaction = others.ignored_by_interaction
	element.style = others.style
		
	-- Button
	if element.type == "button" then
		element.mouse_button_filter = others.mouse_button_filter 
	end
		
	-- Sprite button
	if element.type == "sprite-button" then
		element.sprite = others.sprite
		element.hovered_sprite = others.hovered_sprite
		element.clicked_sprite = others.clicked_sprite
		element.number = others.number
		element.show_percent_for_small_numbers = others.show_percent_for_small_numbers
		element.mouse_button_filter = others.mouse_button_filter
	end
		
	-- Flow
	if element.type == "flow" then
		element.direction  = others.direction 
	end
		
	-- Frame
	if element.type == "frame" then
		element.direction = others.direction 
	end
		
	-- Table
	if element.type == "table" then
		element.column_count = others.column_count 
		element.draw_vertical_lines = others.draw_vertical_lines
		element.draw_horizontal_lines = others.draw_horizontal_lines
		element.draw_horizontal_line_after_headers = others.draw_horizontal_line_after_headers
		element.vertical_centering = others.vertical_centering
	end
		
	-- Textfield
	if element.type == "textfield" then
		element.text = others.text 
		element.numeric = others.numeric 
		element.allow_decimal = others.allow_decimal 
		element.allow_negative = others.allow_negative 
		element.is_password = others.is_password 
		element.lose_focus_on_confirm = others.lose_focus_on_confirm 
		element.clear_and_focus_on_right_click = others.clear_and_focus_on_right_click
	end
		
	-- Progressbar
	if element.type == "progressbar" then
		element.value = others.value or 0
	end
		
	-- Checkbox
	if element.type == "checkbox" then
		element.state = others.state or false
	end
		
	-- Radiobutton
	if element.type == "radiobutton" then
		element.value = others.value
	end
		
	-- Sprite
	if element.type == "sprite" then
		element.sprite = others.sprite
	end
		
	-- Scroll pane
	if element.type == "scroll-pane" then
		element.horizontal_scroll_policy = others.horizontal_scroll_policy
		element.vertical_scroll_policy = others.vertical_scroll_policy
	end
		
	-- Drop down
	if element.type == "drop-down" then
		element.items = others.items
		element.selected_index = others.selected_index
	end
		
	-- Line
	if element.type == "line" then
		element.direction = others.direction
	end
		
	-- List box
	if element.type == "list-box" then
		element.items = others.items
		element.selected_index = others.selected_index
	end
		
	-- Camera
	if element.type == "camera" then
		element.position = others.position
		element.surface_index = others.surface_index
		element.zoom = others.zoom
	end
		
	-- Choose elem button
	if element.type == "choose-elem-button" then
		element.elem_type = others.elem_type
		element.item = others.item
		element.tile = others.tile
		element.entity = others.entity
		element.signal = others.signal
		element.fluid = others.fluid
		element.recipe = others.recipe
		element.decorative = others.decorative
		element["item-group"] = others["item-group"]
		element.achievement = others.achievement
		element.equipment = others.equipment
		element.technology = others.technology
	end
		
	-- Text box
	if element.type == "text-box" then
		element.text = others.text
		element.clear_and_focus_on_right_click = others.clear_and_focus_on_right_click
	end
		
	-- Slider
	if element.type == "slider" then
		element.minimum_value = others.minimum_value
		element.maximum_value = others.maximum_value
		element.value = others.value
		element.value_step = others.value_step
		element.discrete_slider = others.discrete_slider
		element.discrete_values = others.discrete_values
	end
		
	-- Minimap
	if element.type == "minimap" then
		element.position = others.position
		element.surface_index = others.surface_index
		element.chart_player_index = others.chart_player_index
		element.force = others.force
		element.zoom = others.zoom
	end
		
	-- Tab
	if element.type == "tab" then
		element.badge_text = others.badge_text
	end
		
	-- Switch
	if element.type == "switch" then
		element.switch_state = others.switch_state
		element.allow_none_state = others.allow_none_state
		element.left_label_caption = others.left_label_caption
		element.left_label_tooltip = others.left_label_tooltip
		element.right_label_caption = others.right_label_caption
		element.right_label_tooltip = others.right_label_tooltip
	end		
		
	-- add the element		
	element = parent.add(element)
	local_set_element_by_name(element.player_index, element)		
	return element
	end

local local_add_menu = function(parent, name, caption, others)
	others = local_get_others_table(name, caption, nil, others)
	others.style = others.style or "menu_frame"
	return local_add_element(parent, "frame", name, caption, nil, others)
	end

local local_add_frame = function(parent, name, caption, others)
	others = local_get_others_table(name, caption, nil, others)
	others.style = others.style or nil
	return local_add_element(parent, "frame", name, caption, nil, others)
	end

local local_add_flow = function(parent, name, caption, others)
	others = local_get_others_table(name, caption, nil, others)
	others.style = others.style or "flow"
	return local_add_element(parent, "flow", name, caption, nil, others)
	end

local local_add_pane = function(parent, name, caption, others)
	others = local_get_others_table(name, caption, nil, others)
	others.style = others.style or "tabbed_pane"
	return local_add_element(parent, "tabbed-pane", name, caption, nil, others)
	end

local local_add_scroll_pane = function(parent, name, caption, others)
	others = local_get_others_table(name, caption, nil, others)
	others.style = others.style or "changelog_scroll_pane"
	return local_add_element(parent, "scroll-pane", name, caption, nil, others)
	end

local local_add_tab = function(parent, name, caption, others)
	others = local_get_others_table(name, caption, nil, others)
	others.style = others.style or "tab"
	return local_add_element(parent, "tab", name, caption, nil, others)
	end

local local_add_table = function(parent, name, caption, column_count, others)
	others = local_get_others_table(name, caption, nil, others)
	others.style = others.style or "removed_content_table"
	others.column_count = column_count or others.column_count or 1
	return local_add_element(parent, "table", name, caption, nil, others)
	end

local local_add_dropdown = function(parent, name, caption, others)
	others = local_get_others_table(name, caption, nil, others)
	others.style = others.style or "dropdown"
	return local_add_element(parent, "drop-down", name, caption, nil, others)
	end

local local_add_list = function(parent, name, caption, others)
	others = local_get_others_table(name, caption, nil, others)
	others.style = others.style or "list_box"
	return local_add_element(parent, "list-box", name, caption, nil, others)
	end

local local_add_label = function(parent, name, caption, tooltip, others)
	others = local_get_others_table(name, caption, tooltip, others)
	others.style = others.style or "label"
	return local_add_element(parent, "label", name, caption, tooltip, others)
	end

local local_add_description = function(parent, name, caption, tooltip, others)
	others = local_get_others_table(name, caption, tooltip, others)
	others.style = others.style or "wiki-description-label"
	return local_add_element(parent, "label", name, caption, tooltip, others)
	end

local local_add_text_button = function(parent, name, caption, tooltip, others)
	others = local_get_others_table(name, caption, tooltip, others)
	others.style = others.style or "button"
	return local_add_element(parent, "button", name, caption, tooltip, others)
	end

local local_add_confirm_button = function(parent, name, caption, tooltip, others)
	others = local_get_others_table(name, caption, tooltip, others)
	others.style = others.style or "confirm_button"
	return local_add_element(parent, "button", name, caption, tooltip, others)
	end

local local_add_back_button = function(parent, name, caption, tooltip, others)
	others = local_get_others_table(name, caption, tooltip, others)
	others.style = others.style or "red_back_button"
	return local_add_element(parent, "button", name, caption, tooltip, others)
	end

--used
local local_add_sprite_button = function(parent, name, sprite, tooltip, others)
	others = local_get_others_table(name, nil, tooltip, others)
	others.sprite = others.sprite or sprite
	others.style  = others.style or "button"
	return local_add_element(parent, "sprite-button", name, nil, tooltip, others)
	end

local local_add_line = function(parent, name, direction, others)
	others = local_get_others_table(name, nil, nil, others)
	others.direction = direction or others.direction or "horizontal"
	others.style = others.style or "line"
	return local_add_element(parent, "line", name, nil, tooltip, others)
	end

local local_add_sprite = function(parent, name, sprite, others)
	others = local_get_others_table(name, nil, nil, others)
	others.sprite = others.sprite or sprite
	others.style = others.style or nil
	return local_add_element(parent, "sprite", name, nil, nil, others)
	end

local local_remove_toggle_button = function(player_index)
	local button_flow =  mod_gui.get_button_flow(game.players[player_index])
	for k = #button_flow.children, 1, -1 do
		local button = button_flow.children[k]
		if button and button.name == "wiki-toggle-button" then
			button.destroy()
			return
		end
	end
	end

function wiki_on_runtime_mod_setting_changed(event)
	if event.setting_type == "runtime-per-user" and event.setting == "wiki-enable-disable" then
		local_remove_toggle_button(event.player_index)
		--local button = local_get_element_by_name(event.player_index, "wiki-toggle-button")		
		if game.players[event.player_index].mod_settings["wiki-enable-disable"].value then		
			--if button then button.parent.destroy() end
			local wiki_frame = local_get_element_by_name(event.player_index, "wiki-main-frame")
			if wiki_frame then wiki_frame.destroy()	end
		else
			wiki_initialize(event)
		end
	end
	end

function wiki_initialize(event)
	local button_flow =  mod_gui.get_button_flow(game.players[event.player_index])
	local settings = game.players[event.player_index].mod_settings
	local_remove_toggle_button(event.player_index)
	if #wiki.topics == 0  or (settings["wiki-enable-disable"] and settings["wiki-enable-disable"].value) then 				
		local wiki_frame = local_get_element_by_name(event.player_index, "wiki-main-frame")
		if wiki_frame then wiki_frame.destroy()	end
		return nil
	end
	-- main open button	
	local_add_sprite_button(button_flow, 
	{
		name    = "wiki-toggle-button",
		tooltip = {"gui.wiki-open-tooltip"},
		sprite  = "wiki-open-gui",
		style   = "wiki-icon-button"
	})
	end

function wiki_on_gui_selection_state_changed(event)
	for element_name, callback in pairs(wiki.events.select_events) do
			if element_name == event.element.name then 
				callback(event)
			end
		end
	end

local local_wiki_register_mod_wiki_control = function(wiki_data)
	wiki.util.log("Registering Wiki Data(Control)")
	if wiki_data.name == nil or wiki_data.name == '' then
		wiki.util.log("Skipping Mod(unknown) missing name")
		return
	end
	if wiki_data.title == nil or wiki_data.title == '' then
		wiki.util.log("Skipping Mod " .. wiki_data.name .. " missing title")
		return
	elseif table_contains(wiki.mods,wiki_data.title) == false then
		table.insert(wiki.mods,wiki_data.title)
	end	
	if wiki_data.mod_path == nil or wiki_data.mod_path == '' then		
		wiki.util.log("Skipping Mod " .. wiki_data.name .. " missing mod path")
	end
	local text_index = 0
	local title_index = 0
	for i = 1, #wiki_data do local item = wiki_data[i]
		if item == nil or item.name == nil or item.name == '' then
			wiki.util.log("Skipping Mod " .. wiki_data.name .. " missing topic name")
			return
		end
		if item.topic == nil then
			wiki.util.log("Skipping Mod " .. wiki_data.name .. " missing topic data")
			return
		else
			local desc = {
				mod = wiki_data.name
			}				
			for j = 1, #item.topic do local element = item.topic[j]
				if element ~= nil then
					if element.type == "image" then
						if element.filepath == nil or element.filepath == '' then
							wiki.util.log("Skipping Mod " .. wiki_data.name .. " missing image nil filepath in ".. topic.name )
							return
						elseif element.name == nil or element.name == '' then
							wiki.util.log("Skipping Mod " .. wiki_data.name .. " missing image nil name in ".. topic.name )
							return
						elseif element.width == nil or element.width <= 0 then
							wiki.util.log("Skipping Mod " .. wiki_data.name .. " (" .. element.filepath ..") invalid width in ".. topic.name )
							return
						elseif element.height == nil or element.height <= 0 then
							wiki.util.log("Skipping Mod " .. wiki_data.name .. " (" .. element.filepath ..") invalid height in ".. topic.name )
							return							
						else
							table.insert(desc,{
								type = "image",
								name = element.name
								})
						end
					elseif element.type == "line" then
						table.insert(desc,{type = "line"})
					elseif element.type == "text" then
						if element.text == nil or element.text == '' then
							wiki.util.log("Skipping Mod " .. wiki_data.name .. " missing text in ".. item.name)
							return	
						else
							text_index = text_index + 1
							table.insert(desc,{
								type = "text",
								text = element.text,
								name = wiki_data.name .. "-text-" ..text_index
								})
						end
					elseif element.type == "title" then
						if element.title == nil or element.title == '' then
							wiki.util.log("Skipping Mod " .. wiki_data.name .. " missing title in ".. item.name)
							return	
						else
							title_index = title_index + 1
							table.insert(desc,{
								type = "title",
								title = element.title,
								name = wiki_data.name .. "-title-" ..title_index
								})
						end
					end
				end
				--wiki.topics[item.name] = item.name
			end
			if table_contains(wiki.topics,item.name) == false then
				table.insert(wiki.topics,item.name)
			end
			wiki.descriptions[item.name] = desc
		end
	end

	end

local local_wiki_register_mod_wiki_data = function(wiki_data)
	wiki.util.log("Registering Wiki Data(Data)")
	if wiki_data.name == nil or wiki_data.name == '' then
		wiki.util.log("Skipping Mod(unknown) missing name")
		return
	end
	if not mods[wiki_data.name] then
		wiki.util.log("Skipping Mod " .. wiki_data.name .. " missing mod")
		return
	end	
	if wiki_data.title == nil or wiki_data.title == '' then
		wiki.util.log("Skipping Mod " .. wiki_data.name .. " missing title")
		return
	end	
	if wiki_data.mod_path == nil or wiki_data.mod_path == '' then
		wiki.util.log("Skipping Mod " .. wiki_data.name .. " missing mod path")
	end
	for i = 1, #wiki_data do local item = wiki_data[i]
		if item ~= nil then
			for j = 1, #item.topic do local element = item.topic[j]
				if element ~= nil then
					if element.type == "image" then
						if element.filepath == nil or element.filepath == '' then
							wiki.util.log("Skipping Mod " .. wiki_data.name .. " missing image nil filepath")
							return
						else
							wiki.util.log("Wiki adding image " .. element.name)
							data:extend(
							{
								{
									type     = "sprite",
									name     = element.name,
									filename = element.filepath,
									width    = element.width,
									height   = element.height,
									scale = element.scale
								}
							})
						end
					end
				end
			end
		end
	end

	end

function wiki_register_mod_wiki(wiki_data)
	if wiki.util.data_stage() == wiki.defines.data_stages.control then
		local_wiki_register_mod_wiki_control(wiki_data)
	else
		local_wiki_register_mod_wiki_data(wiki_data)
	end
	end



function wiki_on_gui_click(event)
	--wiki.util.print(#wiki.events.click_events)
	for element_name, callback in pairs(wiki.events.click_events) do
		if element_name == event.element.name then 
			callback(event)
		end
	end
	end

local local_create_wiki = function(event, mod_filter)	
	mod_filter = mod_filter or "All"
	local player_gui_center = game.players[event.player_index].gui.center
	
	-- Window
	local wiki_frame = local_add_frame(player_gui_center, 
	{
		name      = "wiki-main-frame", 
		caption   = {"gui.wiki-name"},
		direction = "vertical", 
		style     = "wiki-window"
	})

	-- Main Window Container 
	local wiki_main_flow = local_add_flow(wiki_frame, 
	{
		name      = "wiki-main-flow",
		direction = "horizontal",
		style     = "wiki-window-flow"
	})

	local back_button_flow = local_add_flow(wiki_frame, 
	{
		name      = "wiki-back-button-flow",
		direction = "horizontal",
		style     = "wiki-back-button-flow"
	})

	local inner_back_button_flow = local_add_flow(back_button_flow, 
	{
		name      = "wiki-inner-back-button-flow",
		direction = "horizontal",
		style     = "horizontal_flow"
	})

	-- Back button
	local_add_back_button(inner_back_button_flow, 
	{
		name    = "wiki-close", 
		caption = {"gui.wiki-close"},
		style   = "wiki-back-button"
	})

	--Filler
	local_add_element(back_button_flow,
		"empty-widget",
		"wiki-bottom-filler",
		nil,
		nil,
		{ style = "draggable_space_with_no_right_margin" }
	)

	-- Left container
	local left_flow = local_add_flow(wiki_main_flow, 
	{
		name      = "wiki-left-flow",
		direction = "vertical",
		style     = "wiki-left-window-flow"
	})
	
	--Mods
	local dd = local_add_dropdown(left_flow, 
	{
		name    = "wiki-list-mods", 
		items   = wiki.mods
	})	
	dd.selected_index = 1

	--Title
	local_add_label(left_flow, 
	{
		name    = "wiki-list-title", 
		caption = {"gui.wiki-topic-list-title"},
		style   = "caption_label"
	})	
	
	local_add_line(left_flow, 
	{
		name    = "wiki-title-line"
	})
	
	local active_topics = {}
	if mod_filter == "All" then
		active_topics = wiki.topics
	else
		for k = 1, #wiki.topics do local topic = wiki.topics[k]
			if wiki.descriptions[topic].mod == mod_filter then
				if table_contains(active_topics,topic) == false then
					table.insert(active_topics,topic)
				end			
			end
		end
	end
	
	-- Topics list
	local_add_list(left_flow, 
	{
		name    = "wiki-topics-list", 
		items   = active_topics
	})
	-- -- RIGHT
	----------------------------------
	-- Area where show topics
	local wiki_info_pane = local_add_scroll_pane(wiki_main_flow, 
	{
		name                     = "wiki-info-pane", 
		horizontal_scroll_policy = "never", 
		vertical_scroll_policy   = "auto-and-reserve-space",
		style                    = "wiki-description-flow"
	})

	local_add_description(wiki_info_pane, {name="wiki_info", caption={"gui.wiki-info-description"}})	
	
	-- Add window frame to main player opened wiki
	game.players[event.player_index].opened =	wiki_frame

	end

local local_remove_wiki_frame = function(player_index)
	local player_gui_center = game.players[player_index].gui.center
	for k = #player_gui_center.children, 1, -1 do
		local ui = player_gui_center.children[k]
		if ui and ui.name == "wiki-main-frame" then
			ui.destroy()
			return true
		end
	end
	return false
	end


local local_toggle_wiki = function(event)
	if local_remove_wiki_frame(event.player_index) == false then
		local_create_wiki(event)	
	end
	end

local local_close_wiki = function(event) local_remove_wiki_frame(event.player_index) end

local local_get_description_pane = function(event)
	local wiki_gui = local_get_element_by_name(event.player_index, "wiki-main-frame")
	if wiki_gui and wiki_gui.valid then
		local wiki_info_pane = local_get_element_by_name(event.player_index, "wiki-info-pane")
		if wiki_info_pane and wiki_info_pane.valid then
			wiki_info_pane.clear()
			return wiki_info_pane
		end
	end
	return nil
	end

local local_add_image_to_descrption_pane = function(pane, name, index)
	local image_flow = local_add_flow(pane, 
	{
		name      = "wiki-image-flow-" .. index,
		direction = "horizontal",
		style     = "wiki-image-flow"
	})
	--local_add_element(image_flow, "sprite", name, nil, nil, nil)
	local_add_sprite(image_flow,
	{
		name   = "wiki-preview-" .. index, 
		sprite = name
	})
	end


local local_add_text_to_descrption_pane = function(pane, text, index)
	local_add_description(pane,
	{
		name    = "wiki-description-" .. index, 
		caption = text
	})
	end

local local_add_title_to_descrption_pane = function(pane, title, index)
	-- Title flow
	local title_flow = local_add_flow(pane, 
	{
		name      = "title-flow-"..index,
		direction = "horizontal",
		style     = "wiki-title-flow"
	})
	-- Title
	local_add_label(title_flow, 
	{
		name    = "wiki-description-title-"..index, 
		caption = title,
		style   = "bold_label"
	})
	-- Separator line
	local_add_line(pane, 
	{
		name    = "wiki-title-line-"..index,
		style   = "dark_line"
	})
	end

local local_change_wiki_description = function(event)

	local list = event.element

	if list and list.valid then	
		local topic = wiki.descriptions[wiki.topics[list.selected_index]]			
		local wiki_info_pane = local_get_description_pane(event)
		local image_index = 0 
		local text_index = 0
		local title_index = 0
		local line_index = 0
		if topic and wiki_info_pane then
			for _, element in pairs(topic) do
				--wiki.util.print(serpent.block(element))
				if element.type == "image" then				
				image_index = image_index + 1
				local_add_image_to_descrption_pane(wiki_info_pane,element.name,image_index)
				elseif element.type == "text" then
				text_index = text_index + 1
				local_add_text_to_descrption_pane(wiki_info_pane,element.text,text_index)
				elseif element.type == "title" then
				title_index = title_index + 1
				local_add_title_to_descrption_pane(wiki_info_pane,element.title,title_index)
				elseif element.type == "line" then
					line_index = line_index + 1
					local_add_line(wiki_info_pane, 
					{
						name    = "wiki-line-"..line_index
					})
				end
			end
		end
	end
	end

local local_change_wiki_mod_filter = function(event)
	local wiki_gui = local_get_element_by_name(event.player_index, "wiki-main-frame")
	if wiki_gui and wiki_gui.valid then
		wiki_gui.destroy()
	end
	--wiki.util.print(serpent.block(event))
	local_create_wiki(event)		
	end

wiki.events.click_events["wiki-toggle-button"] = local_toggle_wiki
wiki.events.click_events["wiki-close"] = local_close_wiki
wiki.events.select_events["wiki-topics-list"] = local_change_wiki_description
wiki.events.select_events["wiki-list-mods"] = local_change_wiki_mod_filter