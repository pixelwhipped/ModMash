local local_create_biome_recipies = function()
	local create_recipe_for_biome = function(name, w,s)
		return {
			type = "recipe",        
			name = modmashsplinterairpurifier.defines.names.air_purifier_action_prefix .. name,
			icon = "__modmashsplinter__/graphics/icons/blank.png",
			icon_mipmaps = 4,
			icon_size = 64,
			energy_required = 0.3,
			enabled = true,
			category = modmashsplinterairpurifier.defines.names.air_purifier,
			ingredients = {},
			results = modmashsplinterairpurifier.util.get_item_ingredient_substitutions({"sludge"},
			{ 
				{type = "fluid", name = "water", amount = w},
				{type = "fluid", name = "sludge", amount = s}
			}),
			hidden = true,
			subgroup = "other"
		}
    end  
	data:extend({create_recipe_for_biome("hi", 15,10)})
	data:extend({create_recipe_for_biome("medium", 10,6)})
	data:extend({create_recipe_for_biome("low", 6,4)})
	 
end

if data ~= nil and data_final_fixes == true then
    local_create_biome_recipies()
end