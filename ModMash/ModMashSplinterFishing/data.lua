require ("prototypes.scripts.defines")
require ("prototypes.categories.fisheries")
require ("prototypes.categories.groups")
local allow_fishing = modmashsplinterfishing.defines.names.allow_fishing
local get_name_for = modmashsplinterfishing.util.get_name_for

data:extend(
{
	{
		type = "item",
		name = "nursery",
		icon = "__modmashsplinterfishing__/graphics/icons/nursery.png",
		icon_size = 64,
		icon_mipmaps = 4,
		subgroup = "production-machine",
		order = "h[d][nursery]",
		place_result = "nursery",
		stack_size = 50
	},
	{
		type = "recipe",
		name = "nursery",
		energy_required = 1.5,
		enabled = false,
		normal =
		{
			enabled = false,
			ingredients = modmashsplinterassembling.util.get_item_ingredient_substitutions({"glass"},
			{
				{"assembling-machine-2", 1},
				{"pipe", 10},
				{"glass", 4},
			}),
			result = "nursery"
		},
		expensive =
		{
			enabled = false,
			ingredients = modmashsplinterassembling.util.get_item_ingredient_substitutions({"glass"},
			{
				{"assembling-machine-2", 1},
				{"pipe", 20},
				{"glass", 6},
			}),
			result = "nursery"
		},
		icon = false,
		icon = "__modmashsplinterfishing__/graphics/icons/nursery.png",
		icon_size = 64,
		icon_mipmaps = 4,
		subgroup = "production-machine",
		order = "h[d][nursery]",
		allow_decomposition = false,
	},
	{
		type = "assembling-machine",
		name = "nursery",
		icon = "__modmashsplinterfishing__/graphics/icons/nursery.png",
		icon_size = 64,
        icon_mipmaps = 4,        
		flags = {"placeable-neutral", "placeable-player", "player-creation"},
		minable = {mining_time = 0.2, result = "nursery"},
		max_health = 100,
		corpse = "big-remnants",
		dying_explosion = "medium-explosion",
		resistances =
		{
		    {
				type = "fire",
				percent = 70
		    }
		},
		collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
        selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
		alert_icon_shift = {
                -0.09375,
                -0.375
                },
        scale_entity_info_icon = true,
		fluid_boxes =
        {
            {
				production_type = "input",
				pipe_picture = assembler2pipepictures(),
				pipe_covers = pipecoverspictures(),
				base_area = 10,
				base_level = -1,
				pipe_connections = {{ type="input", position = {0, -2} }}
			},
			{
                production_type = "output",
                pipe_picture = assembler2pipepictures(),
                pipe_covers = pipecoverspictures(),
                base_area = 10,
                base_level = 1,
                pipe_connections = {{ type="output", position = {0, 2} }}
            },
            off_when_no_fluid_recipe = true
        },
		animation =
		{
			north =
			{
				filename = "__modmashsplinterfishing__/graphics/entity/nursery/nurseryva.png",
				width = 107,
				height = 113,
				frame_count = 4,
				animation_speed = 0.5,
				hr_version =
				{
					filename = "__modmashsplinterfishing__/graphics/entity/nursery/hr-nurseryva.png",
					priority="high",
					width = 214,
					height = 226,
					frame_count = 4,
					animation_speed = 0.5,
					scale = 0.5
			    }
			},
			east =
			{
				filename = "__modmashsplinterfishing__/graphics/entity/nursery/nurseryh.png",
				width = 107,
				height = 113,
				frame_count = 1,
				--animation_speed = 0.5,
				hr_version =
				{
					filename = "__modmashsplinterfishing__/graphics/entity/nursery/hr-nurseryh.png",
					priority="high",
					width = 214,
					height = 226,
					frame_count = 1,
					scale = 0.5
			    }
			},
			south =
			{
				filename = "__modmashsplinterfishing__/graphics/entity/nursery/nurseryv.png",
				width = 107,
				height = 113,
				frame_count = 1,
				--animation_speed = 0.5,
				hr_version =
				{
					filename = "__modmashsplinterfishing__/graphics/entity/nursery/hr-nurseryv.png",
					priority="high",
					width = 214,
					height = 226,
					frame_count = 1,
					scale = 0.5
			    }
			},
			west =
			{
				filename = "__modmashsplinterfishing__/graphics/entity/nursery/nurseryh.png",
				width = 107,
				height = 113,
				frame_count = 1,
				--animation_speed = 0.5,
				hr_version =
				{
					filename = "__modmashsplinterfishing__/graphics/entity/nursery/hr-nurseryh.png",
					priority="high",
					width = 214,
					height = 226,
					frame_count = 1,
					scale = 0.5
			    }
			}
		},
		crafting_categories = {"fisheries"},
		crafting_speed = 1,
		energy_source =
        {
            type = "electric",
            usage_priority = "secondary-input",
            emissions_per_minute  = 2
        },
		energy_usage = "75kW",
		open_sound = { filename = "__base__/sound/machine-open.ogg", volume = 0.85 },
		close_sound = { filename = "__base__/sound/machine-close.ogg", volume = 0.75 },
		vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
		working_sound =
		{
		    sound =
		    {
			{
			    filename = "__base__/sound/assembling-machine-t1-1.ogg",
			    volume = 0.8
			},
			{
			    filename = "__base__/sound/assembling-machine-t1-2.ogg",
			    volume = 0.8
			}
		    },
		    idle_sound = { filename = "__base__/sound/idle1.ogg", volume = 0.6 },
		    apparent_volume = 1.5
		},
		ingredient_count = 2,
        module_specification =
        {
            module_slots = 1,
            module_info_icon_shift = {0, 0},
            module_info_multi_row_initial_height_modifier = -0.3
        },
        allowed_effects = {"consumption", "productivity", "pollution"},
	},
	{
		type = "item",
		name = "fishfood",
		icon = "__modmashsplinterfishing__/graphics/icons/fishfood.png",
		icon_size = 64,
		icon_mipmaps = 4,
		subgroup = "fisheries",
		order = "h[a]",
		stack_size = 100
	},
	{
		type = "item",
		name = "roe",
		icon = "__modmashsplinterfishing__/graphics/icons/roe.png",
		icon_size = 64,
		icon_mipmaps = 4,
		subgroup = "fisheries",
		order = "d[a]",
		stack_size = 50
	},
	{
		type = "recipe",
		name = "fishfood",
		energy_required = 1.5,
		enabled = false,
		category = "crafting-with-fluid",
		ingredients = {{"alien-ore", 4},{type="fluid", name="sludge", amount=50}},
		icon = false,
		icon = "__modmashsplinterfishing__/graphics/icons/fishfood.png",
		icon_size = 64,
		icon_mipmaps = 4,
		subgroup = "fisheries",
		order = "c[fishfood]",
		main_product = "",
		results =
		{
			{name="fishfood", amount=10},     
		},
		allow_decomposition = false,
	},
	{
		type = "recipe",
		name = "roe",
		energy_required = 1.5,
		enabled = false,
		category = "crafting-with-fluid",
		ingredients = {{"alien-ore", 5},{"alien-artifact", 2},{"fishfood", 10}},
		icon = false,
		icon = "__modmashsplinterfishing__/graphics/icons/roe.png",
		icon_size = 64,
		icon_mipmaps = 4,
		subgroup = "fisheries",
		order = "c[roe]",
		main_product = "",
		results =
		{
			{name="roe", amount=25},     
		},
		allow_decomposition = false,
	},
	{
		type = "technology",
		name = "fisheries",
		icon = "__modmashsplinterresources__/graphics/technology/fish.png",
		icon_size = 128,
		effects =
		{
			{
			type = "unlock-recipe",
			recipe = "fishfood"
			},{
			type = "unlock-recipe",
			recipe = "roe"
			},{
			type = "unlock-recipe",
			recipe = "nursery"
			}
		},
		prerequisites =
		{
			"fish1"
		},
		unit =
		{
			count = 75,
			ingredients =
			{
			{"automation-science-pack", 1},
			{"logistic-science-pack", 1},
			},
			time = 35
		},
		upgrade = true,
		order = "a-b-d",
	},{
		type = "technology",
		name = allow_fishing,
		icon = "__modmashsplinterresources__/graphics/technology/fish.png",
		icon_size = 128,
		effects =
		{
		},
		prerequisites =
		{
			"fish1"
		},
		unit =
		{
			count = 75,
			ingredients =
			{
			{"automation-science-pack", 1},
			{"logistic-science-pack", 1},
			},
			time = 35
		},
		upgrade = true,
		order = "a-b-d",
	}
})