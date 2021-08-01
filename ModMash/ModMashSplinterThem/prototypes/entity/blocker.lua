require ("prototypes.scripts.defines")
data:extend(
{
    {
		type = "item",
		name = "them-blocker",
        icon = "__modmashsplinterthem__/graphics/icons/blocker-icon.png",
        icon_size = 64, icon_mipmaps = 4,
		subgroup = "defensive-structure",		    
		order = "d[radar]-z[them-blocker]",
		place_result = "them-blocker",
		stack_size = 50,
    },
    {
        type = "radar",
        name = "them-blocker",
        icon = "__modmashsplinterthem__/graphics/icons/blocker-icon.png",
        icon_mipmaps = 4,
        icon_size = 64,
        flags = {"placeable-neutral", "player-creation", "filter-directions"},
        minable = {mining_time = 4, result = "them-blocker"},
        energy_per_nearby_scan = "1kJ",
        energy_per_sector = "1kJ",
        energy_source =
		{
		    type = "burner",
		    fuel_category = "alien-fuel",
		    effectivity = 1,
		    fuel_inventory_size = 1,
		    emissions_per_minute = 12
		},
        energy_usage = "266kW",
        max_distance_of_nearby_sector_revealed = 0,
        max_distance_of_sector_revealed = 0,
        max_health = 200,
        {
          {
            type = "fire",
            percent = 90
          },
          {
            type = "impact",
            percent = 60
          }
        },
        collision_box = {{-1.5, -1.5}, {1.5, 1.5}},
        selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
        vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
        pictures = {
            layers = {
                {
                    apply_projection = false,
                    direction_count = 1,
                    filename = "__modmashsplinterthem__/graphics/entity/blocker/them-blocker.png",
                    priority = "high",
                    shift = util.by_pixel(12, 0),
                    width = 130,
                    height = 103,
                    hr_version =
                    {
                        apply_projection = false,
                        direction_count = 1,
                        filename = "__modmashsplinterthem__/graphics/entity/blocker/hr-them-blocker.png",
                        priority = "high",
                        width = 260,
                        height = 206,
                        shift = util.by_pixel(24, 0),
                        scale = 0.5
                    }
                }
	        }
        }
    },
    --[[{
        type = "simple-entity",
        name = "them-blocker",
        icon = "__modmashsplinterthem__/graphics/icons/blocker-icon.png",
        icon_mipmaps = 4,
        icon_size = 64,
        flags = {"placeable-neutral", "player-creation", "filter-directions"},
        minable = {mining_time = 4, result = "them-blocker"},
        max_health = 200,
        {
          {
            type = "fire",
            percent = 90
          },
          {
            type = "impact",
            percent = 60
          }
        },
        collision_box = {{-1.5, -1.5}, {1.5, 1.5}},
        selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
        vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
        picture = {
            filename = "__modmashsplinterthem__/graphics/entity/blocker/them-blocker.png",
            priority = "high",
            shift = util.by_pixel(12, 0),
            width = 130,
            height = 103,
            hr_version =
            {
                filename = "__modmashsplinterthem__/graphics/entity/blocker/hr-them-blocker.png",
                priority = "high",
                width = 260,
                height = 206,
                shift = util.by_pixel(24, 0),
                scale = 0.5
            }
	    }
    },]]
    {
        type = "technology",
        name = "them-blocker",
        icon = "__modmashsplinterthem__/graphics/technology/them.png",
        icon_size = 128,
        effects =
        {
            {
            type = "unlock-recipe",
            recipe = "them-blocker"
            }
        },
        prerequisites = {"space-science-pack"},
        unit =
        {
            ingredients =
            {
            {"automation-science-pack", 1},
	        {"logistic-science-pack", 1},
            {"chemical-science-pack", 1},
            {"military-science-pack", 1},
            {"space-science-pack", 1},
            },
            time = 60,
            count = 4000
        },
        order = "a-h-d"
    },  
    -- recipe
    {
        type = "recipe",
        name = "them-blocker",
        category = "crafting-with-fluid",
        enabled = false,
        energy_required = 50,
        ingredients =
        {
            {"radar", 2},
	        {"them-matter-cube", 50},
        },
        result = "them-blocker"
    }
})