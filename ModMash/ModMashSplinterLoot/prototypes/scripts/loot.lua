require("prototypes.scripts.defines") 
local loot_probability = modmashsplinterloot.defines.loot_probability
local loot_tech_probability = modmashsplinterloot.defines.loot_tech_probability
local loot_exclude_distance_from_origin = modmashsplinterloot.defines.loot_exclude_distance_from_origin
local crash_site_chest_inventory = modmashsplinterloot.defines.crash_site_chest_inventory
local crash_site_chest_health = modmashsplinterloot.defines.crash_site_chest_health

local force_neutral = modmashsplinterunderground.util.defines.names.force_neutral

local loot_science_prefix = modmashsplinterloot.defines.names.loot_science_prefix
local loot_science_a = modmashsplinterloot.defines.names.loot_science_a
local loot_science_b = modmashsplinterloot.defines.names.loot_science_b
local crash_site_prefix = modmashsplinterloot.defines.names.crash_site_prefix

local table_index_of = modmashsplinterloot.util.table.index_of
local table_contains = modmashsplinterloot.util.table.contains
local distance  = modmashsplinterloot.util.distance
local starts_with  = modmashsplinterloot.util.starts_with
local print = modmashsplinterloot.util.print
local get_name_for = modmash.util.get_name_for
local is_valid  = modmashsplinterloot.util.is_valid

local chunks = nil
local loot_table = nil
local science_table = nil
local science_prabability_table = nil

local local_build_probability_table = function(res)
	local tbl = {}
	for k=1, #res do
		local c = math.ceil(res[k].probability*10)
		local name = res[k].name
		for j=1, c do
			table.insert(tbl,name)
		end
	end
	return tbl
end

local local_get_item = function(name)
  if name == nil then return nil end
  local items = game.item_prototypes 
  if items then
    return items[name]
  end
  return nil 
  end

local local_register_science_pack = function(science)
	if settings.startup["setting-tech-loot"].value ~= "Science" then return end
	if type(science) ~= "table" then log("Expected table in register_science_pack") return end
	if science.name == nil or type(science.name) ~= "string" then log("Missing name in register_science_pack") return end
	local name = science.name
	local max_stacks = science.max_stacks
	local max_stack = science.max_stack
	local item = local_get_item(name)
	local probability = science.probability
	if item == nil then log("Missing item for"..name.." in register_science_pack")  return end
	if item.type ~= "tool" then log("Science pack "..name.." is not of type tool") return end
	if item.stack_size == 1 then log("Science pack " .. " stack_size is 1") return end
	if max_stacks == nil then max_stacks = crash_site_chest_inventory end
	if max_stack == nil then max_stack = item.stack_size end
	if probability == nil then  probability = 0.2 end
	probability = math.max(0.1,probability)
	probability = math.min(probability,0.1)
	for k =1 #global.modmashsplinterloot.loot.science_table do
		if global.modmashsplinterloot.loot.science_table[k].name == name then
			global.modmashsplinterloot.loot.science_table[k].max_stacks = max_stacks
			global.modmashsplinterloot.loot.science_table[k].max_stack = max_stack
			global.modmashsplinterloot.loot.science_table[k].probability = probability
			global.modmashsplinterloot.loot.science_prabability_table = local_build_probability_table(global.modmashsplinterloot.loot.science_table)
			return
		end
	end
	table.insert(global.modmashsplinterloot.loot.science_table,{name = name, max_stack = max_stack, max_stacks = max_stacks, probability = probability})	
	global.modmashsplinterloot.loot.science_prabability_table = local_build_probability_table(global.modmashsplinterloot.loot.science_table)
end

local local_create_science_table = function()
	local global.modmashsplinterloot.loot.science_table = {}
	local vanilla_packs = {
		{name = "automation-science-pack",probability = 0.5},
		{name = "logistic-science-pack",probability = 0.5},		
		{name = "military-science-pack",probability = 0.4},
		{name = "chemical-science-pack",probability = 0.3},		
		{name = "production-science-pack",probability = 0.2},
		{name = "utility-science-pack",probability = 0.2},
		{name = "space-science-pack",probability = 0.1}}
	for k=1, #vanilla_packs
		local_register_science_pack(vanilla_packs[k])
	end
end

local local_register_loot = function(loot)

end

local local_create_look_table = function()
	local global.modmashsplinterloot.loot.science_table = {}
	local vanilla = {
		{name = "logistic_transport", probability = 0.5, items = {
				{name = "transport-belt",max_stacks = 15},
				{name = "underground-belt",max_stacks = 10, probability = 0.5},
				{name = "splitter",max_stacks = 6, probability = 0.5},
		},
		{name = "logistic_transport-fast", probability = 0.4, items = {
				{name = "fast-transport-belt",max_stacks = 15},
				{name = "fast-underground-belt",max_stacks = 10, probability = 0.5},
				{name = "fast-splitter",max_stacks = 6, probability = 0.5},
		},
		{name = "logistic_transport-express", probability = 0.3, items = {
				{name = "express-transport-belt",max_stacks = 15},
				{name = "express-underground-belt",max_stacks = 10, probability = 0.5},
				{name = "express-splitter",max_stacks = 6, probability = 0.5},
		},
		{name = "logistic_transport-train", probability = 0.1, items = {
				{name = "train-stop",max_stacks = 2},
				{name = "locomotive",max_stacks = 2},
				{name = "fluid-wagon",max_stacks = 2},
				{name = "cargo-wagon",max_stacks = 3},
				{name = "rail-chain-signal",max_stacks = 8},
				{name = "rail-signal",max_stacks = 8}
		},
		{name = "logistic_transport-inserters", probability = 0.3, items = {
				{name = "inserter",max_stacks = 10},
				{name = "long-handed-inserter",max_stacks = 10},
				{name = "fast-inserter",max_stacks = 2},
				{name = "filter-inserter",max_stacks = 3, probability = 0.2},
		},
		{name = "logistic_transport-inserters-advanced", probability = 0.2, items = {
				{name = "stack-inserter",max_stacks = 3},
				{name = "stack-filter-inserter",max_stacks = 3, probability = 0.5}
		}
		}
	for k=1, #vanilla
		local_register_loot(vanilla[k])
	end
end

local local_set_probability = function()
	local percent = settings.startup["modmash-setting-loot-chance"].value/100
	loot_probability = (modmashsplinterloot.defines.defaults.loot_probability)-((modmashsplinterloot.defines.defaults.loot_probability-3)*percent)
	loot_tech_probability = (modmashsplinterloot.defines.defaults.loot_tech_probability)-((modmashsplinterloot.defines.defaults.loot_tech_probability-3)*percent)	
	end

local local_init = function()	
	if global.modmashsplinterloot.loot == nil then global.modmashsplinterloot.loot = {} end
	if global.modmashsplinterloot.loot.table == nil then global.modmashsplinterloot.loot.table = local_create_loot_table() end
	if global.modmashsplinterloot.loot.science_table == nil or global.modmashsplinterloot.loot.science_prabability_table == nil then local_create_science_table() end
	if global.modmashsplinterloot.loot.chunks == nil then global.modmashsplinterloot.loot.chunks = {} end
	chunks = global.modmashsplinterloot.loot.chunks
	loot_table = global.modmashsplinterloot.loot.table
	science_table = global.modmashsplinterloot.loot.science_table
	local_set_probability()
	end

local local_load = function()	
	chunks = global.modmashsplinterloot.loot.chunks
	loot_table = global.modmashsplinterloot.loot.table
	science_table = global.modmashsplinterloot.loot.science_table
	local_set_probability()
	end



local local_get_stack_restriction = function(item)
	if item.type == "item-with-entity-data" then return 2 end
	if item.type == "gun" then return 1 end
	if item.type == "armor" then return 1 end
	return item.stack_size
end

local loot_groups = {
	{"intermediate-product"},
	{"armor","gun","equipment","ammo"},
	{"armor","gun","equipment","ammo"},
	{"defensive-structure"},
	{"energy","energy-pipe-distribution","circuit-network"},
	{"energy","energy-pipe-distribution","circuit-network"},
	{"transport","circuit-network"},
	{"tool","extraction-machine","energy-pipe-distribution"},
	{"tool","extraction-machine","energy-pipe-distribution"},
	{"tool","extraction-machine","energy-pipe-distribution"},
	{"smelting-machine","module","production-machine","circuit-network","tool","storage"},
	{"smelting-machine","module","production-machine","circuit-network","tool","storage"},
	{"smelting-machine","module","production-machine","circuit-network","tool","storage"},
	{"inserter","belt","storage"},
	{"inserter","belt","storage"},
	{"inserter","belt","storage"},
	{"logistic-network","tool"},
	{"logistic-network","tool"},
	{"raw-material"},
	{"raw-material"},
	{"raw-resource"},
	{"raw-resource"},
	{"terrain"},
	{"terrain"},
	{"science-pack"}}
	
local loot_fill_item_groups = {"raw-material","raw-resource"} --,"terrain","science-pack"}

local local_is_loot_fill_item = function(group) return table_contains(loot_fill_item_groups, group) end

local local_get_random_stack_group = function(group) 
	local item = nil
	local valid = false
	local x = 0
	repeat 
		item = loot_table[math.random(1, #loot_table)]
		valid = (is_valid(item) and table_contains(group, item.subgroup.name))
		x = x + 1
	until(valid or x > 10)
	if valid ~= true then
		item = nil		
	end
	return item
	end

local local_get_random_stack_any = function() 
	local item = nil
	local valid = false
	local x = 0
	repeat 
		item = loot_table[math.random(1, #loot_table)]
		valid = is_valid(item)
		x = x + 1
	until(valid or x > 10)
	if valid ~= true then
		item = nil		
	end
	return item
	end

local local_get_random_stack = function(group) 
	if group == nil then return local_get_random_stack_any() end
	return local_get_random_stack_group(group)
	end

local local_add_tech_loot = function(surface_index, area)
	if settings.startup["modmash-setting-tech-loot"].value == "Disabled" then return end	
	global.modmash.loot.loot_tech_modifier = global.modmash.loot.loot_tech_modifier + 0.2
	local surface = game.surfaces[surface_index]
	local position = {x=area.left_top.x+math.random(0, 30),y=area.left_top.y+math.random(0, 30)}
	local name = loot_science_a
	if surface.can_place_entity{name=name,position=position} then
		local ent = surface.create_entity{
			  name = name,
			  position = position,
			  force = force_neutral}
	end
	end

local local_get_recipe = function(name)
	return game.players[1].force.recipes[name]
	end

local local_get_recipe_results = function(r)
	local results = nil
	if r.normal ~= nil then 		
		results = r.normal.results
		if results == nil or #results == 0 then
			if r.normal.result_count ~= nil then
				results = {{name = r.normal.result, amount = math.max(r.normal.result_count,1)}}
			else
				results = {{name = r.normal.result, amount = 1}}
			end	
		else
			results = {{name = r.result, amount = 1}}	
		end
	else
		results = r.results;
		if results == nil or #results == 0 then
			if r.result_count ~= nil then
				results = {{name = r.result, amount = math.max(r.result_count,1)}}
			else
				results = {{name = r.result, amount = 1}}
			end
		else
			results = {{name = r.result, amount = 1}}
		end		
	end	
	if #results == 0 then
		results = {{name = r.result, amount = 1}}
	end
	return results
end

--todo better solution
function get_raw_ingredients(recipe,exclude)
	
	local ingredients = {}
	if exclude == nil then exclude = {} end

	for i,ingredient in pairs(recipe.ingredients) do
		local name, amount = 0
		if (ingredient.type) then
			name = ingredient.name
			amount = ingredient.amount
		elseif (ingredient[1] and ingredient[2]) then
			name = ingredient[1]
			amount = ingredient[2]
		end
		if (amount > 0 and table_contains(exclude,name) == false) then --skip duplicate ingredients
			table.insert(exclude,name)
			local subrecipe = local_get_recipe(name)
			local multiple = 1;			
			local results = local_get_recipe_results(name)
			if results ~= nil then
				for j,product in pairs(results) do
					if (product.name == name) then 
						multiple = product.amount
					end
				end
			end
			if (subrecipe == nil) then 
				ingredients[name] = amount / multiple
			else	
				for subname,subamount in pairs(get_raw_ingredients(subrecipe,exclude)) do
					if (ingredients[subname]) then
						ingredients[subname] = ingredients[subname] + subamount * amount / multiple
					else 
						ingredients[subname] = subamount * amount / multiple
					end
				end
			end
		end				
	end
	return ingredients	
	end

local get_total_ingredients = function(recipe)
	local total = 0
	local ingredients = get_raw_ingredients(recipe)
	for name,amount in pairs(ingredients) do
		if ingredients ~= nil then
			total = total + amount
		end
	end
	return total
end

local local_add_loot = function(surface_index, area )
	if not loot_table then return end
	if distance(0,0,area.left_top.x,area.left_top.y) < loot_exclude_distance_from_origin then return end
	if not global.modmash.loot.loot_tech_modifier then global.modmash.loot.loot_tech_modifier = 0 end
	if math.random(1, loot_tech_probability+math.floor(global.modmash.loot.loot_tech_modifier)) == 2 then local_add_tech_loot(surface_index, area) end
	if settings.startup["modmash-setting-item-loot"].value == "Disabled" then return end
	if global.modmash.loot.loot_modifier == nil then global.modmash.loot.loot_modifier = 0 end
	if math.random(1, loot_probability+math.floor(global.modmash.loot.loot_modifier)) ~= 1 then return end
	global.modmash.loot.loot_modifier = global.modmash.loot.loot_modifier + 0.2
	local stack = nil	

	local surface = game.surfaces[surface_index]
	local position = {x=area.left_top.x+math.random(0, 30),y=area.left_top.y+math.random(0, 30)}
	local distance_mod = math.max((distance(0,0,position.x,position.y)/1024.0),0.0) + 1.0
	local name = crash_site_prefix..math.random(1, 2)
	if surface.can_place_entity{name=name,position=position} then
		local ent = surface.create_entity{
			  name = name,
			  position = position,
			  force = force_neutral}
		if is_valid(ent) then
			local inv = ent.get_inventory(defines.inventory.chest)
			local group = loot_groups[math.random(1, #loot_groups)]
			local fill = local_is_loot_fill_item(group[1])		
			local item = nil
			if fill == true then 
				item = local_get_random_stack(group)
			else
				item = local_get_random_stack(nil)
			end
			if item ~= nil then
				local full_stack = {name=item.name, count=local_get_stack_restriction(item)}
				local stack = {name=item.name, count=math.random(1,local_get_stack_restriction(item))}			
				if fill then
					if settings.startup["modmash-setting-loot-fill"].value == "Disabled" then
						local stacks = math.random(3, math.ceil(10*distance_mod))
						for s=1, stacks do
							if inv.can_insert(stack) then inv.insert(stack) end
						end
					else
						local chance = math.random(1, 5)
						if chance == 3 then
							repeat
								if inv.can_insert(full_stack) then inv.insert(full_stack) end
							until(inv.can_insert(full_stack) == false)
						else
							local stacks = math.random(3, math.ceil(10*distance_mod))
							for s=1, stacks do
								if inv.can_insert(full_stack) then inv.insert(full_stack) end
							end
						end
					end
				else
					
					-- Test total
					local stacks = math.random(3, math.ceil(10*distance_mod))
					--log("Adding ".. item.name.. " to loot initial stacks "..stacks)
					local s_r = local_get_recipe(item.name)
					if s_r ~= nil then
						local t_i = get_total_ingredients(s_r)
						if t_i > math.ceil(50*distance_mod) then stacks = math.min(stacks,math.ceil(8*distance_mod)) end
						if t_i > math.ceil(150*distance_mod) then stacks = math.min(stacks,math.ceil(6*distance_mod)) end
						if t_i > math.ceil(400*distance_mod) then stacks = math.min(stacks,math.ceil(4*distance_mod)) end
						if t_i > math.ceil(600*distance_mod) then stacks = math.min(stacks,math.ceil(2*distance_mod)) end
						if t_i > math.ceil(1000*distance_mod) then stacks = math.min(stacks,math.ceil(1*distance_mod)) end
						--log("Modified to " .. stacks .. " total raw " .. t_i)
					end

				
				
					for s=1, stacks do
						if item.name == "droid" and global.modmash.droids_looted ~= true then
							global.modmash.droids_looted = true
							if inv.can_insert(stack) then inv.insert(stack) end
						else
							if inv.can_insert(stack) then inv.insert(stack) end
						end
					end	
				end
			end
		end
	end
	end

local local_on_chunk_charted = function(event)	   
	local id = event.surface_index.."_"..event.position.x.."_"..event.position.y
	if game.surfaces[event.surface_index].name ~= "nauvis" and settings.startup["modmash-setting-loot-planet"].value == "Nauvis" then return end
	if not global.modmash.last_chunk then global.modmash.last_chunk = nil end
	if global.modmash.last_chunk == id then return end
	if table_index_of(chunks,id) == nil then
		table.insert(chunks,id)
		global.modmash.last_chunk = id
		local_add_loot(event.surface_index, event.area)
	end	
	end

local can_research = function(tech)
    if not tech or tech.researched or not tech.enabled then
        return false
    end
    for _, pretech in pairs(tech.prerequisites) do
        if not pretech.researched then
            return false
        end
    end
    return true
	end

local local_on_selected = function(player,entity)
	if settings.startup["setting-tech-loot"].value == "Disabled" then return end
	local surface = entity.surface
	local position = entity.position
	entity.destroy()
	surface.create_entity{
			  name = loot_science_b,
			  position = position,
			  force = force_neutral}
	if settings.startup["setting-tech-loot"].value == "Science" then
		local stacks = math.random(3, 10)
		for s=1, stacks do
			local item =  ({"science-pack"})
			if item ~= nil then
				local stack = {name=item.name, count=local_get_stack_restriction(item)}

				if player.can_insert(stack) then
					player.insert(stack)
				else
					surface.spill_item_stack(	position, {name=stack.name, count=stack.count})
				end
			end
		end	
	else
		local current_research = player.force.current_research
		local researchable = {}
		for _,t in pairs(player.force.technologies) do
			if t.researched == false then		
				if current_research ~= nil and current_research.name ~= t.name and can_research(t) then
					table.insert(researchable,t)
				elseif can_research(t) then
					table.insert(researchable,t)
				end
			end
		end
		if #researchable > 0 then
			current_research = researchable[math.random(1, #researchable)]
		end
		if current_research ~= nil then 
			current_research.researched = true
			if current_research.localised_name ~= nil and type(current_research.localised_name)~="table" then
				print("Unlocked "..current_research.localised_name)
			else
				print("Unlocked "..current_research.name:gsub("-", " "))
			end
		else		
			if player.force.technologies["automation"].researched == false then			
				player.force.technologies["automation"].researched = true
				print("Unlocked "..player.force.technologies["automation"].localised_name)
			end
		end
	end
	end



modmash.register_script({
	names = {loot_science_a},
	on_init = local_init,
	on_start = local_start,
	on_load = local_load,
	on_selected_by_name = local_on_selected,
	on_chunk_charted = local_on_chunk_charted,
	on_configuration_changed = local_on_configuration_changed
})

remote.add_interface("modmashsplinterunderground",
	{
		register_surface = local_register_surface,
		register_resource_level_one = local_register_resource_level_one,
		register_resource_level_two = local_register_resource_level_two,
		ban_entity_level_zero = local_ban_entity_level_zero,
		ban_entity_level_one = local_ban_entity_level_one,
		ban_entity_level_two = local_ban_entity_level_two
	})