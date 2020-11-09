local local_create_biome_recipies = function()
	local create_recipe_for_biome = function(name, factor)
		local smooth = 25
		return {
			type = "recipe",        
			name = modmashsplinterairpurifier.defines.names.air_purifier_action_prefix .. name,
			icon = "__modmashsplinter__/graphics/icons/blank.png",
			icon_mipmaps = 4,
			icon_size = 64,
			energy_required = 1/smooth,
			enabled = true,
			category = modmashsplinterairpurifier.defines.names.air_purifier,
			ingredients = {},
			results = modmashsplinterairpurifier.util.get_item_ingredient_substitutions({"sludge"},
			{ 
				{type = "fluid", name = "water", amount = math.floor(100/smooth*factor+0.5)},
				{type = "fluid", name = "sludge", amount = math.floor(100/smooth*(1.5-factor)+0.5)}
			}),
			hidden = true,
			subgroup = "other"
		}
    end  
	data:extend({create_recipe_for_biome("hi", 1.25)})
	data:extend({create_recipe_for_biome("medium", 0.75)})
	data:extend({create_recipe_for_biome("low", 0.25)})
	 
end

if data ~= nil and data_final_fixes == true then
    local_create_biome_recipies()
end