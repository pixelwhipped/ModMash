--need to add or condition to items, will be either on thing or the other in table no sub probabilites
-- make items either a thing or a table of elements
require("prototypes.scripts.defines") 
local loot_probability = nil
local loot_tech_probability = nil
local loot_exclude_distance_from_origin = modmashsplinterloot.defines.loot_exclude_distance_from_origin
local loot_max_distance_reduction_modifier = modmashsplinterloot.defines.loot_max_distance_reduction_modifier
local crash_site_chest_inventory = modmashsplinterloot.defines.crash_site_chest_inventory
local crash_site_chest_health = modmashsplinterloot.defines.crash_site_chest_health

local force_neutral = modmashsplinterloot.util.defines.names.force_neutral

local loot_science_a = modmashsplinterloot.defines.names.loot_science_a
local loot_science_b = modmashsplinterloot.defines.names.loot_science_b
local crash_site_prefix = modmashsplinterloot.defines.names.crash_site_prefix

local table_index_of = modmashsplinterloot.util.table.index_of
local table_contains = modmashsplinterloot.util.table.contains
local distance  = modmashsplinterloot.util.distance
local starts_with  = modmashsplinterloot.util.starts_with
local print = modmashsplinterloot.util.print
local is_valid  = modmashsplinterloot.util.is_valid
local get_item = modmashsplinterloot.util.get_item

local chunks = nil
local loot_table = nil
local loot_table_names = nil
local loot_table_probability_table = nil
local science_table = nil
local science_prabability_table = nil

--creates a probability table to migrate to base and add muliplier currenlty 10 as most functiosn allow range 0.1 to 1
local local_build_probability_table = function(res,get)
	local tbl = {}
	for k=1, #res do
		local c = math.ceil(res[k].probability*10)
		local element = get(res[k])
		for j=1, c do
			table.insert(tbl,element)
		end
	end
	return tbl
end

local local_register_science_pack = function(science)
	if global.modmashsplinterloot.science_table == nil then global.modmashsplinterloot.science_table = {} end
	if settings.startup["setting-tech-loot"].value ~= "Science" then return end
	if type(science) ~= "table" then log("Expected table in register_science_pack") return end
	if science.name == nil or type(science.name) ~= "string" or #science.name == 1 then log("Missing name in register_science_pack") return end
	local name = science.name
	local max_stacks = science.max_stacks
	local max_stack = science.max_stack
	local item = get_item(name)
	local probability = science.probability
	if item == nil then log("Missing item for"..name.." in register_science_pack")  return end
	if item.type ~= "tool" then log("Science pack "..name.." is not of type tool") return end
	if item.stack_size == 1 then log("Science pack " .. " stack_size is 1") return end
	if max_stacks == nil then max_stacks = crash_site_chest_inventory end
	if max_stack == nil then max_stack = item.stack_size end
	if probability == nil then  probability = 0.2 end
	probability = math.max(0.1,probability)
	probability = math.min(probability,0.1)
	for k =1, #global.modmashsplinterloot.science_table do
		if global.modmashsplinterloot.science_table[k].name == name then
			global.modmashsplinterloot.science_table[k].max_stacks = max_stacks
			global.modmashsplinterloot.science_table[k].max_stack = max_stack
			global.modmashsplinterloot.science_table[k].probability = probability
			global.modmashsplinterloot.science_prabability_table = local_build_probability_table(global.modmashsplinterloot.science_table, function(i) return i.name end)
			return
		end
	end
	table.insert(global.modmashsplinterloot.science_table,{name = name, max_stack = max_stack, max_stacks = max_stacks, probability = probability})	
	global.modmashsplinterloot.science_prabability_table = local_build_probability_table(global.modmashsplinterloot.science_table, function(i) return i.name end)
end

local local_create_science_table = function()
	if global.modmashsplinterloot.science_table == nil then global.modmashsplinterloot.science_table = {} end
	local vanilla_packs = {
		{name = "automation-science-pack",probability = 0.5},
		{name = "logistic-science-pack",probability = 0.5},		
		{name = "military-science-pack",probability = 0.4},
		{name = "chemical-science-pack",probability = 0.3},		
		{name = "production-science-pack",probability = 0.2},
		{name = "utility-science-pack",probability = 0.2},
		{name = "space-science-pack",probability = 0.1}}
	for k=1, #vanilla_packs do
		local_register_science_pack(vanilla_packs[k])
	end
end

local local_insert_loot_item = function(tbl,item)
	local probability = item.probability
	local item_prototype = get_item(item.name)
	if item_prototype == nil then return end -- should never happen
	if probability == nil then probability = 0.2 end
	probability = math.max(0.1,probability)
	probability = math.min(probability,0.1)
	local stack_size = item.stack_size
	if stack_size == nil then stack_size = item_prototype.stack_size end
	stack_size = math.min(stack_size,item_prototype.stack_size)
	local max_stacks = item.max_stacks
	if max_stacks == nil then max_stacks = 6 end
	max_stacks = math.max(1,max_stacks)
	max_stacks = math.min(max_stacks,48)
	
	
	table.insert(tbl,{name = item.name, probability = probability,stack_size = stack_size, max_stacks = max_stacks, initial_max_stacks = max_stacks})
end
--only accessable from local_register_loot so all values should be validated
local local_register_loot_item = function(name,items)
		--log("local_register_loot_item for " .. name)
		--log(serpent.block(items))
		local tbl = global.modmashsplinterloot.loot_table[name]
		if type(items) ~= "table" then log("Expected item(s) table for "..name) return end
		-- lets keep the logic large but simple
		if #tbl.items >= 48 then -- can have more the 48 things due to crashed loot contains having 48 slots
			log("Cannot add to "..name.." to many elements")
			return
		end 
		if #tbl.items == 0 then --first items	
			local new_table = {}
			for k=1, #items do	
				local_insert_loot_item(new_table, items[k])
			end
			table.insert(tbl.items, new_table)
		else -- check existing including case of potential subtable containg any item
			for k=1, #items do	
				if type(items[k].name) == "string" and #items[k].name > 0 then
					if get_item(items[k].name) ~= nil then
						local exists = -1
						for j=1, #tbl.items do
							if tbl.items[j].name == items[k].name then 
								exists = k 
								break
							end
						end
						if exists > 0 then
							--update
							local probability = items[k].probability
							if probability == nil then probability = tbl.items[exists].probability end
							probability = math.max(0.1,probability)
							probability = math.min(probability,0.1)
							local max_stacks = items[k].max_stacks
							if max_stacks == nil then max_stacks = tbl.items[exists].max_stacks end
							max_stacks = math.max(1,max_stacks)
							max_stacks = math.min(max_stacks,48)
							local stack_size = items[k].stack_size
							if stack_size == nil then stack_size = tbl.items[exists].stack_size end --dont need to check item prototype is in initial call to local_insert_loot_item

							tbl.items[j].probability = probability
							tbl.items[j].max_stacks = max_stacks
							tbl.items[j].initial_max_stacks = max_stacks

						else
							local new_table = {}
							for k=1, #items do	
								local_insert_loot_item(new_table, items[k])
							end
							table.insert(tbl.items, new_table)
						end
					else
						log("acutal item "..items[k].name.. " not found")
					end
				end
			end
		end
	end

local local_validate_item_stacks = function(name)
	if #global.modmashsplinterloot.loot_table[name].items == 0 then 
		global.modmashsplinterloot.loot_table[name] = nil
		for k = 1, #global.modmashsplinterloot.loot_table_names do
			if global.modmashsplinterloot.loot_table_names[k].name == name then
				table.remove(global.modmashsplinterloot.loot_table_names,k)
				return false
			end
		end
	end
	return true
end

local local_max_stack_in = function(item)
	local max = 0
	for k = 1, #item do
		if item[k].initial_max_stacks > max then max = item[k].initial_max_stacks end
	end
	return max
end


local local_scale_loot_item_stacks = function(name)
	
	local loot = global.modmashsplinterloot.loot_table[name]
	--log("Scaling stack")
	--log(serpent.block(loot.items))
	for attempt = 1, 3 do
		local sum = 0
		for k = 1, #loot.items do local item = loot.items[k]
			if #item == 1 then
				sum = sum + item[1].max_stacks
			else
				sum = sum + local_max_stack_in(item)
			end
		end
		if sum > 48 then			
			local scale = 48/sum
			sum = 0
			--log("scale "..scale)
			for k = 1, #loot.items do local item = loot.items[k]
				for j = 1, #item do local or_item = item[j]
				--	log("before-------------")
					--log(serpent.block(or_item))
					or_item.max_stacks = math.floor(or_item.max_stacks*scale)
					or_item.max_stacks = math.max(or_item.max_stacks,1)		
					--log("after-------------")
					--log(serpent.block(or_item))
				end
				sum = sum + local_max_stack_in(item)
			end
		end
		if sum <= 48 then
			return true
		end		
	end
	return false
end

local local_register_loot = function(loot)
	if loot == nil then log("passed nil") return end
	if global.modmashsplinterloot.loot_table == nil then global.modmashsplinterloot.loot_table = {} end
	if global.modmashsplinterloot.loot_table_names == nil then global.modmashsplinterloot.loot_table_names = {} end
	if type(loot) ~= "table" then log("Expected table in register_loot") return end
	if loot.name == nil or type(loot.name) ~= "string" or #loot.name == 1 then 
		log("Missing name in register_loot")
		log(serpent.block(loot))
		return
	end
	local name = loot.name
	local probability = loot.probability
	if probability == nil then  probability = 0.2 end
	probability = math.max(0.1,probability)
	probability = math.min(probability,0.1)
	if loot.items == nil or type(loot.items) ~= "table" or #loot.items == 0 then log("Missing items for loot "..name) return end
	if global.modmashsplinterloot.loot_table[name] == nil then
		global.modmashsplinterloot.loot_table[name] = {name = name, probability = probability, items = {}}
		table.insert(global.modmashsplinterloot.loot_table_names, {name = name, probability = probability})
	end
	--log("adding "..#loot.items.." items")
	for k = 1, #loot.items do
		-- not requied but items should be a table of or items, is this or that or that
		local i = loot.items[k]
		if #i==0 and type(i.name) == "string" and #i.name > 0 then 
			local_register_loot_item(name,{i}) -- malformed but ok only one item so will wrap correctly
		elseif #i ~= 0 then
			local_register_loot_item(name,i)
		end
	end
	--add test condition items any otherwise remove or proceed to scale item stacks
	if local_validate_item_stacks(name) == true then
		if local_scale_loot_item_stacks(name) == false then -- will need to ensure stacks do not exceed 48
			-- could not scale to fit
			log("Could not scale "..name.." items to fit in container")
			for k = 1, #global.modmashsplinterloot.loot_table_names do
				global.modmashsplinterloot.loot_table[name] = nil
				if global.modmashsplinterloot.loot_table_names[k].name == name then
					table.remove(global.modmashsplinterloot.loot_table_names,k)
					return false
				end
			end
		end
	end
end

local local_create_loot_table = function()
	--log("local_create_loot_table")
	if global.modmashsplinterloot.loot_table == nil then global.modmashsplinterloot.loot_table = {} end
	if global.modmashsplinterloot.loot_table_names == nil then global.modmashsplinterloot.loot_table_names = {} end
	local vanilla = 
	{
		{name = "logistic_transport", probability = 0.5, 
			items = {
				{{name = "transport-belt",max_stacks = 15}},
				{{name = "underground-belt",max_stacks = 10, probability = 0.5}},
				{{name = "splitter",max_stacks = 6, probability = 0.5}}
			}
		},
		{name = "logistic_transport-fast", probability = 0.4, 
			items = {
				{{name = "fast-transport-belt",max_stacks = 15}},
				{{name = "fast-underground-belt",max_stacks = 10, probability = 0.5}},
				{{name = "fast-splitter",max_stacks = 6, probability = 0.5}}
			}
		},
		{name = "logistic_transport-express", probability = 0.3, 
			items = {
				{{name = "express-transport-belt",max_stacks = 15}},
				{{name = "express-underground-belt",max_stacks = 10, probability = 0.5}},
				{{name = "express-splitter",max_stacks = 6, probability = 0.5}}
			}
		},
		{name = "logistic_transport-train", probability = 0.1, 
			items = {
				{{name = "train-stop",max_stacks = 2, probability = 0.3}},
				{{name = "locomotive",max_stacks = 2, probability = 0.3}},
				{{name = "fluid-wagon",max_stacks = 2, probability = 0.3}},
				{{name = "cargo-wagon",max_stacks = 3, probability = 0.3}},
				{{name = "rail-chain-signal",max_stacks = 8, probability = 0.3}},
				{{name = "rail-signal",max_stacks = 8, probability = 0.3}}
			}
		},
		{name = "logistic_transport-inserters", probability = 0.3, 
			items = {
				{{name = "inserter",max_stacks = 10}},
				{{name = "long-handed-inserter",max_stacks = 10}},
				{{name = "fast-inserter",max_stacks = 2}},
				{{name = "filter-inserter",max_stacks = 3, probability = 0.2}}
			}
		},
		{name = "logistic_transport-inserters-advanced", probability = 0.2,
			items = {
				{{name = "stack-inserter",max_stacks = 3}},
				{{name = "stack-filter-inserter",max_stacks = 3, probability = 0.5}}
			}
		},
		{name = "beacons-module-speed", probability = 0.1,
			items = {
				{{name = "beacon",max_stacks = 5, probability = 0.5}},
				{{name = "speed-module",max_stacks = 6},{name = "speed-module-2",max_stacks = 6},{name = "speed-module-3",max_stacks = 6}}
			}
		},
		{name = "beacons-module-productivity", probability = 0.1,
			items = {
				{{name = "stack-beacon",max_stacks = 5, probability = 0.5}},
				{{name = "productivity-module",max_stacks = 6},{name = "productivity-module-2",max_stacks = 6},{name = "productivity-module-3",max_stacks = 6}}
			}
		},
		{name = "beacons-module-effectivity", probability = 0.1,
			items = {
				{{name = "stack-beacon",max_stacks = 5, probability = 0.5}},
				{{name = "effectivity-module",max_stacks = 6},{name = "effectivity-module-2",max_stacks = 6},{name = "effectivity-module-3",max_stacks = 6}}
			}
		},
		{name = "logistics-bots", probability = 0.1,
			items = {
				{{name = "roboport",max_stacks = 5, probability = 0.5}},
				{{name = "construction-robot",max_stacks = 10},{name = "logistic-robot",max_stacks = 10}},
				{{name = "logistic-chest-storage",max_stacks = 4, probability = 0.8}},
				{{name = "logistic-chest-requester",max_stacks = 6, probability = 0.5}},
				{{name = "logistic-chest-passive-provider",max_stacks = 6, probability = 0.5}},
				{{name = "logistic-chest-active-provider",max_stacks = 5, probability = 0.25},{name = "logistic-chest-buffer",max_stacks = 5, probability = 0.25}}
			}
		},
		{name = "player", probability = 0.1,
			items = {
				{
					{name = "light-armor",max_stacks = 1, max_stack=1},
					{name = "heavy-armor",max_stacks = 1, max_stack=1},
					{name = "modular-armor",max_stacks = 1, max_stack=1},
					{name = "power-armor",max_stacks = 1, max_stack=1},
					{name = "power-armor-mk2",max_stacks = 1, max_stack=1}
				},
				{
					{name = "belt-immunity-equipment",max_stacks = 1, max_stack=1},
					{name = "night-vision-equipment",max_stacks = 1, max_stack=1},
					{name = "personal-laser-defense-equipment",max_stacks = 1, max_stack=5}
				},
				{
					{name = "battery-equipment",max_stacks = 1, max_stack=1, probability = 0.5},
					{name = "battery-mk2-equipment",max_stacks = 1, max_stack=1, probability = 0.5}
				},
				{
					{name = "personal-roboport-equipment",max_stacks = 1, max_stack=1, probability = 0.2},
					{name = "personal-roboport-mk2-equipment",max_stacks = 1, max_stack=1, probability = 0.1}
				},
				{
					{name = "solar-panel-equipment",max_stacks = 1, max_stack=5, probability = 0.5},
					{name = "fusion-reactor-equipment",max_stacks = 1, max_stack=2, probability = 0.2}
				},
			}
		},
		{name = "assembling", probability = 0.4,
			items = {
				{{name = "pumpjack",max_stacks = 5, probability = 0.5},{name = "assembling-machine-1",max_stacks = 5, probability = 0.5},{name = "assembling-machine-2",max_stacks = 5, probability = 0.5},{name = "assembling-machine-3",max_stacks = 5, probability = 0.5}},
				{{name = "boiler",max_stacks = 1, probability = 0.5}},
				{{name = "steam-engine",max_stacks = 1, probability = 0.5}},
				{{name = "pipe",max_stacks = 6, probability = 0.8}},
				{{name = "pipe-to-ground",max_stacks = 6, probability = 0.5}},
				{{name = "offshore-pump",max_stacks = 1, probability = 0.5},{name = "pump",max_stacks = 1, probability = 0.5}},
				{{name = "big-electric-pole",max_stacks = 5},{name = "medium-electric-pole",max_stacks = 5},{name = "small-electric-pole",max_stacks = 5}}
			}
		},
		{name = "assembling-more", probability = 0.2,
			items = {
				{{name = "chemical-plant",max_stacks = 5},{name = "centrifuge",max_stacks = 2},{name = "oil-refinery",max_stacks = 2}},
				{{name = "pipe",max_stacks = 6, probability = 0.8}},
				{{name = "pipe-to-ground",max_stacks = 6, probability = 0.5}}
			}
		},
		{name = "military", probability = 0.2,
			items = {
				{{name = "gun-turret",max_stacks = 5},{name = "laser-turret",max_stacks = 5}},
				{{name = "shotgun",max_stacks = 1,max_stack=1},{name = "combat-shotgun",max_stacks = 1,max_stack=1},{name = "submachine-gun",max_stacks = 1,max_stack=1}},
				{{name = "stone-wall",max_stacks = 10, probability = 0.8}},
				{{name = "firearm-magazine",max_stacks = 6},{name = "piercing-rounds-magazine",max_stacks = 6},{name = "uranium-rounds-magazine",max_stacks = 6}},
				{{name = "shotgun-shell",max_stacks = 6},{name = "piercing-shotgun-shell",max_stacks = 6}},
				{{name = "land-mine",max_stacks = 1}}				
			}
		}
	}
	for k=1, #vanilla do
		local_register_loot(vanilla[k])
	end
end

-- 13-((13-3)*1) = 3 rnd range = 1..3
-- 13-((13-3)*0.5) = 8 rnd range = 1..8
local local_set_probability = function()
	local percent = settings.startup["setting-loot-chance"].value/100
	loot_probability = (modmashsplinterloot.defines.loot_probability)-((modmashsplinterloot.defines.loot_probability-3)*percent)
	loot_tech_probability = (modmashsplinterloot.defines.loot_tech_probability)-((modmashsplinterloot.defines.loot_tech_probability-3)*percent)	
	end


local local_init = function()	
	if global.modmashsplinterloot.loot == nil then global.modmashsplinterloot.loot = {} end
	if global.modmashsplinterloot.loot_table == nil then local_create_loot_table() end
	if global.modmashsplinterloot.science_table == nil or global.modmashsplinterloot.science_prabability_table == nil then local_create_science_table() end
	if global.modmashsplinterloot.chunks == nil then global.modmashsplinterloot.chunks = {} end
	chunks = global.modmashsplinterloot.chunks
	loot_table = global.modmashsplinterloot.loot_table
	loot_table_names = global.modmashsplinterloot.loot_table_names
	science_table = global.modmashsplinterloot.science_table
	local_set_probability()
	end

local local_load = function()	
	chunks = global.modmashsplinterloot.chunks
	loot_table = global.modmashsplinterloot.loot_table
	science_table = global.modmashsplinterloot.science_table
	loot_table_names = global.modmashsplinterloot.loot_table_names
	local_set_probability()
	end

local local_add_tech_loot = function(surface_index, area)
	if settings.startup["setting-tech-loot"].value == "Disabled" then return end	
	global.modmashsplinterloot.loot_tech_modifier = global.modmashsplinterloot.loot_tech_modifier + 0.2
	local surface = game.surfaces[surface_index]
	local position = {x=area.left_top.x+math.random(0, 30),y=area.left_top.y+math.random(0, 30)}
	local name = loot_science_a
	local any = surface.find_entities_filtered{area = {{position.x-128, position.y-128}, {position.x+128, position.y+128}}, name = {loot_science_a,loot_science_b}}
	if any ~= nil and #any>0 then return end
	if surface.can_place_entity{name=name,position=position} then
		local ent = surface.create_entity{
			  name = name,
			  position = position,
			  force = force_neutral}
	end
	end

local local_get_random_loot_stack = function(distance_mod)
	--log("Geeting stack mod="..distance_mod)
	if loot_table_probability_table == nil then loot_table_probability_table = local_build_probability_table(loot_table_names, function(i) return loot_table[i.name] end) end
	--log(serpent.block(loot_table_probability_table))
	local loot = loot_table_probability_table[math.random(1,#loot_table_probability_table)]
	if loot == nil then return nil end
	--first build stack of what we are using due to some items being this or that
	local uses_stack = {}
	for k = 1, #loot.items do
		--log(serpent.block(loot.items))
		--log("-----------------------------")
		--log(serpent.block(loot.items))
		if #loot.items[k] == 0 then
		--	log("Somthing empty snuck in")
		--	log(serpent.block(loot.items[k]))
		else
			table.insert(uses_stack,loot.items[k][math.random(1,#loot.items[k])])
		end
	end
	--log(serpent.block(uses_stack))
	local stack = {}
	for k = 1, #uses_stack do local item = uses_stack[k]
		
		local stacks = math.max(1,math.random(math.ceil(item.max_stacks*distance_mod),item.max_stacks))
		for j = 1, stacks do
			if math.random(0,1.1) < item.probability then
				--quick fix
				if game.item_prototypes[item.name]~=nil then
					table.insert(stack, {name = item.name, count = math.random(math.ceil(item.stack_size*distance_mod),item.stack_size) })
				end
			end
		end
	end
	return stack
end

local local_add_loot = function(surface_index, area)
	
	if not loot_table then return end
	if distance(0,0,area.left_top.x,area.left_top.y) < loot_exclude_distance_from_origin then return end
	if not global.modmashsplinterloot.loot_tech_modifier then global.modmashsplinterloot.loot_tech_modifier = 0 end
	if math.random(1, loot_tech_probability+math.floor(global.modmashsplinterloot.loot_tech_modifier)) == 2 then local_add_tech_loot(surface_index, area) end
	if settings.startup["setting-item-loot"].value == "Disabled" then return end
	if global.modmashsplinterloot.loot_modifier == nil then global.modmashsplinterloot.loot_modifier = 0 end
	if math.random(1, loot_probability+math.floor(global.modmashsplinterloot.loot_modifier)) ~= 1 then return end
	global.modmashsplinterloot.loot_modifier = global.modmashsplinterloot.loot_modifier + 0.2
	local stack = nil	

	local surface = game.surfaces[surface_index]
	local position = {x=area.left_top.x+math.random(0, 30),y=area.left_top.y+math.random(0, 30)}
	local distance = distance(0,0,position.x,position.y)
	local name = crash_site_prefix..math.random(1, 2)
	if surface.can_place_entity{name=name,position=position} then
		local distance_mod = (distance/loot_max_distance_reduction_modifier)
		local distance_mod = math.min(distance_mod,1)
		local distance_mod = math.max(distance_mod,0.25)
		local ent = surface.create_entity{
			  name = name,
			  position = position,
			  force = force_neutral}
		if is_valid(ent) then
			local inv = ent.get_inventory(defines.inventory.chest)
			--item may not exist if removed need to check on config change
			local stacks = local_get_random_loot_stack(distance_mod)
			if stacks ~= nil and #stacks>0 then
				for s=1, #stacks do local stack = stacks[s]
					if inv.can_insert(stack) then inv.insert(stack) end
				end	
			end
		end
	end
end

local local_on_chunk_charted = function(event)	 
	
	--log(serpent.block(event))
	local id = event.surface_index.."_"..event.position.x.."_"..event.position.y
	local s = game.surfaces[event.surface_index]
	if s == nil then return end
	
	if s.name ~= "nauvis" and settings.startup["setting-loot-planet"].value == "Nauvis" then return end
	if not global.modmashsplinterloot.last_chunk then global.modmashsplinterloot.last_chunk = nil end
	if global.modmashsplinterloot.last_chunk == id then return end

	--log(serpent.block(s.map_gen_settings))
	if s.map_gen_settings~=nil and -- dont allow underground or space
				s.map_gen_settings.property_expression_names ~=nil and
				#s.map_gen_settings.property_expression_names == 0 
				or (s.map_gen_settings.property_expression_names["tile:water:probability"] ~=nil and
				type(s.map_gen_settings.property_expression_names["tile:water:probability"]) == "number" and
				s.map_gen_settings.property_expression_names["tile:water:probability"] < -100) then	
		if table_index_of(chunks,id) == nil then
			table.insert(chunks,id)
			global.modmashsplinterloot.last_chunk = id
			local_add_loot(event.surface_index, event.area)
		end	
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

local local_on_selected = function(event)
	if settings.startup["setting-tech-loot"].value == "Disabled" then return end
	local player = game.players[event.player_index]
	local entity = player.selected	
	if entity == nil then return end
	if entity.name ~= loot_science_a then return end
	local surface = entity.surface
	local position = entity.position
	entity.destroy()
	surface.create_entity{
			  name = loot_science_b,
			  position = position,
			  force = force_neutral}
	if settings.startup["setting-tech-loot"].value == "Science" then
		if global.modmashsplinterloot.science_prabability_table == nil then local_create_science_table() end

		local item = science_table[math.random(1,#global.modmashsplinterloot.science_prabability_table)]
		if item ~= nil then
			local stacks = math.random(1, item.max_stacks)
			for s=1, stacks do
				local stack = {name=item.name, count=item.max_stack}
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


script.on_init(local_init)
script.on_load(local_load)
script.on_event(defines.events.on_chunk_charted,local_on_chunk_charted)
script.on_event(defines.events.on_selected_entity_changed,local_on_selected)

remote.add_interface("modmashsplinterloot",
	{
		register_loot = local_register_loot,
	})

