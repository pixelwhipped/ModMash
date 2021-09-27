require("prototypes.scripts.defines")
local mod_gui = require("mod-gui")
local distance = modmashsplinternewworlds.util.distance
local table_contains = modmashsplinternewworlds.util.table.contains
local table_length = modmashsplinternewworlds.util.table.length

local is_valid  = modmashsplinternewworlds.util.is_valid
local is_valid_and_persistant  = modmashsplinternewworlds.util.entity.is_valid_and_persistant

local starts_with  = modmashsplinternewworlds.util.starts_with
local ends_with  = modmashsplinternewworlds.util.ends_with
local print  = modmashsplinternewworlds.util.print
local fail_place_entity  = modmashsplinternewworlds.util.fail_place_entity

local queen_hive_min_distance = modmashsplinternewworlds.defines.queen_hive_min_distance
local force_player = modmashsplinternewworlds.util.defines.names.force_player
local force_enemy = modmashsplinternewworlds.util.defines.names.force_enemy
local force_neutral = modmashsplinternewworlds.util.defines.names.force_neutral

if not planets_ui then planets_ui = {} end
if not planets_ui.last_location then planets_ui.last_location = {64,64} end

if not platform_ui then platform_ui = {} end
if not platform_ui.last_location then platform_ui.last_location = nil end

local terraformers_per_tick = 4

local all_terraformers = nil
local all_platforms = nil
local platform_frames = nil
local platform_lag = settings.startup["setting-launch-platform-lag"].value

local planet_select = nil

local local_tick = function()
	local index = global.modmashsplinternewworlds.update_index
	if not index then index = 1 end
	if index >= #all_terraformers then index = 1 end
	local numiter = 0
	local updates = math.min(#all_terraformers,terraformers_per_tick)
	if global.modmashsplinternewworlds.queen_hive_generated == true and global.modmashsplinternewworlds.queen_hive_taged ~= true then
		local surface = "nauvis-deep-underground"
		if not game.active_mods["modmashsplinterunderground"] then
			surface = "nauvis"
		end
		if game.surfaces[surface] ~= nil then
			local queens = game.surfaces[surface].find_entities_filtered{name = "queen-hive"}
			
			if queens ~= nil and #queens>=1 and is_valid(queens[1]) then		
			
				for k=1, #game.players do local player = game.players[k]
					local chunk = {queens[1].position.x/32,queens[1].position.y/32} 
					if player.force.is_chunk_charted(game.surfaces[surface],chunk) == true then
						player.force.add_chart_tag(game.surfaces[surface],{position=queens[1].position,icon={type="virtual", name="queen-hive-signal"},text="Queen Hive"})
						global.modmashsplinternewworlds.queen_hive_taged = true
					else
						player.force.chart(game.surfaces[surface],{{queens[1].position.x-12,queens[1].position.y-12},{queens[1].position.x+12,queens[1].position.y+12}})
					end
				end
			end
		end
	end
	for k=index, #all_terraformers do local terraformer = all_terraformers[k].entity
		
		if is_valid_and_persistant(terraformer) and terraformer.energy > 0 then
			local inv = terraformer.get_inventory(defines.inventory.assembling_machine_modules)
			for name, count in pairs(inv.get_contents()) do
				if name == "clone" then
					local x = 64-math.random(0,64)
					local y = 64-math.random(0,64)
					
					local tile = terraformer.surface.get_tile(x, y)
					if tile.name ~= "grass-1" then
						if tile ~= nil and tile.collides_with("ground-tile") then
							 terraformer.surface.set_tiles({{name="grass-1",position= {x=x,y=y}}})
			
						end
					end
				end
			end
		end
		if k >= #all_terraformers then k = 1 end
		numiter = numiter + 1
		if numiter >= updates then 
			global.modmashsplinternewworlds.update_index	= k
			return
		end
	end
	end

local local_terraformer_added = function(entity)	
	if entity.name == "terraformer" then	
		if entity.surface.get_pollution(entity.position) > 9 then
			--print(entity.surface.get_pollution(entity.position))
			fail_place_entity(entity,event,{"modmashsplinternewworlds.terraformer-placement-fail"})
			return
		end
		local d = {entity = entity}		
		table.insert(all_terraformers, d)
	elseif entity.name == "launch-platform" then
		local id = 1
		for name,value in pairs(all_platforms) do
			if is_valid(value.entity) and value.entity.surface == entity.surface then id = id + 1 end
		end
		while true do
			local name = entity.surface.name.."-"..id
			if not all_platforms[name] then
				break
			end
			id = id + 1
		end
		id = entity.surface.name.."-"..id
		local d = {
			entity = entity,
			name = id,
			destination_progress = 0
		}		
		all_platforms[id] = d
	end
	end

local local_ban_entites = function()
	if remote.interfaces["modmashsplinterunderground"] ~= nil then
		if remote.interfaces["modmashsplinterunderground"]["ban_entity_level_one"] ~= nil then
			remote.call("modmashsplinterunderground","ban_entity_level_one","terraformer")
			remote.call("modmashsplinterunderground","ban_entity_level_one","launch-platform")
		end
		if remote.interfaces["modmashsplinterunderground"]["ban_entity_level_two"] ~= nil then
			remote.call("modmashsplinterunderground","ban_entity_level_two","terraformer")
			remote.call("modmashsplinterunderground","ban_entity_level_two","launch-platform")
		end
	end
	end

local local_init = function()	
	if global.modmashsplinternewworlds  == nil then global.modmashsplinternewworlds = {} end
	if global.modmashsplinternewworlds.queen_hive_generated  == nil then global.modmashsplinternewworlds.queen_hive_generated  = false end
	if global.modmashsplinternewworlds.exploration_chance  == nil then global.modmashsplinternewworlds.exploration_chance = 0.5 end
	if global.modmashsplinternewworlds.all_terraformers == nil then global.modmashsplinternewworlds.all_terraformers = {} end
	if global.modmashsplinternewworlds.planets == nil then global.modmashsplinternewworlds.planets = {} end
	if global.modmashsplinternewworlds.all_platforms == nil then global.modmashsplinternewworlds.all_platforms = {} end
	if global.modmashsplinternewworlds.platform_frames == nil then global.modmashsplinternewworlds.platform_frames = {} end

	all_terraformers = global.modmashsplinternewworlds.all_terraformers
	all_platforms = global.modmashsplinternewworlds.all_platforms
	platform_frames = global.modmashsplinternewworlds.platform_frames
	
	local_ban_entites()
	end


local local_load = function()	
	all_terraformers = global.modmashsplinternewworlds.all_terraformers	
	all_platforms = global.modmashsplinternewworlds.all_platforms
	platform_frames = global.modmashsplinternewworlds.platform_frames
	end

	local local_get_platform_frame_from = function(player_gui)
	for k = #player_gui.children, 1, -1 do
		local ui = player_gui.children[k]
		if ui and ui.name == "platform-main-frame" then
			return ui
		end
	end
	return nil
	end

local local_get_platform_frame = function(player_index)
	local ui = local_get_platform_frame_from(game.players[player_index].gui.left)
	if ui ~= nil then return ui end
	return nil
	end

local local_remove_platform_frame = function(player_index)
	if player_index == nil then
		for i = 1, #game.players do -- just kill all incase of death
			local ui = local_get_platform_frame(i)
			platform_frames[game.players[i].name] = nil
			if ui ~= nil then
				if ui.location ~= nil then platform_ui.last_location = ui.location end
				ui.destroy()
			end
		end
		return
	end
	local player = game.players[player_index]
	local ui = local_get_platform_frame(player_index)
	platform_frames[player.name] = nil
	if ui ~= nil then
		if ui.location ~= nil then platform_ui.last_location = ui.location end
		ui.destroy()
		return true
	end
	return false
	end

local local_terraformer_removed = function(event)
	local entity = event.entity
	if entity.name == "terraformer" then				
		for index, terraformer in pairs(all_terraformers) do
			if  terraformer.entity == entity then
				table.remove(all_terraformers, index)
			end
		end
	end
	if entity.name == "queen-hive" then
		for _, force in pairs(game.forces) do
		  force.technologies["alien-science-pack"].researched = true
		--  force.recipes["alien-science-pack"].enabled = true
		end
	end
	if entity.name == "launch-platform" then
		local_remove_platform_frame(event.player_index)
		for name,value in pairs(all_platforms) do
			if entity == value.entity then
				all_platforms[value.name] = nil
			elseif value.destination == entity then
				value.destination = nil
				value.destination_name = nil
				value.destination_progress = 0
			end
		end
	end
	end

local local_on_entity_cloned = function(event)
	if is_valid(event.source) then
		if event.source.name == "terraformer" then 		
			for index, terraformer in pairs(all_terraformers) do
				if  terraformer.entity == event.source then
					terraformer.entity = event.destination
					return
				end
			end
		elseif event.source.name == "launch-platform" then 
			local source = nil
			for name, platform in pairs(all_platforms) do
				if  platform.entity == event.source then
					source = platform
				end
			end
			if source ~= nil and source.destination ~= nil then
				for index, platform in pairs(all_platforms) do
					if  platform.entity == event.destination then
						platform.destination = source.destination
						platform.destination_name = source.destination_name
						platform.transport_time = source.transport_time
						platform.current_timer = source.transport_time -- yes start at t- ####
						value.destination_progress = 0
					end
				end
			end
		end
	end end

local local_terraformer_research = function(event)
	if starts_with(event.research.name,"exploration-success") then
		global.modmashsplinternewworlds.exploration_chance = ((1-global.modmashsplinternewworlds.exploration_chance)*0.25)+global.modmashsplinternewworlds.exploration_chance
	end	
	if starts_with(event.research.name,"lauch-platform-speed") then		
		if global.modmashsplinternewworlds.launch_speed == nil then global.modmashsplinternewworlds.launch_speed = 0 end
		global.modmashsplinternewworlds.launch_speed = global.modmashsplinternewworlds.launch_speed + 5
	end	
	end

local prefix_charset = {}  do -- [A-Z]
    for c = 97, 122 do table.insert(prefix_charset, string.char(c)) end
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

local local_add_text_button = function(parent, name, caption, style)
	local element = local_create_element(parent,"button", name, nil,tooltip)
	if element == nil then return nil end
	element.style = style or "button"
	element.caption = caption
	return parent.add(element)
	end

local local_add_progress_bar = function(parent, name, caption, style)
	local element = local_create_element(parent,"progressbar", name, nil,tooltip)
	if element == nil then return nil end
	element.style = style or "progressbar"
	return parent.add(element)
	end

local local_remove_planets_button = function(player)
	local button_flow =  mod_gui.get_button_flow(player)
	for k = #button_flow.children, 1, -1 do
		local button = button_flow.children[k]
		if button and button.name == "planets-toggle-button" then
			button.destroy()
			return
		end
	end
	end

local local_add_planets_button = function()
	if settings.global["new-worlds-setting-shortcuts-only"].value == true then return end
	for i = 1, #game.players do local p = game.players[i]
		local_remove_planets_button(p)
		local button_flow =  mod_gui.get_button_flow(p)
		local_add_sprite_button(button_flow, "planets-toggle-button","planets-button-gui",{"gui.planet-explorer-tooltip"},"planets-icon-button")
	end
	end



local spawn_resource = function(surface,name,pos,amount,tiles)
	--need to add condition for fluid
	if name == "sand" then
		if #surface.find_tiles_filtered{collision_mask = "water-tile", position =pos,radius=64, limit = 2} == 0 then return end
	end
	if game.fluid_prototypes[name] ~= nil then 
		
		local a = math.random(1,16)
		for k = 1, a do
			local x = math.random(6,24)
			local y = math.random(6,24)
			if math.random(1,10) > 5 then x = x * -1 end
			if math.random(1,10) > 5 then y = y * -1 end
			if surface.get_tile(pos.x+x,pos.y+y).collides_with("water-tile") == false then
				surface.create_entity{name=name, position={pos.x+x,pos.y+y}, amount=math.random(10000,30000), force = 'neutral'}
			end
		end
		return 
	end
	local w_max = 256
	local h_max = 256
	local abs = math.abs

	local biases = {[0] = {[0] = 1}}
	local t = 1

	local function grow(grid,t)
	  local old = {}
	  local new_count = 0
	  for x,_  in pairs(grid) do for y,__ in pairs(_) do
		table.insert(old,{x,y})
		end end
	  for _,pos in pairs(old) do
		local x,y = pos[1],pos[2]
		local bias = grid[x][y]
		for dx=-1,1,1 do for dy=-1,1,1 do
		  local a,b = x+dx, y+dy
		  if (math.random() > 0.9) and (abs(a) < w_max) and (abs(b) < h_max) then
			grid[a] = grid[a] or {}
			if not grid[a][b] then
			  grid[a][b] = 1 - (t/tiles)
			  new_count = new_count + 1
			  if (new_count+t) == tiles then return new_count end
			  end
			end
		  end end
		end
	  return new_count
	  end

	repeat 
	  t = t + grow(biases,t)
	  until t >= tiles

	local total_bias = 0
	for x,_  in pairs(biases) do 
		for y,bias in pairs(_) do
			total_bias = total_bias + bias
		end 
	 end

	for x,_  in pairs(biases) do 
		for y,bias in pairs(_) do
			if surface.get_tile(pos.x+x,pos.y+y).collides_with("water-tile") == false then
				local a = amount * (bias/total_bias)
				if a>1 then 
					
					surface.create_entity{
					enable_tree_removal = false,
					snap_to_tile_center = true,
					spawn_decorations = true,
					name = name,
					amount = a,
					force = 'neutral',
					position = {pos.x+x,pos.y+y}}
				end
			end		
		end 
	end
end

local request_chart = nil
local local_chunk_generated = function(event)  
	if is_map_editor == true then return end
	if global.modmashsplinternewworlds.queen_hive_generated == true then return end
	local area = event.area
	local surface = event.surface   

	if surface.name == "nauvis-deep-underground" then
		if distance(0,0,area.left_top.x,area.left_top.y) < queen_hive_min_distance then return end
		if remote.interfaces["modmashsplinterunderground"] ~= nil then
			if remote.interfaces["modmashsplinterunderground"]["try_add_entity"] ~= nil then
				local position = {x = area.left_top.x+16,y = area.left_top.y+12}
				global.modmashsplinternewworlds.queen_hive_generated = remote.call("modmashsplinterunderground","try_add_entity","nauvis-deep-underground","queen-hive", position,9,force_enemy)
				if global.modmashsplinternewworlds.queen_hive_generated == true then
					for _, force in pairs(game.forces) do
					
						force.chart(event.surface, {{area.left_top.x-12, area.left_top.y-12}, {area.right_bottom.x+12, area.right_bottom.y+12}})					
						local chunk = {position.x/32,position.y/32} 
						if force.is_chunk_charted(event.surface,chunk) == true then
							force.add_chart_tag(event.surface,{position=position,icon={type="virtual", name="queen-hive-signal"},text="Queen Hive"})
							global.modmashsplinternewworlds.queen_hive_taged = true
						end
					end
				
				end
			end
		end
	elseif surface.name == "nauvis" and not game.active_mods["modmashsplinterunderground"] then
	
		local position = {x = area.left_top.x+math.random(0, 30),y = area.left_top.y+math.random(0, 30)}
		if surface.can_place_entity{name="queen-hive",position=position} then
			local ent = surface.create_entity{
			  name = "queen-hive",
			  position = position,
			  force = force_enemy}
			  global.modmashsplinternewworlds.queen_hive_generated = is_valid(ent)
		end
		
 	if global.modmashsplinternewworlds.queen_hive_generated == true then
			for _, force in pairs(game.forces) do					
				force.chart(event.surface, {{area.left_top.x-12, area.left_top.y-12}, {area.right_bottom.x+12, area.right_bottom.y+12}})					
			end				
		end
	end
	if starts_with(surface.name,"nauvis") or ends_with(surface.name,"underground") then return end
	if global.modmashsplinternewworlds.planets[surface.name] == nil then return end
	if global.modmashsplinternewworlds.planets[surface.name].resources == nil then return end
	if #global.modmashsplinternewworlds.planets[surface.name].resources == 0 then return end
	local pos = {x=event.area.left_top.x+16,y=event.area.left_top.y+16}
	local fm = global.modmashsplinternewworlds.planets[surface.name].dist_min
	local fx = global.modmashsplinternewworlds.planets[surface.name].dist_max
	local e = surface.find_entities_filtered{type = "resource", limit = 2, position=pos, radius = math.random(fm,fx)}
	if #e > 1 then return end
	local max = #global.modmashsplinternewworlds.planets[surface.name].resources
	if max == 0 then return end
	local r = global.modmashsplinternewworlds.planets[surface.name].resources[math.random(1,max)]
	
	local amount = math.random(r.min_amount,r.max_amount)
	local tiles = math.random(r.tiles_min,r.tiles_max)	

	spawn_resource(surface,r.name,pos,amount,tiles)
	end

local local_safe_teleport = function(player, surface, position)
	if player and player.character then
		if position == nil then position = player.character.position end
		local cx, cy = math.floor(position.x / 32), math.floor(position.y / 32)
		if surface.is_chunk_generated({cx, cy}) ~= true then
			surface.request_to_generate_chunks({position.x, position.y}, 3)
			surface.force_generate_chunk_requests()
		end
		
		p = surface.find_non_colliding_position(player.character.name, position, 5, 0.5, false) 
		if p == nil then 
			p = surface.find_non_colliding_position(player.character.name, player.character.position, 5, 0.5, false)
		end
		if p ~= nil then position = p end
		player.teleport(position, surface)
	end
	end




local build_resources = function(settings)

	local res = {}
	res.name_ext = ""
	if math.random(0,50)>25 and game.entity_prototypes["alien-ore"] ~= nil then --and game.autoplace_control_prototypes["alien-ore"] then
		table.insert(res,{name = "alien-ore", min_amount = math.random(10000,5000000), max_amount = math.random(5000001,15000000), tiles_min = math.random(1000,2000), tiles_max = math.random(2001,4000)})
		res.name_ext = res.name_ext.."[entity=alien-ore]"
	end
	if math.random(0,50)>25 and game.entity_prototypes["gold-ore"] ~= nil then --and game.autoplace_control_prototypes["alien-ore"] then
		table.insert(res,{name = "gold-ore", min_amount = math.random(10000,5000000), max_amount = math.random(5000001,15000000), tiles_min = math.random(1000,2000), tiles_max = math.random(2001,4000)})
		res.name_ext = res.name_ext.."[entity=gold-ore]"
	end

	if math.random(0,50)>28 and game.entity_prototypes["creative-mod-pureonium"] ~= nil then --and game.autoplace_control_prototypes["alien-ore"] then
		table.insert(res,{name = "creative-mod-pureonium", min_amount = math.random(10000,5000000), max_amount = math.random(5000001,15000000), tiles_min = math.random(1000,2000), tiles_max = math.random(2001,4000)})
		res.name_ext = res.name_ext.."[entity=creative-mod-pureonium]"
	end

	
	if math.random(0,50)>25 and game.entity_prototypes["titanium-ore"] ~= nil then -- and game.autoplace_control_prototypes["titanium-ore"] then
		table.insert(res,{name = "titanium-ore", min_amount = math.random(10000,5000000), max_amount = math.random(5000001,15000000), tiles_min = math.random(1000,2000), tiles_max = math.random(2001,4000)})
		res.name_ext = res.name_ext.."[entity=titanium-ore]"
	end

	if math.random(0,50)>15 and game.entity_prototypes["sand"] ~= nil then -- and game.autoplace_control_prototypes["sand"] then
		table.insert(res,{name = "sand", min_amount = math.random(10000,5000000), max_amount = math.random(5000001,15000000), tiles_min = math.random(1000,2000), tiles_max = math.random(2001,4000)})
		res.name_ext = res.name_ext.."[entity=sand]"
	end

	if math.random(0,50)>40 and game.entity_prototypes["sulfur"] ~= nil then --and game.autoplace_control_prototypes["sulfur"] then
		table.insert(res,{name = "sulfur", min_amount = math.random(10000,5000000), max_amount = math.random(5000001,15000000), tiles_min = math.random(1000,2000), tiles_max = math.random(2001,4000)})
		res.name_ext = res.name_ext.."[entity=sulfur]"
	end

	local freq = {"none","very-low","low","normal","high","very-high"}

	if settings ~=nil and settings.autoplace_controls ~=nil then
	
		for name, value in pairs(settings.autoplace_controls) do
		--log(name)
			local rhigh = 35
			if name=="uranium-ore" then rhigh = 45 end
			if game.fluid_prototypes[name] == nil and math.random(0,50)>rhigh then
				
				res.name_ext = res.name_ext.."[entity="..name.."]"
				table.insert(res,{name = name, min_amount = 800000, max_amount = 5000000, tiles_min = 2000, tiles_max = 4000})
			elseif game.fluid_prototypes[name] ~= nil and math.random(0,50)>25 then
				res.name_ext = res.name_ext.."[entity="..name.."]"	
				table.insert(res,{name = name, min_amount = math.random(10000,5000000), max_amount = math.random(5000001,15000000), tiles_min = math.random(1000,2000), tiles_max = math.random(2001,4000)})
				--settings.autoplace_controls[name] = {  richness = 1, size = 1, frequency=1}
			elseif math.random(0,50)>40 then
				table.insert(res,{name = name, min_amount = math.random(10000,5000000), max_amount = math.random(5000001,15000000), tiles_min = math.random(1000,2000), tiles_max = math.random(2001,4000)})
				res.name_ext = res.name_ext.."[entity="..name.."]"

			end
		end
	end
	return res
end

local create_map_settings = function()
	local freq = {"none","very-low","low","normal","high","very-high"}
	local parent = game.surfaces[1]
	local cliff_settings_richness = 1
	if math.random(0,6)>3 then cliff_settings_richness = 0 end
	local map=
	{
		seed = math.random(0,4294967294),
		width = parent.map_gen_settings.width, 
		height = parent.map_gen_settings.height,
		terrain_segmentation = parent.map_gen_settings.terrain_segmentation,
		--default_enable_all_autoplace_controls = true,	
		default_enable_all_autoplace_controls = false,	
		water = freq[math.random(1,#freq)],
		property_expression_names = {
			cliffiness = cliff_settings_richness,
			["moisture"] = math.random(0,100)/100,
			["aux"] = math.random(0,100)/100,
			["temperature "] = math.random(-20,50),
			["control-setting:moisture:bias"] = math.random(0,100)/100,
			["control-setting:aux:bias "] = math.random(0,100)/100
		}
	}	

	map.autoplace_controls = {}
	for name, value in pairs(game.autoplace_control_prototypes) do
		if value.category == "resource" then
			map.autoplace_controls[name] = { richness = 0, size = 0, frequency=0}
		end
	end
	return map
	end

local local_get_planets_frame_from = function(player_gui)
	for k = #player_gui.children, 1, -1 do
		local ui = player_gui.children[k]
		if ui and ui.name == "planets-main-frame" then
			return ui
		end
	end
	return nil
	end

local local_get_planets_frame = function(player_index)
	local ui = local_get_planets_frame_from(game.players[player_index].gui.screen)
	if ui ~= nil then return ui end
	return  local_get_planets_frame_from(game.players[player_index].gui.center)
end


local local_teleport_to = function(player,name,position)
	--print("teleporting "..player.index.. " to " .. name)
	if global.modmashsplinternewworlds.planets[player.surface.name] == nil then return end
	if global.modmashsplinternewworlds.planets[player.surface.name].players == nil then global.modmashsplinternewworlds.planets[player.surface.name].players = {} end
	if global.modmashsplinternewworlds.planets[player.surface.name].players[player.index] == nil then global.modmashsplinternewworlds.planets[player.surface.name].players[player.index] = {} end
	if global.modmashsplinternewworlds.planets[player.surface.name].players[player.index].last_location == nil then global.modmashsplinternewworlds.planets[player.surface.name].players[player.index].last_location = player.character.position end		
	if global.modmashsplinternewworlds.planets[name] ~= nil then
		if game.surfaces[name] == nil then	
			if global.modmashsplinternewworlds.planets[name] == nil then global.modmashsplinternewworlds.planets[name] = {} end
			if global.modmashsplinternewworlds.planets[name].settings == nil then global.modmashsplinternewworlds.planets[name].settings = create_map_settings() end
			if global.modmashsplinternewworlds.planets[name].resources == nil then global.modmashsplinternewworlds.planets[name].resources = build_resources(global.modmashsplinternewworlds.planets[name].settings) end
			global.modmashsplinternewworlds.planets[name].dist_min = math.random(64,128)
			global.modmashsplinternewworlds.planets[name].dist_max = math.random(global.modmashsplinternewworlds.planets[name].dist_min+1,global.modmashsplinternewworlds.planets[name].dist_min+512) 

			local new_surface = game.create_surface(name, global.modmashsplinternewworlds.planets[name].settings)
			new_surface.ticks_per_day = math.random(17500,50000) 
			new_surface.daytime = math.random(1,100)/100
			if math.random(1,100)>80 then
				new_surface.freeze_daytime = true
			end
			--log(serpent.block(player.surface.map_gen_settings))
			if remote.interfaces["modmashsplinterunderground"]["register_surface"] ~= nil then
			remote.call("modmashsplinterunderground","register_surface",name)
			end
		end
	end
	if global.modmashsplinternewworlds.planets[name] == nil then global.modmashsplinternewworlds.planets[name] = {} end

	if global.modmashsplinternewworlds.planets[name].players == nil then global.modmashsplinternewworlds.planets[name].players = {} end
	if global.modmashsplinternewworlds.planets[name].players[player.index] == nil then global.modmashsplinternewworlds.planets[name].players[player.index] = {} end
	if global.modmashsplinternewworlds.planets[name].players[player.index].last_location == nil then global.modmashsplinternewworlds.planets[name].players[player.index].last_location = {x=0,y=0} end		

	if position == nil then position = global.modmashsplinternewworlds.planets[name].players[player.index].last_location end
	local_safe_teleport(
		player,
		game.surfaces[name],
		position)
	end



local local_set_platform_camera = function(camera,entity)
	if is_valid(camera) then
		camera.position = entity.position
		camera.surface_index = entity.surface.index
	end
	end

-- later the find the further out
local local_get_transport_time = function(platform)	
	if platform.entity == nil or platform.destination == nil then return nil end
	if global.modmashsplinternewworlds.launch_speed == nil then global.modmashsplinternewworlds.launch_speed = 0 end
	
	return (((math.abs(platform.entity.surface.index-platform.destination.surface.index)+1)*20)*(60-global.modmashsplinternewworlds.launch_speed))/platform_lag
end

local local_set_platform_destination = function(platform_frame,name)

	if platform_frame==nil then return end
	if platform_frame.view ~= nil and name == nil then
		local_set_platform_camera(platform_frame.view, platform_frame.platform.entity)
		--print(platform_frame.ui)
		platform_frame.ui.caption = {"gui.platform-destination",""}
	end
	if name == nil then 
		platform_frame.platform.destination = nil
		platform_frame.platform.destination_name = nil
		platform_frame.platform.destination_progress = 0
		platform_frame.ui.caption = {"gui.platform-destination",""}
		return 
	end
	local destination = all_platforms[name]
	if destination == nil then 
		platform_frame.platform.destination = nil
		platform_frame.platform.destination_name = nil
		platform_frame.platform.destination_progress = 0
		return 
	end
	local_set_platform_camera(platform_frame.view, destination.entity)
	platform_frame.platform.destination = destination.entity
	platform_frame.platform.destination_name = name
	platform_frame.platform.destination_progress = 0
	platform_frame.platform.transport_time = local_get_transport_time(platform_frame.platform)
	platform_frame.platform.current_timer = platform_frame.platform.transport_time
	platform_frame.ui.caption = {"gui.platform-destination",name}

end

local local_create_platform_frame = function(event)	
	local player = game.players[event.player_index]
	local player_gui_left = player.gui.left	
	local platform_list = {"Disabled"}
	local selected_index = 1
	
	local platform = nil
	local all_platform_list = {}
	local selected_platform_index = 1
	local current_select = 1
	
	local sort_table = {}
	for _,v in pairs(all_platforms) do		
		table.insert(sort_table, v)
	end
	table.sort(sort_table, function(v1,v2) return v1.name < v2.name end)

	for n,v in pairs(sort_table) do		
		local is_selected
		if is_valid(v.entity) then
			if event.entity == v.entity then 
				platform = v
				is_selected = true
			end
			if event.entity.surface.name ~= v.entity.surface.name then
				table.insert(platform_list,v.name)
			end
			table.insert(all_platform_list,v.name)
			if is_selected then selected_platform_index = current_select end
			current_select = current_select+1
		end		
	end	
	if platform == nil then 
		player.print("local_create_platform_frame:platform=nil ==> ")
		return 
	end
	local view_pos = event.entity.position
	local views_surface = event.entity.surface.index

	if platform.destination ~= nil and is_valid(platform.destination) then
		view_pos = platform.destination.position
		views_surface = platform.destination.surface.index
		for k=1, #platform_list do
			if platform_list[k] == platform.destination_name then selected_index = k end
		end	
	end
	local destination_name = platform.destination_name
	if destination_name == nil then destination_name = "" end
	local destination_progress = platform.destination_progress
	if platform.destination_progress == nil then destination_progress = 0.0 end

	platform_frames[player.name] = 
		{
			ui = local_add_frame(player_gui_left, "platform-main-frame", {"gui.platform-destination",destination_name},"vertical", "platform-window"),
			platform = platform
		}
	local platform_frame = platform_frames[player.name].ui	

	local left_flow = local_add_flow(platform_frame,"platform-left-flow","vertical","platform-left-window-flow")

	 --local_add_dropdown = function(parent, name, items, selected_index)
	local drop = local_add_dropdown(left_flow,"platform-dropdown",all_platform_list,selected_platform_index)	

	local progress = local_add_progress_bar(left_flow,name,"platform-progress","platform-progress")	 

	local view = left_flow.add{type = "camera", name = "view", position = view_pos, surface_index = views_surface, zoom = 0.1}
			view.style.minimal_width = 218
			view.style.maximal_width = 218
			view.style.minimal_height = 218
			view.style.maximal_width = 218
			view.style.natural_height = 218
			view.style.natural_width = 218

	platform_frames[player.name].view = view

	platform_frames[player.name].progress = progress
	platform_frames[player.name].platform_select = local_add_list(left_flow, "platform-topics-list", platform_list,selected_index)
	platform_frames[player.name].platform_list = platform_list
	platform_frames[player.name].selected_index = selected_index
	if selected_index then
		platform_frames[player.name].platform_select.scroll_to_item(selected_index, "top-third")
	end
	end



local local_on_gui_selection_state_changed = function(event)
	local player = game.players[event.player_index]
	
	if player == nil then return end
	local platform_frame = platform_frames[player.name] 
	if event.element.name == "planets-topics-list" and global.modmashsplinternewworlds.planet_view ~= nil then
		local select_name = event.element.items[event.element.selected_index]
		if global.modmashsplinternewworlds.planets[select_name] ~= nil then
			--[[if game.surfaces[select_name] == nil then
				local new_surface = game.create_surface(select_name, create_map_settings(global.modmashsplinternewworlds.planets[select_name]))
				if remote.interfaces["modmashsplinterunderground"]["register_surface"] ~= nil then
					remote.call("modmashsplinterunderground","register_surface",select_name)
				end
			end]]
			local cs = player.surface.name
			local cp = player.character.position
			local_teleport_to(player, select_name)	
			if game.surfaces[select_name].is_chunk_generated({x=0,y=0}) ~= true then
				game.surfaces[select_name].request_to_generate_chunks({x=0,y=0}, 15)
				game.surfaces[select_name].force_generate_chunk_requests()
				for _, force in pairs(game.forces) do					
					force.chart(game.surfaces[select_name], {{-64, -64}, {64, 64}})					
				end		
			end
			--request_chart = false
			local_teleport_to(player, cs,cp)	
		end

		if game.surfaces[select_name] ~= nil then
			local planet = global.modmashsplinternewworlds.planets[select_name]
			local pos = game.players[event.player_index].character.position
			if planet.players[player.index] ~= nil and planet.players[player.index].last_location ~= nil then
				pos =  {x=0,y=0}
			end

			--[[if game.surfaces[select_name].is_chunk_generated(pos) ~= true then
				request_chart = true
				game.surfaces[select_name].request_to_generate_chunks(pos, 1)
				game.surfaces[select_name].force_generate_chunk_requests()
				request_chart = nil
					
			end]]
			if planet ~= nil then
				global.modmashsplinternewworlds.planet_view.position = pos
				global.modmashsplinternewworlds.planet_view.surface_index = game.surfaces[select_name].index
				global.modmashsplinternewworlds.planet_view.zoom = 0.5
			end
		end

	elseif event.element.name == "platform-topics-list" and platform_frame ~= nil and platform_frame.ui ~= nil and platform_frame.platform ~= nil then
		platform_frame.selected_index = event.element.selected_index
		if platform_frame.platform_list[platform_frame.selected_index] == "Disabled" then
			local_set_platform_destination(platform_frame,nil)
		else
			local_set_platform_destination(platform_frame,platform_frame.platform_list[platform_frame.selected_index])
		end
	elseif event.element.name == "platform-dropdown" then	
		local select_name = event.element.items[event.element.selected_index]
		local_remove_platform_frame(event.player_index)
		
		local platform_select = nil
		for n,v in pairs(all_platforms) do		
			if is_valid(v.entity) and n == select_name then
				platform_select = v.entity
			end
		end
		if platform_select ~= nil then
			local_create_platform_frame(
			{
				player_index = event.player_index,
				entity = platform_select
			})	
		else
			player.print("local_on_gui_selection_state_changed:platform not found ==> ")
		end
	end	
end

local local_platform_tick = function()
	if game.tick%platform_lag==0 then
		for name,value in pairs(all_platforms) do
			if is_valid(value.destination) and value.transport_time ~= nil then
				value.current_timer = value.current_timer - 1
				if value.current_timer <= 0 then
					value.transport_time = local_get_transport_time(value)
					value.current_timer = value.transport_time
					local from = value.entity.get_inventory(defines.inventory.chest)
					local to = value.destination.get_inventory(defines.inventory.chest)
					if from ~= nil and to ~= nil then
						for n, c  in pairs (from.get_contents()) do
							if n~=nil then				
								local ic = math.min(to.get_insertable_count(n),c)							
								if (ic>0) and to.can_insert({name=n,count=ic}) then
									to.insert({name=n,count=ic})
									from.remove({name=n,count=ic})
								end
							end
						end	
					end

				end
				if value.transport_time ~= nil then
					value.progress = 1.0- (value.current_timer/value.transport_time)
				end
			end
		end
		for player, frame in pairs(platform_frames) do
			if frame.platform.destination ~= nil then
				frame.progress.value = frame.platform.progress
			end
		end
	end	
end



local local_remove_planets_frame = function(player_index)
	global.modmashsplinternewworlds.planet_view = nil
	local ui = local_get_planets_frame(player_index)
	if ui ~= nil then
		if ui.location ~= nil then planets_ui.last_location = ui.location end
		ui.destroy()
		return true
	end
	return false
	end



local local_create_planets_frame = function(event)	
	local player_gui_center = game.players[event.player_index].gui.screen	
	
	local planets_frame = local_add_frame(player_gui_center, "planets-main-frame", {"gui.planet-explorer"},"vertical", "planets-window")
	
	local planets_main_flow = local_add_flow(planets_frame, "planets-main-flow","horizontal","planets-window-flow")
	
	local button_flow = local_add_flow(planets_frame, "planets-button-flow","horizontal","planets-bottom-button-flow")
	local current_planet_flow = local_add_flow(planets_frame, "current-planets-flow","horizontal","current-planets-top-flow")
	local_add_text_button(button_flow,"planets-close", {"gui.planet-close"}, "button")

	if global.modmashsplinternewworlds.planets[game.players[event.player_index].surface.name] ~= nil or game.players[event.player_index].surface.name == "nauvis" then
		local_add_text_button(button_flow,"planets-teleport", {"gui.planet-teleport"}, "button")
	end

	--local element = { type = "empty-widget", style = "planets-bottom-filler"} 
	--button_flow.add(element)

	local left_flow = local_add_flow(planets_main_flow,"planets-left-flow","vertical","planets-left-window-flow")

	global.modmashsplinternewworlds.planet_view = left_flow.add{type = "minimap", name = "planet-view", position = game.players[event.player_index].character.position, surface_index = game.players[event.player_index].character.surface.index, zoom = 0.5}
			global.modmashsplinternewworlds.planet_view.style.minimal_width = 218
			global.modmashsplinternewworlds.planet_view.style.maximal_width = 218
			global.modmashsplinternewworlds.planet_view.style.minimal_height = 218
			global.modmashsplinternewworlds.planet_view.style.maximal_width = 218
			global.modmashsplinternewworlds.planet_view.style.natural_height = 218
			global.modmashsplinternewworlds.planet_view.style.natural_width = 218

	--local mods_left_flow = local_add_flow(left_flow, "planets-left-flow","horizontal","horizontal_flow")	


	local planet_list = {}
	if global.modmashsplinternewworlds.planets["nauvis"] == nil and game.surfaces["nauvis"] ~= nil then
		global.modmashsplinternewworlds.planets["nauvis"] = {}
	end

	for n,v in pairs(global.modmashsplinternewworlds.planets) do
		if game.players[event.player_index].surface.name ~= n then
			table.insert(planet_list,n)
		else
			current_planet_flow.add{type="label", caption=n}
		end
	end	

	planet_select = local_add_list(left_flow, "planets-topics-list", planet_list)
	if #planet_list > 0 then 
		local_on_gui_selection_state_changed(
		{
			player_index = event.player_index,
			element = planet_select
		})
	end
	
	game.players[event.player_index].opened = planets_frame
	if planets_frame.location ~= nil then planets_frame.location = planets_ui.last_location end
	end

local local_on_rocket_launched = function(event)
	local rocket = event.rocket
	local rocket_silo = event.rocket_silo
	local player_index = event.player_index

	local inventory = rocket.get_inventory(defines.inventory.rocket)
	for name, count in pairs(inventory.get_contents()) do
		if name == "explorer" then
			if (math.random(1,100)/100) < global.modmashsplinternewworlds.exploration_chance then
				local name = prefix_charset[math.random(1,#prefix_charset)]..prefix_charset[math.random(1,#prefix_charset)].."-"..math.random(0,9)..math.random(0,9)..math.random(0,9)
				local settings = create_map_settings()
				local resources = build_resources(settings)
				local oname = name
				if resources.name_ext ~= nil then name = name..resources.name_ext end

				
				if global.modmashsplinternewworlds.planets == nil then global.modmashsplinternewworlds.planets = {} end
				if global.modmashsplinternewworlds.planets[name] == nil then
					global.modmashsplinternewworlds.planets[name] = {planet_id = name, setting = settings, resources = resources}
					print("Unlocked planet "..name)
					for k=1 , #game.players do
						local player = game.players[k]
						if is_valid(player) == true then
							player.set_shortcut_available("planet-explorer",true)
						end
					end	
					local_add_planets_button()					
				end	
			else
				print("Explorer perished")
			end
		end
	end	
	for k=1 , #game.players do
		if local_get_planets_frame(k) ~= nil then
			local_remove_planets_frame(k)
			local_create_planets_frame({player_index = k} )
		end
	end
	end

local local_on_gui_click = function(event)
	if event.element.name == "planets-toggle-button" then
		if local_remove_planets_frame(event.player_index) == false then
			local_create_planets_frame(event)	
		end
	elseif event.element.name == "planets-close" then
		local_remove_planets_frame(event.player_index)
	elseif event.element.name == "platform-close" then
		local_remove_platform_frame(event.player_index)
	elseif event.element.name == "planets-teleport" and planet_select ~= nil then		
		local_teleport_to(game.players[event.player_index], planet_select.items[planet_select.selected_index])
		local_remove_planets_frame(event.player_index)
	end
	end	



local local_on_gui_closed = function(event)
	if event.entity ~= nil and event.entity.name == "launch-platform" and event.gui_type == 1 then
		
		local player = game.players[event.player_index]
		if player ~= nil then
			local_remove_platform_frame(event.player_index)
		end
	end
end

local local_on_gui_opened = function(event)
	if event.entity ~= nil and event.entity.name == "launch-platform" and event.gui_type == 1 then
		local player = game.players[event.player_index]
		if player ~= nil then
			if local_remove_platform_frame(event.player_index) == false then
			local_create_platform_frame(event)	
		end
		end
	end
end


local local_update_gui = function()
	local z = 0
	if global.modmashsplinternewworlds.planets ~= nil then z = table_length(global.modmashsplinternewworlds.planets) end
	
	for k=1 , #game.players do
		local player = game.players[k]
		if is_valid(player) == true then
			--print(z)
			if z > 0 then
				player.set_shortcut_available("planet-explorer",true)
			else
				player.set_shortcut_available("planet-explorer",false)
			end
		end
	end	

	if settings.global["new-worlds-setting-shortcuts-only"].value == true then
		for k=1 , #game.players do
			if is_valid(game.players[k]) == true then
				local_remove_planets_button(game.players[k])
			end
		end
	else
		if global.modmashsplinternewworlds.planets ~= nil and #global.modmashsplinternewworlds.planets > 1 then
			local_add_planets_button()	
		end
	end
end

local local_on_runtime_mod_setting_changed = function(event)
	local_update_gui()
	end

local local_on_configuration_changed = function() 	
	if global.modmashsplinternewworlds  == nil then global.modmashsplinternewworlds = {} end
	if global.modmashsplinternewworlds.queen_hive_generated  == nil then global.modmashsplinternewworlds.queen_hive_generated  = false end
	if global.modmashsplinternewworlds.exploration_chance  == nil then global.modmashsplinternewworlds.exploration_chance = 0.5 end
	if global.modmashsplinternewworlds.all_terraformers == nil then global.modmashsplinternewworlds.all_terraformers = {} end
	if global.modmashsplinternewworlds.all_platforms == nil then global.modmashsplinternewworlds.all_platforms = {} end

	if global.modmashsplinternewworlds.planets == nil then global.modmashsplinternewworlds.planets = {} end
	if global.modmashsplinternewworlds.platform_frames == nil then global.modmashsplinternewworlds.platform_frames = {} end

	all_terraformers = global.modmashsplinternewworlds.all_terraformers
	all_platforms = global.modmashsplinternewworlds.all_platforms
	platform_frames = global.modmashsplinternewworlds.platform_frames
	local_ban_entites()
	local_update_gui()
	end

local local_planet_on_shortcut_gui_click = function(event)
	local z = 0
	if global.modmashsplinternewworlds.planets ~= nil then z = table_length(global.modmashsplinternewworlds.planets) end
	if z > 0 then
		local player = game.players[event.player_index]
		if event.prototype_name == "planet-explorer" and player.is_shortcut_available("planet-explorer") then
			if local_remove_planets_frame(event.player_index) == false then
				local_create_planets_frame(event)	
			end
		end
	else
		local_update_gui()
	end
end

script.on_init(local_init)
script.on_load(local_load)


script.on_nth_tick(44, local_tick)
script.on_event(defines.events.on_tick, local_platform_tick)
script.on_configuration_changed(local_on_configuration_changed)
script.on_event(defines.events.on_runtime_mod_setting_changed,local_on_runtime_mod_setting_changed)


script.on_event(defines.events.on_entity_died,
	function(event) 
		if is_valid(event.entity) then local_terraformer_removed(event) end 
	end)
script.on_event(defines.events.on_robot_mined_entity,
	function(event) 
		if is_valid(event.entity) then local_terraformer_removed(event) end 
	end)
script.on_event(defines.events.on_player_mined_entity,
	function(event) 
		if is_valid(event.entity) then local_terraformer_removed(event) end 
	end)
script.on_event(defines.events.script_raised_revive,
	function(event) 
		if is_valid(event.entity) then local_terraformer_added(event.entity) end 
	end)
script.on_event(defines.events.on_robot_built_entity,
	function(event) 
		if is_valid(event.created_entity) then local_terraformer_added(event.created_entity) end 
	end,local_land_mine_filter)
script.on_event(defines.events.on_built_entity,
	function(event) 
		if is_valid(event.created_entity) then local_terraformer_added(event.created_entity) end 
	end)
script.on_event(defines.events.script_raised_built,
	function(event) 
		if is_valid(event.created_entity) then local_terraformer_added(event.entity) end 
	end)


script.on_event(defines.events.on_trigger_created_entity, local_terraformer_added)

script.on_event(defines.events.on_entity_cloned,
	function(event) 
		if is_valid(event.source) then local_on_entity_cloned(event) end 
	end)

script.on_event(defines.events.on_research_finished, local_terraformer_research)

script.on_event(defines.events.on_rocket_launched, local_on_rocket_launched)

script.on_event(defines.events.on_chunk_generated,local_chunk_generated)

script.on_event(defines.events.on_lua_shortcut, local_planet_on_shortcut_gui_click)

script.on_event(defines.events.on_gui_click, local_on_gui_click)

script.on_event(defines.events.on_gui_opened, local_on_gui_opened)

script.on_event(defines.events.on_gui_closed, local_on_gui_closed)
script.on_event(defines.events.on_gui_selection_state_changed, local_on_gui_selection_state_changed)
