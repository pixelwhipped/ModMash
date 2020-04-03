if not wiki then wiki = {} end
if not wiki.events then wiki.events = {} end
if not wiki.events.click_events then wiki.events.click_events = {} end
if not wiki.events.select_events then wiki.events.select_events = {} end
if not wiki.topics then wiki.topics = {} end
if not wiki.last_location then wiki.last_location = {64,64} end

if not wiki.mods then 
	wiki.mods = {"All"} 
end

if not wiki.descriptions then wiki.descriptions = {} end

require("prototypes.scripts.util")
require("__core__/lualib/mod-gui")

local table_contains = wiki.util.table_contains
local booktorio_posted = false

local local_create_element = function(parent,type,name,caption,tooltip)
	if not (parent and parent.valid) then return nil end
	local element = {}
	element.type    = type
	element.name    = name
	element.caption = caption
	element.tooltip = tooltip
	return element
	end

local local_add_frame_or_flow = function(parent, type, name, caption, direction, style)
	local element = local_create_element(parent,type, name, caption,nil)
	if element == nil then return nil end
	element.style = style
	element.direction = direction
	return parent.add(element)	
	end

local local_add_frame = function(parent, name, caption, direction, style)
	return local_add_frame_or_flow(parent, "frame", name, caption, direction, style)
	end

local local_add_flow = function(parent, name, direction, style)
	return local_add_frame_or_flow(parent, "flow", name, nil, direction, style)
	end

local local_add_scroll_pane = function(parent, name, horizontal_scroll_policy, vertical_scroll_policy,style)
	local element = local_create_element(parent,"scroll-pane", name, nil,nil)
	if element == nil then return nil end
	element.horizontal_scroll_policy = horizontal_scroll_policy or "never"
	element.vertical_scroll_policy = vertical_scroll_policy or "auto-and-reserve-space"
	element.style = style or "wiki-description-flow"
	return parent.add(element)
	end

local local_add_dropdown_or_list = function(parent, type, name, items, selected_index,style)
	local element = local_create_element(parent,type, name, nil,nil)
	if element == nil then return nil end
	element.items = items or {"Empty"}
	element.selected_index = selected_index or 1
	element.style = style or "dropdown"
	return parent.add(element)
	end

local local_add_dropdown = function(parent, name, items, selected_index)
	return local_add_dropdown_or_list(parent, "drop-down",name, items, selected_index,"dropdown")
	end

local local_add_list = function(parent, name, items, selected_index)
	return local_add_dropdown_or_list(parent, "list-box", name, items, selected_index,"list_box")
	end

local local_add_label = function(parent, name, caption, style)
	local element = local_create_element(parent,"label", name, caption,nil)
	if element == nil then return nil end
	element.style = style or "label"
	return parent.add(element)
	end

local local_add_sprite_button = function(parent, name, sprite, tooltip, style)
	local element = local_create_element(parent,"sprite-button", name, nil,tooltip)
	if element == nil then return nil end
	element.style = style or "button"
	element.sprite = sprite
	return parent.add(element)
	end

local local_add_text_button = function(parent, name, caption, style)
	local element = local_create_element(parent,"button", name, nil,tooltip)
	if element == nil then return nil end
	element.style = style or "button"
	element.caption = caption
	return parent.add(element)
	end

local local_add_line = function(parent, name, direction, style)
	local element = local_create_element(parent,"line", name, nil,nil)
	if element == nil then return nil end
	element.style = style or "line"
	element.direction = direction or "horizontal"
	return parent.add(element)
	end

local local_add_sprite = function(parent, name, sprite, style)
	local element = local_create_element(parent,"sprite", name, nil,nil)
	if element == nil then return nil end
	element.style = style or nil
	element.sprite = sprite
	return parent.add(element)
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

local local_get_wiki_frame_from = function(player_gui)
	for k = #player_gui.children, 1, -1 do
		local ui = player_gui.children[k]
		if ui and ui.name == "wiki-main-frame" then
			return ui
		end
	end
	return nil
	end

local local_get_wiki_frame = function(player_index)
	local ui = local_get_wiki_frame_from(game.players[player_index].gui.screen)
	if ui ~= nil then return ui end
	return  local_get_wiki_frame_from(game.players[player_index].gui.center)
end

local local_get_wiki_main_flow = function(player_index)	
	local wiki_frame = local_get_wiki_frame(player_index)
	for k = #wiki_frame.children, 1, -1 do
		local ui = wiki_frame.children[k]
		if ui and ui.name == "wiki-main-flow" then
			return ui
		end
	end
	return nil
	end

local local_get_wiki_info_pane = function(player_index)	
	local wiki_frame = local_get_wiki_main_flow(player_index)
	for k = #wiki_frame.children, 1, -1 do
		local ui = wiki_frame.children[k]
		if ui and ui.name == "wiki-info-pane" then
			return ui
		end
	end
	return nil
	end

local local_remove_wiki_frame = function(player_index)
	local ui = local_get_wiki_frame(player_index)
	if ui ~= nil then
		if ui.location ~= nil then wiki.last_location = ui.location end
		ui.destroy()
		return true
	end
	return false
	end

local local_get_wiki_threads = function()
	local threads = {}

	for i = 1, #wiki.topics do local topic = wiki.topics[i]
		local desc = wiki.descriptions[topic]
		local thread = threads[desc.mod]	
		local thread_str = desc.title
		local thread_localized = type(thread_str) == "table"
		if thread == nil then 
			thread = {
				name = thread_str,
				localized = thread_localized,
				topics = {}
			}
		end
		local topic = {
				name = wiki.topics[i],
				topic = {}
			}
		for j = 1, #desc do local element = desc[j]			
			if element.type == "title" or element.type == "subtitle" then
					local str = element.title
					local localized = type(str) == "table"
					table.insert(topic.topic,
					{
						type = "title", title = str , localized = localized
					})
			elseif element.type == "image" then
				table.insert(topic.topic,
					{
						type = "image", spritename = element.name
					})
			elseif element.type == "text" then
					local str = element.text
					local localized = type(str) == "table"
					table.insert(topic.topic,
					{
						type = "text", text = str , localized = localized
					})
			end
		end
		table.insert(thread.topics,topic)
		threads[desc.mod] = thread
	end
	return threads
	end

local local_post_to_booktorio = function(event)	
	local settings = game.players[event.player_index].mod_settings	
	if booktorio_posted ~= true and #wiki.topics > 0 and settings["wiki-defer-booktorio"] and settings["wiki-defer-booktorio"].value then
		if remote.interfaces["Booktorio"] then			
			local threads = local_get_wiki_threads()			
			if threads ~= nil then
				for _, thread in pairs(threads) do
					remote.call("Booktorio", "add_thread", thread) 
				end
			end
		end
	end
	booktorio_posted = true
	end

function wiki_on_runtime_mod_setting_changed(event)
	if event.setting_type == "runtime-per-user" and event.setting == "wiki-enable-disable" then
		local_remove_toggle_button(event.player_index)	
		if game.players[event.player_index].mod_settings["wiki-enable-disable"].value then		
			local_remove_wiki_frame(event.player_index)
		else
			wiki_initialize(event)
		end
	end
	if event.setting_type == "runtime-per-user" and event.setting == "wiki-defer-booktorio" then
		if game.players[event.player_index].mod_settings["wiki-defer-booktorio"].value then	
			local_post_to_booktorio(event) 
		end
	end
	end

function wiki_initialize(event)
	local button_flow =  mod_gui.get_button_flow(game.players[event.player_index])
	local settings = game.players[event.player_index].mod_settings
	local_remove_toggle_button(event.player_index)
	if #wiki.topics == 0  or (settings["wiki-enable-disable"] and settings["wiki-enable-disable"].value) then 				
		local_remove_wiki_frame(event.player_index)
	else
		local_add_sprite_button(button_flow, "wiki-toggle-button","wiki-open-gui",{"gui.wiki-open-tooltip"},"wiki-icon-button")
	end
	if settings["wiki-defer-booktorio"].value then	
		local_post_to_booktorio(event) 
	end
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
				mod = wiki_data.name,
				title = wiki_data.title
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
					elseif element.type == "custom" then
						if element.interface == nil or element.interface == '' then
							wiki.util.log("Skipping Mod " .. wiki_data.name .. " missing interface in ".. item.name)
							return	
						elseif element.func == nil or element.func == '' then
							wiki.util.log("Skipping Mod " .. wiki_data.name .. " missing func in ".. item.name)
							return	
						else
							text_index = text_index + 1
							table.insert(desc,{
								type = "custom",
								func = element.func,
								interface = element.interface
								})
						end
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
	for element_name, callback in pairs(wiki.events.click_events) do
		if element_name == event.element.name then 
			callback(event)
		end
	end
	end

local local_add_image_to_descrption_pane = function(pane, sprite, index)
	local image_flow = local_add_flow(pane, "wiki-image-flow-" .. index,"horizontal","wiki-image-flow")
	local_add_sprite(image_flow,"wiki-preview-" .. index, sprite)
	end

local local_add_title_to_descrption_pane = function(pane, title, index)
	local title_flow = local_add_flow(pane, "title-flow-"..index,"horizontal","wiki-title-flow")
	local_add_label(title_flow, "wiki-description-title-"..index, title,"wiki-description-label")
	local_add_line(pane, "wiki-title-line-"..index,nil,"dark_line")
	end

local local_add_custom = function(pane,name,interface,func)
	local custom_flow = local_add_flow(pane, name,"horizontal","horizontal_flow")
	local call = function(i,f,cf)		
		remote.call(i,f,cf)
	end	
	local status, retval = pcall(call,interface,func,custom_flow)
	if status == false then 
		name = name or ""
		wiki.util.log("Adding remote UI elemennt failed "..name)
	end
	end

local local_change_wiki_description = function(event)
	local list = event.element
	if list and list.valid then	
		local topic = wiki.descriptions[wiki.topics[list.selected_index]]			
		local wiki_info_pane = local_get_wiki_info_pane(event.player_index)
		local image_index = 0 
		local text_index = 0
		local title_index = 0
		local line_index = 0
		local custom_index = 0
		if topic and wiki_info_pane then
			wiki_info_pane.clear()
			for _, element in pairs(topic) do		
				if element.type == "image" then				
					image_index = image_index + 1
					local_add_image_to_descrption_pane(wiki_info_pane,element.name,image_index)
				elseif element.type == "text" then
					text_index = text_index + 1
					local_add_label(wiki_info_pane,"wiki-description-" .. text_index, element.text, "wiki-description-label")
				elseif element.type == "title" then
					title_index = title_index + 1
					local_add_title_to_descrption_pane(wiki_info_pane,element.title,title_index)
				elseif element.type == "line" then
					line_index = line_index + 1
					local_add_line(wiki_info_pane,"wiki-line-"..line_index)
				elseif element.type == "custom" then					
					custom_index = custom_index + 1
					local_add_custom(wiki_info_pane,"wiki-custom-"..custom_index,element.interface,element.func)
				end
			end
		end
	end
	end

local local_create_wiki = function(event, mod_filter)	
	mod_filter = mod_filter or "All"
	local player_gui_center = game.players[event.player_index].gui.screen	
	local wiki_frame = local_add_frame(player_gui_center, "wiki-main-frame", {"gui.wiki-name"},"vertical", "wiki-window")
	local wiki_main_flow = local_add_flow(wiki_frame, "wiki-main-flow","horizontal","wiki-window-flow")
	local button_flow = local_add_flow(wiki_frame, "wiki-button-flow","horizontal","wiki-bottom-button-flow")
	
	local_add_text_button(button_flow,"wiki-close", {"gui.wiki-close"}, "button")
	local element = { type = "empty-widget", style = "wiki-bottom-filler"} 
	button_flow.add(element)

	local left_flow = local_add_flow(wiki_main_flow,"wiki-left-flow","vertical","wiki-left-window-flow")
	local_add_line(wiki_main_flow,"wiki-main-flow-line","vertical")
	local mods_left_flow = local_add_flow(left_flow, "wiki-left-flow","horizontal","horizontal_flow")	
	local_add_label(mods_left_flow, "wiki-mods-title", {"gui.wiki-mod-list-title"},"caption_label")	

	local selected_mod_index = 1
	for i = 1, #wiki.mods do
		if mod_filter == wiki.mods[i] then
			selected_mod_index = i
		end
	end
	local_add_dropdown(mods_left_flow, "wiki-list-mods", wiki.mods, selected_mod_index)	

	local_add_label(left_flow, "wiki-list-title", {"gui.wiki-topic-list-title"},"caption_label")		
	local_add_line(left_flow,"wiki-title-line")
	
	local active_topics = {}
	if mod_filter == "All" then
		active_topics = wiki.topics
	else
		for k = 1, #wiki.topics do local topic = wiki.topics[k]
			if wiki.descriptions[topic].title == mod_filter then
				if table_contains(active_topics,topic) == false then
					table.insert(active_topics,topic)
				end			
			end
		end
	end

	local topic_list = local_add_list(left_flow, "wiki-topics-list", active_topics)
	
	local_add_scroll_pane(wiki_main_flow,"wiki-info-pane", "never", "auto-and-reserve-space","wiki-description-flow")
	
	local_change_wiki_description({element = topic_list, player_index = event.player_index})
	
	game.players[event.player_index].opened =	wiki_frame
	if wiki_frame.location ~= nil then wiki_frame.location = wiki.last_location end
	end

local local_toggle_wiki = function(event)
	if local_remove_wiki_frame(event.player_index) == false then
		local_create_wiki(event)	
	end
	end

local local_close_wiki = function(event) local_remove_wiki_frame(event.player_index) end

local local_change_wiki_mod_filter = function(event)
	local list = event.element
	local mod=nil
	if list and list.valid then
		mod = wiki.mods[list.selected_index]
	end
	local_remove_wiki_frame(event.player_index)	
	local_create_wiki(event,mod)		
	end

wiki.events.click_events["wiki-toggle-button"] = local_toggle_wiki
wiki.events.click_events["wiki-close"] = local_close_wiki
wiki.events.select_events["wiki-topics-list"] = local_change_wiki_description
wiki.events.select_events["wiki-list-mods"] = local_change_wiki_mod_filter