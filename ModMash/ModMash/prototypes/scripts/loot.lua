--[[check and import utils]]
if modmash == nil or modmash.util == nil then require("prototypes.scripts.util") end
if not modmash.defines then require ("prototypes.scripts.defines") end

--[[defines]]
local loot_probability = modmash.defines.defaults.loot_probability
local loot_tech_probability = modmash.defines.defaults.loot_tech_probability
local force_neutral = modmash.defines.names.force_neutral

local loot_science_prefix = modmash.defines.names.loot_science_prefix
local loot_science_a = modmash.defines.names.loot_science_a
local loot_science_b = modmash.defines.names.loot_science_b

local loot_min_stack = modmash.defines.defaults.loot_min_stack
local loot_max_stack = modmash.defines.defaults.loot_max_stack
local loot_exclude_distance_from_origin = modmash.defines.defaults.loot_exclude_distance_from_origin
local crash_site_prefix = modmash.defines.names.crash_site_prefix

--[[create local references]]

--[[util]]
local table_contains = modmash.util.table.contains
local table_index_of = modmash.util.table.index_of
local distance  = modmash.util.distance
local starts_with  = modmash.util.starts_with
local print = modmash.util.print
local get_name_for = modmash.util.get_name_for

--[[locals]]
local exclude_loot = {"player-port","spawner","spitter-spawner"}
local loot_table = nil
local last_chunk = nil

--[[unitialized globals]]
local chunks = nil

--[[ensure globals]]
local local_init = function()	
	log("loot.local_init")
	if global.modmash.loot == nil then global.modmash.loot = {} end
	if global.modmash.loot.chunks == nil then global.modmash.loot.chunks = {} end
	chunks = global.modmash.loot.chunks
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

local local_get_random_stack = function(group) 
	local item = nil
	repeat 
		item = loot_table[math.random(1, #loot_table)]
	until(table_contains(group, item.subgroup.name))
	return item
	end

local local_add_tech_loot = function(surface_index, area)
	if settings.startup["modmash-setting-tech-loot"].value == "Disabled" then return end
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

local local_add_loot = function(surface_index, area )
	if distance(0,0,area.left_top.x,area.left_top.y) < loot_exclude_distance_from_origin then return end
	if math.random(1, loot_tech_probability) == 2 then local_add_tech_loot(surface_index, area) end
	if settings.startup["modmash-setting-item-loot"].value == "Disabled" then return end
	if math.random(1, loot_probability) ~= 1 then return end
	local stack = nil

	local surface = game.surfaces[surface_index]
	local position = {x=area.left_top.x+math.random(0, 30),y=area.left_top.y+math.random(0, 30)}
	local name = crash_site_prefix..math.random(1, 2)
	if surface.can_place_entity{name=name,position=position} then
		local ent = surface.create_entity{
			  name = name,
			  position = position,
			  force = force_neutral}
		if ent ~= nil then
			local inv = ent.get_inventory(defines.inventory.chest)
			local group = loot_groups[math.random(1, #loot_groups)]
			local fill = local_is_loot_fill_item(group[1])		
			local item = local_get_random_stack(group)
			local full_stack = {name=item.name, count=local_get_stack_restriction(item)}
			local stack = {name=item.name, count=math.random(1,local_get_stack_restriction(item))}
			if fill then				
				if settings.startup["modmash-setting-loot-fill"].value == "Disabled" then
					local stacks = math.random(3, 10)
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
						local stacks = math.random(3, 10)
						for s=1, stacks do
							if inv.can_insert(full_stack) then inv.insert(full_stack) end
						end
					end
				end
			else
				local stacks = math.random(3, 10)
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

local local_get_item = function(name)
  if name == nil then return nil end
  local items = game.item_prototypes 
  if items then
    return items[name]
  end
  return nil 
  end

local local_create_loot_table = function()
	loot_table = {}
	if settings.startup["modmash-setting-item-loot"].value == "Disabled" then
		if settings.startup["modmash-setting-tech-loot"].value ~= "Science" then return end
	end

	for _,r in pairs(game.recipe_prototypes) do
		if starts_with(r.name,"craft-") and table_contains(exclude_loot,r.name) == false then
			if r.ingredients[1]~= nil and r.ingredients[1].name ~= nil then
				local i = local_get_item(r.ingredients[1].name)
				if i ~= nil and starts_with(i.name,"creative-mod") == false
					and starts_with(i.name,"deadlock-stack") == false then
					table.insert(loot_table,i)
				end
			end
		end
	end
	for _,i in pairs(game.item_prototypes) do
		if i.subgroup.name == "raw-resource" and table_contains(exclude_loot,i.name) == false 
			and starts_with(i.name,"deadlock-stack") == false then
			log(i.name)
			table.insert(loot_table,i) 
		end
	end
	end

local local_start = function()
	log("loot.local_start")
	chunks = global.modmash.loot.chunks	
	local_create_loot_table() 
	local percent = settings.startup["modmash-setting-loot-chance"].value/100
	loot_probability = (modmash.defines.defaults.loot_probability)-((modmash.defines.defaults.loot_probability-3)*percent)
	loot_tech_probability = (modmash.defines.defaults.loot_tech_probability)-((modmash.defines.defaults.loot_tech_probability-3)*percent)
	
	end

local local_on_chunk_charted = function(event)	
	local id = event.surface_index.."_"..event.position.x.."_"..event.position.y
	if last_chunk == id then return end
	if table_index_of(chunks,id) == nil then
		table.insert(chunks,id)
		last_chunk = id
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
	if settings.startup["modmash-setting-tech-loot"].value == "Disabled" then return end
	local surface = entity.surface
	local position = entity.position
	entity.destroy()
	surface.create_entity{
			  name = loot_science_b,
			  position = position,
			  force = force_neutral}
	if settings.startup["modmash-setting-tech-loot"].value == "Science" then
		local stacks = math.random(3, 10)
		for s=1, stacks do
			local item = local_get_random_stack({"science-pack"})
			local stack = {name=item.name, count=local_get_stack_restriction(item)}

			if player.can_insert(stack) then
				player.insert(stack)
				print("Science")
			else
				surface.spill_item_stack(	position, {name=stack.name, count=stack.count})
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

local local_on_configuration_changed = function(f)
	if f.mod_changes["modmash"].old_version < "0.17.61" then	
		for _, surface in pairs(game.surfaces) do
			for c in surface.get_chunks() do
				if #surface.find_entities_filtered{area = c.area, name={"loot_science_a","loot_science_b","crash-site-chest-1","crash-site-chest-2"}} > 0 then
					local i = surface.index.."_".. (c.area.left_top.x/32).."_"..(c.area.left_top.y/32)
					table.insert(global.modmash.loot.chunks,i)
				end
			end
		end
	end
	end

modmash.register_script({
	names = {loot_science_a},
	on_init = local_init,
	on_start = local_start,
	on_selected_by_name = local_on_selected,
	on_chunk_charted = local_on_chunk_charted,
	on_configuration_changed = local_on_configuration_changed
})