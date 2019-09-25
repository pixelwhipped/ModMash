data_final_fixes = true
require("prototypes.entity.logistics")
require ("prototypes.scripts.types")
if not util then require("prototypes.scripts.util") end

local local_add_loot_to_entity = function(entityType, entityName, probability, countMin, countMax)
    if data.raw[entityType] ~= nil then
        if data.raw[entityType][entityName] ~= nil then
            if data.raw[entityType][entityName].loot == nil then
                data.raw[entityType][entityName].loot = {}
            end
            table.insert(data.raw[entityType][entityName].loot, 
			{ 
				item = "alien-ore", probability = probability, count_min = countMin, count_max = countMax 
			}
			)
			table.insert(data.raw[entityType][entityName].loot, 
			{ 
				item = "alien-artifact", probability = 0.045, count_min = 1, count_max = 1 
			}
			)
        end
    end end

local local_create_entity_loot = function()
	local max_health = 0
	for i,unit in pairs(data.raw["unit"]) do
		if unit.subgroup == "enemies" then
			if unit.max_health > max_health then max_health = unit.max_health end
		end end

	for i,unit in pairs(data.raw["unit"]) do
		if unit.subgroup == "enemies" then
			local min = (unit.max_health/max_health)*3
			local max = (unit.max_health/max_health)*50
			local_add_loot_to_entity("unit",unit.name,0.9,math.ceil(min),math.ceil(max))
		end end
	end

local_create_entity_loot()

--[[
local create_technology = function(level)
	log("Creating Technology fluid-handling-"..level)
	return  
	{
		{
			type = "technology",
			name = "fluid-handling-"..level,
			icon = "__base__/graphics/technology/fluid-handling.png",
			icon_size = 128,
			localised_name = "Fluid Handling "..level,
			localised_description = "Increases the underground pipe range by 25%",			
			effects = {},
			prerequisites =
			{
				"fluid-handling-"..(level-1)
			},
			unit =
			{
				count = 250,
				ingredients =
				{
					{"automation-science-pack", 1},
					{"logistic-science-pack", 1},
					{"chemical-science-pack", 1}
				},
				time = 45
			},
			upgrade = true,
			order = "a-b-d",
		},
	}
end

local local_create_pipe = function(index, r, e)
	local original_name = e.name 
		
	for k = 2, 5 do			
		local item = util.table.deepcopy(data.raw["item"][r.name])		
		local entity = util.table.deepcopy(e)
		local recipe = util.table.deepcopy(r)
		local level_name = "-level-"..k
		local name = original_name .. level_name

		-------------------- Dexy Edit  + Ben Edit-----------
        if item ~= nil and entity ~= nil and recipe ~= nil then

        ---------------------------------------------------

			log("Creating " .. name)

			item.name = name
			item.place_result = name

			recipe.name = name
			recipe.result = name

			entity.name = name
			entity.minable.result = name

			local local_name = name:gsub("-", " ")
			local_name = local_name:gsub("(%l)(%w*)", function(a,b) return string.upper(a)..b end)
			item.localised_name = local_name
			entity.localised_name = local_name
			recipe.localised_name = local_name
			item.localised_description = local_name
			entity.localised_description = local_name
			recipe.localised_description = local_name
			recipe.enabled = false
			for index, connection in pairs(entity.fluid_box.pipe_connections) do
				if connection.max_underground_distance then
					entity.fluid_box.pipe_connections[index].max_underground_distance = math.floor(entity.fluid_box.pipe_connections[index].max_underground_distance * (1+(0.25*(k-1))))
				end
			end						

			data:extend({item})
			data:extend({recipe})
			data:extend({entity})
			data:extend({item})
			log("Adding " .. name .. " to Technology fluid-handling-".. (k+2))
			table.insert(
				data.raw["technology"]["fluid-handling-".. (k+2)].effects,
				{type = "unlock-recipe",recipe = name}
			)
		end
	end
end

local local_create_pipe_levels = function()
	log("Building Pipe Levels")
	for k=4, 7 do
		data:extend(create_technology(k))
	end
	local index = 1
	local pipes = {}
	for name, recipe in pairs(data.raw.recipe) do 
		if recipe.result ~= nil then
			local entity = data.raw["pipe-to-ground"][recipe.result]
			if entity ~= nil then
				log("Preparing to extend " .. recipe.name)
				table.insert(pipes,{i=index,r=recipe,e=entity})					
			end
		end
		index = index + 1
	end
	for _, p in pairs(pipes) do 
		local_create_pipe(p.i,p.r,p.e)
	end
end

--local_create_pipe_levels()
]]


data.raw["capsule"]["raw-fish"].capsule_action.attack_parameters.ammo_type.action.action_delivery.target_effects.damage = {type = "physical", amount = -20}