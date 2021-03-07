require ("prototypes.scripts.defines")
local hide_from_player_crafting = true

if modmashsplinterthem.debug == true then
    hide_from_player_crafting = false
end

data:extend({
		{
		type = "item",
		name = "them-matter-cube",
        icon = "__modmashsplinterthem__/graphics/icons/matter-cube.png",
        icon_size = 64, icon_mipmaps = 4,
		subgroup = "them",		    
		order = "them-matter-cube",
		stack_size = 50,
        fuel_category = "chemical",
		fuel_value = "8MJ",
		fuel_acceleration_multiplier = 2.8,
		fuel_top_speed_multiplier = 1.25,

        hide_from_player_crafting = hide_from_player_crafting
    }
})

if modmashsplinterthem.debug == true then
    data:extend(
    {
        {
            type = "recipe",
            name = "them-matter-cube",
            ingredients = {{name = "stone", amount = 1}},
            result = "them-matter-cube",
            enabled = true
	    }
	})
end