require ("prototypes.scripts.defines")
local speed = 0.125
local hide_from_player_crafting = true
local minable_transport_belt = nil
local minable_underground_belt_structure = nil
local minable_mini_loader_structure = nil
local healing_per_tick = modmashsplinterthem.healing_per_tick
local placeable = "placeable-enemy"
local resistances = modmashsplinterthem.resistances


if modmashsplinterthem.debug == true then
	placeable = "placeable-player"
    hide_from_player_crafting = false
    minable_transport_belt = {mining_time = 0.1, result = "them-transport-belt"}
    minable_underground_belt_structure = {mining_time = 0.1, result = "them-underground-belt-structure"}
    minable_mini_loader_structure = {mining_time = 0.1, result = "them-mini-loader-structure"}
end

local local_create_belt_animation_set = function()
	local belt_animation_set = 
	{
		animation_set =
		{			
			filename = "__modmashsplinterthem__/graphics/entity/logistics/transport-belt.png",
			priority = "extra-high",
			width = 64,
			height = 64,
			frame_count = 16,
			direction_count = 20,
			hr_version =
			{
				filename = "__modmashsplinterthem__/graphics/entity/logistics/hr-transport-belt.png",
				priority = "extra-high",
				width = 128,
				height = 128,
				scale = 0.5,
				frame_count = 16,
				direction_count = 20
			}			
		},
  
		east_index = 1,
		west_index = 2,
		north_index = 3,
		south_index = 4,
  
		east_to_north_index = 5,
		north_to_east_index = 6,
  
		west_to_north_index = 7,
		north_to_west_index = 8,
  
		south_to_east_index = 9,
		east_to_south_index = 10,
  
		south_to_west_index = 11,
		west_to_south_index = 12,
 
		starting_south_index = 13,
		ending_south_index = 14,
  
		starting_west_index = 15,
		ending_west_index = 16,
  
		starting_north_index = 17,
		ending_north_index = 18,
  
		starting_east_index = 19,
		ending_east_index = 20,
	}	
	return belt_animation_set end

data:extend(
{
    {
		type = "item",
		name = "them-transport-belt",
        icon = "__modmashsplinter__/graphics/icons/bad-icon.png",
        icon_size = 64, icon_mipmaps = 4,
		subgroup = "them",		    
		order = "them-transport-belt",
		place_result = "them-transport-belt",
		stack_size = 50,
        hide_from_player_crafting = hide_from_player_crafting
    },
    {
		type = "item",
		name = "them-underground-belt-structure",
        icon = "__modmashsplinter__/graphics/icons/bad-icon.png",
        icon_size = 64, icon_mipmaps = 4,
		subgroup = "them",		    
		order = "them-underground-belt-structure",
		place_result = "them-underground-belt-structure",
		stack_size = 50,
        hide_from_player_crafting = hide_from_player_crafting
    },
    {
		type = "item",
		name = "them-mini-loader-structure",
        icon = "__modmashsplinter__/graphics/icons/bad-icon.png",
        icon_size = 64, icon_mipmaps = 4,
		subgroup = "them",		    
		order = "them-mini-loader-structure",
		place_result = "them-mini-loader-structure",
		stack_size = 50,
        hide_from_player_crafting = hide_from_player_crafting
    },
	{
		type = "loader-1x1",
		name = "them-mini-loader-structure",
		icon = "__modmashsplinter__/graphics/icons/bad-icon.png",
        icon_size = 64, icon_mipmaps = 4, 
		flags = {placeable,"placeable-enemy", "player-creation"},
        minable = minable_mini_loader_structure,
        map_color = {r=1.0, g=0.0, b=0.5},
		max_health = 50,
		filter_count = 1,
		healing_per_tick = healing_per_tick,
		corpse = "small-remnants",
		resistances = resistances,
		collision_box =  {{-0.3, -0.3}, {0.3, 0.3}},
		selection_box = {{-0.75, -0.75}, {0.75, 0.75}},
		animation_speed_coefficient = 32,
		belt_animation_set = local_create_belt_animation_set(),
		--fast_replaceable_group = "transport-belt",
		speed = speed,
		belt_distance = 0.1,
		container_distance = 1,
		structure_render_layer = "lower-object",
		structure =
		{
		  direction_in =
		  {
			sheet =
			{
			  filename = "__modmashsplinterthem__/graphics/entity/logistics/mini-loader-structure.png",
			  priority = "extra-high",
			  width    = 53,
			  height   = 43,
			  shift = {0.15625, 0.0703125},
			  y = 43,
			  hr_version =
				{
				  filename = "__modmashsplinterthem__/graphics/entity/logistics/hr-mini-loader-structure.png",
				  priority = "extra-high",
				  shift = {0.15625, 0.0703125},
				  width = 106,
				  height = 85,
				  y = 85,
				  scale = 0.5
				}
			}
		  },
		  direction_out =
		  {
			sheet =
			{
			  filename = "__modmashsplinterthem__/graphics/entity/logistics/mini-loader-structure.png",
			  priority = "extra-high",
			  width    = 53,
			  height   = 43,
			  shift = {0.15625, 0.0703125},
			  priority = "extra-high",
			  hr_version =
				{
				  filename = "__modmashsplinterthem__/graphics/entity/logistics/hr-mini-loader-structure.png",
				  priority = "extra-high",
				  shift = {0.15625, 0.0703125},				  
				  width = 106,
				  height = 85,
				  scale = 0.5
				}
			}
		  }
		}
	},
	{
		type = "transport-belt",
		name = "them-transport-belt",
		icon = "__modmashsplinter__/graphics/icons/bad-icon.png",
        icon_size = 64, icon_mipmaps = 4,
		flags = {placeable,"placeable-enemy", "player-creation"},
		minable = minable_transport_belt,
		healing_per_tick = healing_per_tick,
		map_color = {r=1.0, g=0.0, b=0.5},
		max_health = 50,
		corpse = "small-remnants",
		resistances = resistances,
		collision_box = {{-0.4, -0.4}, {0.4, 0.4}},
		selection_box = {{-0.8, -0.8}, {0.8, 0.8}},
		working_sound =
		{
			sound =
			{
			filename = "__base__/sound/transport-belt.ogg",
			volume = 0.4
			},
			persistent = true
		},
		animation_speed_coefficient = 32,
		belt_animation_set = local_create_belt_animation_set(),
		fast_replaceable_group = "transport-belt",
		speed = speed,
		connector_frame_sprites = transport_belt_connector_frame_sprites,
		circuit_wire_connection_points = circuit_connector_definitions["belt"].points,
		circuit_connector_sprites = circuit_connector_definitions["belt"].sprites,
		circuit_wire_max_distance = transport_belt_circuit_wire_max_distance
	},
	{
		type = "underground-belt",
		name = "them-underground-belt-structure",
		icon = "__modmashsplinter__/graphics/icons/bad-icon.png",
        icon_size = 64, icon_mipmaps = 4, 
		flags = {placeable,"placeable-enemy", "player-creation"},
		minable = minable_underground_belt_structure,
		map_color = {r=1.0, g=0.0, b=0.5},
		max_health = 50,
		healing_per_tick = healing_per_tick,
		corpse = "small-remnants",
		max_distance = 20,
		underground_sprite =
		{
		  filename = "__core__/graphics/arrows/underground-lines.png",
		  priority = "high",
		  width = 64,
		  height = 64,
		  x = 64,
		  scale = 0.5
		},
		underground_remove_belts_sprite =
		{
		  filename = "__core__/graphics/arrows/underground-lines-remove.png",
		  priority = "high",
		  width = 64,
		  height = 64,
		  x = 64,
		  scale = 0.5
		},
		resistances = resistances,
		collision_box = {{-0.4, -0.4}, {0.4, 0.4}},
		selection_box = {{-0.8, -0.8}, {0.8, 0.8}},
		animation_speed_coefficient = 32,
		belt_animation_set = local_create_belt_animation_set(),
		--fast_replaceable_group = "transport-belt",
		speed = speed,
		structure =
		{
		  direction_in =
		  {
			sheet =
			{
			  filename = "__modmashsplinterthem__/graphics/entity/logistics/underground-belt-structure.png",
			  priority = "extra-high",
			  width = 96,
			  height = 96,
			  y = 96,
			  hr_version =
			  {
				filename = "__modmashsplinterthem__/graphics/entity/logistics/hr-underground-belt-structure.png",
				priority = "extra-high",
				width = 192,
				height =192,
				y = 192,
				scale = 0.5
			  }
			}
		  },
		  direction_out =
		  {
			sheet =
			{
			  filename = "__modmashsplinterthem__/graphics/entity/logistics/underground-belt-structure.png",
			  priority = "extra-high",
			  width = 96,
			  height = 96,
			  hr_version =
			  {
				filename = "__modmashsplinterthem__/graphics/entity/logistics/hr-underground-belt-structure.png",
				priority = "extra-high",
				width = 192,
				height = 192,
				scale = 0.5
			  }
			}
		  },
		  direction_in_side_loading =
		  {
			sheet =
			{
			  filename = "__modmashsplinterthem__/graphics/entity/logistics/underground-belt-structure.png",
			  priority = "extra-high",
			  width = 96,
			  height = 96,
			  y = 96*3,
			  hr_version =
			  {
				filename = "__modmashsplinterthem__/graphics/entity/logistics/hr-underground-belt-structure.png",
				priority = "extra-high",
				width = 192,
				height = 192,
				y = 192*3,
				scale = 0.5
			  }
			}
		  },
		  direction_out_side_loading =
		  {
			sheet =
			{
			  filename = "__modmashsplinterthem__/graphics/entity/logistics/underground-belt-structure.png",
			  priority = "extra-high",
			  width = 96,
			  height = 96,
			  y = 96*2,
			  hr_version =
			  {
				filename = "__modmashsplinterthem__/graphics/entity/logistics/hr-underground-belt-structure.png",
				priority = "extra-high",
				width = 192,
				height = 192,
				y= 192*2,
				scale = 0.5
			  },
			}
		  },
		  back_patch =
		  {
			sheet =
			{
			  filename = "__base__/graphics/entity/underground-belt/underground-belt-structure-back-patch.png",
			  priority = "extra-high",
			  width = 96,
			  height = 96,
			  hr_version =
			  {
				filename = "__base__/graphics/entity/underground-belt/hr-underground-belt-structure-back-patch.png",
				priority = "extra-high",
				width = 192,
				height = 192,
				scale = 0.5
			  }
			}
		  },
		  front_patch =
		  {
			sheet =
			{
			  filename = "__base__/graphics/entity/underground-belt/underground-belt-structure-front-patch.png",
			  priority = "extra-high",
			  width = 96,
			  height = 96,
			  hr_version =
			  {
				filename = "__base__/graphics/entity/underground-belt/hr-underground-belt-structure-front-patch.png",
				priority = "extra-high",
				width = 192,
				height = 192,
				scale = 0.5
			  }
			}
		  }
		}
	}
})
if modmashsplinterthem.debug == true then
    data:extend(
    {
        {
            type = "recipe",
            name = "them-transport-belt",
            ingredients = {{name = "stone", amount = 1}},
            result = "them-transport-belt",
            enabled = true
	    },
        {
            type = "recipe",
            name = "them-underground-belt-structure",
            ingredients = {{name = "stone", amount = 1}},
            result = "them-underground-belt-structure",
            enabled = true
	    },
        {
            type = "recipe",
            name = "them-mini-loader-structure",
            ingredients = {{name = "stone", amount = 1}},
            result = "them-mini-loader-structure",
            enabled = true
	    }
	})
end