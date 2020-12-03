data_final_fixes = true
require("prototypes.scripts.defines")
require ("prototypes.scripts.types")
local add_ingredient_to_recipe = modmashsplinterresources.util.add_ingredient_to_recipe


local local_add_loot_to_entity = function(entityType, entityName, probability, countMin, countMax)
	if settings.startup["setting-alien-loot-chance"].value == 0 then return end
    if data.raw[entityType] ~= nil then
        if data.raw[entityType][entityName] ~= nil then
            if data.raw[entityType][entityName].loot == nil then
                data.raw[entityType][entityName].loot = {}
            end
			local loot_probability = settings.startup["setting-alien-loot-chance"].value/100.0
            table.insert(data.raw[entityType][entityName].loot, 
			{
				item = "alien-ore", probability = probability * loot_probability, count_min = countMin, count_max = countMax
			}
			)
			table.insert(data.raw[entityType][entityName].loot,
			{
				item = "alien-artifact", probability = (probability / 20) * loot_probability, count_min = 1, count_max = 1
			}
			)
        end
    end end

local local_create_entity_loot = function()
	if settings.startup["setting-alien-loot-chance"].value == 0 then return end
	local max_health = 0
	for i,unit in pairs(data.raw["unit"]) do
		if unit.subgroup == "enemies" and unit.max_health then
			if unit.max_health > max_health then max_health = unit.max_health end
		end end

	for i,unit in pairs(data.raw["unit"]) do
		if unit.subgroup == "enemies" and unit.max_health then
			local min = (unit.max_health/max_health)*3
			local max = (unit.max_health/max_health)*50
			local_add_loot_to_entity("unit",unit.name,0.9,math.ceil(min),math.ceil(max))
		end end
	end

local_create_entity_loot()

if settings.startup["setting-glass-recipes"].value == "Enabled" then 
	add_ingredient_to_recipe("small-lamp",{name = "glass", amount = 1})
	add_ingredient_to_recipe("pipe",{name = "glass", amount = 1})

	add_ingredient_to_recipe("storage-tank",{name = "glass", amount = 1})
	add_ingredient_to_recipe("rail-chain-signal",{name = "glass", amount = 1})
	add_ingredient_to_recipe("rail-signal",{name = "glass", amount = 1})
	
	add_ingredient_to_recipe("lab",{name = "glass", amount = 2})
	add_ingredient_to_recipe("solar-panel",{name = "glass", amount = 1})
end