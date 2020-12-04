data_final_fixes = true
require("prototypes.scripts.defines")
require ("prototypes.scripts.types")
local add_ingredient_to_recipe = modmashsplinterresources.util.add_ingredient_to_recipe
local get_name_for = modmashsplinterresources.util.get_name_for
local create_icon =	modmashsplinterresources.util.create_icon
local create_layered_icon_using =	modmashsplinterresources.util.create_layered_icon_using

local icon_pin_topleft = modmashsplinterresources.util.defines.icon_pin_topleft
local icon_pin_top = modmashsplinterresources.util.defines.icon_pin_top
local icon_pin_topright = modmashsplinterresources.util.defines.icon_pin_topright
local icon_pin_right = modmashsplinterresources.util.defines.icon_pin_right
local icon_pin_bottomright = modmashsplinterresources.util.defines.icon_pin_bottomright
local icon_pin_bottom = modmashsplinterresources.util.defines.icon_pin_bottom
local icon_pin_bottomleft = modmashsplinterresources.util.defines.icon_pin_bottomleft
local icon_pin_left = modmashsplinterresources.util.defines.icon_pin_left


local create_local_create_fish_conversion_icon = function(item)
	local icon = create_layered_icon_using(
	{
		{
			icon = "__modmashsplinterresources__/graphics/icons/fish-oil.png",
			icon_mipmaps = 4,
			icon_size = 64,
		},
		{
			from = item,
			scale = 0.65,
			pin = icon_pin_bottomright
		}
	})
	return icon
end


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


local local_create_fish_conversion = function(item)
	data:extend(
	{
		{
			type = "recipe",
			name = "fish-conversion-for-"..item.name,
			energy_required = 1.5,
			enabled = true,
			category = "crafting-with-fluid",
			ingredients = {{item.name, 1}},
			icon = false,
			icons = create_local_create_fish_conversion_icon(item),
			icon_size = 64,
			localised_name = "Fish oil",
			localised_description = "Fish oil",
			subgroup = "fluid-recipes",
			order = "y[fish-conversion]["..item.name.."]",
			main_product = "",
			results =
			{			
				{
					type = "fluid",
					name = "fish-oil",
					amount = 25,
				}			
			},
			crafting_machine_tint =
			{
			  primary = {r = 1.000, g = 1, b = 0.0, a = 0.000},
			  secondary = {r = 0.812, g = 0.812, b = 0.0, a = 0.000},
			  tertiary = {r = 0.960, g = 0.960, b = 0.0, a = 0.000},
			},
			allow_decomposition = false,
		}
	})
end

for name,fish in pairs(data.raw["fish"]) do
	if fish.minable ~= nil and fish.minable.result ~= nil then
		local item = data.raw["capsule"][fish.minable.result] 
		if item == nil then log("Nil item "..name) end
		if item.stack_size == nil then log("Nil stack "..name) end
		if item ~= nil then
			local_create_fish_conversion(item)
		end
	end
end