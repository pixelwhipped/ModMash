--if not modmash or not modmash.util then require("prototypes.scripts.util") end
require("prototypes.scripts.defines") 
local underground_accumulator  = modmash.defines.names.underground_accumulator
local underground_access  = modmash.defines.names.underground_access
local underground_access2  = modmash.defines.names.underground_access2

local local_get_alien_particle_shadow_pictures = function()
	return
	{
	{
		filename = "__modmashgraphics__/graphics/entity/alien-ore/alien-ore-particle-shadow-1.png",
		priority = "extra-high",
		width = 16,
		height = 16,
		frame_count = 1,
		hr_version =
		{
		filename = "__modmashgraphics__/graphics/entity/alien-ore/hr-alien-ore-particle-shadow-1.png",
		priority = "extra-high",
		width = 32,
		height = 32,
		frame_count = 1,
		scale = 0.5
		}
	},
	{
		filename = "__modmashgraphics__/graphics/entity/alien-ore/alien-ore-particle-shadow-2.png",
		priority = "extra-high",
		width = 16,
		height = 16,
		frame_count = 1,
		hr_version =
		{
		filename = "__modmashgraphics__/graphics/entity/alien-ore/hr-alien-ore-particle-shadow-2.png",
		priority = "extra-high",
		width = 32,
		height = 32,
		frame_count = 1,
		scale = 0.5
		}
	},
	{
		filename = "__modmashgraphics__/graphics/entity/alien-ore/alien-ore-particle-shadow-3.png",
		priority = "extra-high",
		width = 16,
		height = 16,
		frame_count = 1,
		hr_version =
		{
		filename = "__modmashgraphics__/graphics/entity/alien-ore/hr-alien-ore-particle-shadow-3.png",
		priority = "extra-high",
		width = 32,
		height = 32,
		frame_count = 1,
		scale = 0.5
		}
	},
	{
		filename = "__modmashgraphics__/graphics/entity/alien-ore/alien-ore-particle-shadow-4.png",
		priority = "extra-high",
		width = 16,
		height = 16,
		frame_count = 1,
		hr_version =
		{
		filename = "__modmashgraphics__/graphics/entity/alien-ore/hr-alien-ore-particle-shadow-4.png",
		priority = "extra-high",
		width = 32,
		height = 32,
		frame_count = 1,
		scale = 0.5
		}
	}
	}
	end
local local_get_alien_particle_pictures = function()
	return
	{
		{
		  filename = "__modmashgraphics__/graphics/entity/alien-ore/alien-ore-particle-1.png",
		  priority = "extra-high",
		  width = 16,
		  height = 16,
		  frame_count = 1,
		  hr_version =
		  {
			filename = "__modmashgraphics__/graphics/entity/alien-ore/hr-alien-ore-particle-1.png",
			priority = "extra-high",
			width = 32,
			height = 32,
			frame_count = 1,
			scale = 0.5
		  }
		},
		{
		  filename = "__modmashgraphics__/graphics/entity/alien-ore/alien-ore-particle-2.png",
		  priority = "extra-high",
		  width = 16,
		  height = 16,
		  frame_count = 1,
		  hr_version =
		  {
			filename = "__modmashgraphics__/graphics/entity/alien-ore/hr-alien-ore-particle-2.png",
			priority = "extra-high",
			width = 32,
			height = 32,
			frame_count = 1,
			scale = 0.5
		  }
		},
		{
		  filename = "__modmashgraphics__/graphics/entity/alien-ore/alien-ore-particle-3.png",
		  priority = "extra-high",
		  width = 16,
		  height = 16,
		  frame_count = 1,
		  hr_version =
		  {
			filename = "__modmashgraphics__/graphics/entity/alien-ore/hr-alien-ore-particle-3.png",
			priority = "extra-high",
			width = 32,
			height = 32,
			frame_count = 1,
			scale = 0.5
		  }
		},
		{
		  filename = "__modmashgraphics__/graphics/entity/alien-ore/alien-ore-particle-4.png",
		  priority = "extra-high",
		  width = 16,
		  height = 16,
		  frame_count = 1,
		  hr_version =
		  {
			filename = "__modmashgraphics__/graphics/entity/alien-ore/hr-alien-ore-particle-4.png",
			priority = "extra-high",
			width = 32,
			height = 32,
			frame_count = 1,
			scale = 0.5
		  }
		}
    }
	end

local local_make_particle = function()
	return
	{
		{
			type = "optimized-particle",
			name = "alien-ore-particle",
			life_time = 180,
			render_layer = "projectile",
			 render_layer_when_on_ground =  "corpse",
			regular_trigger_effect_frequency = 2,
			pictures = local_get_alien_particle_pictures(),
			shadows = local_get_alien_particle_shadow_pictures()
		}
	}
	end

data:extend(local_make_particle())

function underground_accumulator_picture(tint, repeat_count)
  return
  {
    layers =
    {
      {
        filename = "__modmashgraphics__/graphics/entity/underground/accumulator.png",
        priority = "high",
        width = 33,
        height = 94,
        shift = util.by_pixel(0, -10),
        animation_speed = 0.5,
		repeat_count = repeat_count,
        tint = tint,
        hr_version =
        {
          filename = "__modmashgraphics__/graphics/entity/underground/hr-accumulator.png",
          priority = "high",
          width = 75,
          height = 189,
          shift = util.by_pixel(0, -11),
          animation_speed = 0.5,
          scale = 0.5,
		  repeat_count = repeat_count,
          tint = tint
        }
      },
      {
        filename = "__modmashgraphics__/graphics/entity/underground/accumulator-shadow.png",
        priority = "high",
        width = 120,
        height = 27,
        repeat_count = repeat_count,
        shift = util.by_pixel(49, 12),
        draw_as_shadow = true,
		repeat_count = repeat_count,
        hr_version =
        {
          filename = "__modmashgraphics__/graphics/entity/underground/hr-accumulator-shadow.png",
          priority = "high",
          width = 234,
          height = 53,
          repeat_count = repeat_count,
          shift = util.by_pixel(49, 12),
          draw_as_shadow = true,
		  repeat_count = repeat_count,
          scale = 0.5
        }
      }
    }
  }
end

function underground_battery_picture(tint, repeat_count)
  return
  {
    layers =
    {
      {
        filename = "__modmashgraphics__/graphics/entity/underground/battery-cell.png",
        priority = "high",
        width = 33,
        height = 94,
        shift = util.by_pixel(0, -10),
        animation_speed = 0.5,
		repeat_count = repeat_count,
        tint = tint,
        hr_version =
        {
          filename = "__modmashgraphics__/graphics/entity/underground/hr-battery-cell.png",
          priority = "high",
          width = 75,
          height = 189,
          shift = util.by_pixel(0, -11),
          animation_speed = 0.5,
          scale = 0.5,
		  repeat_count = repeat_count,
          tint = tint
        }
      },
      {
        filename = "__modmashgraphics__/graphics/entity/underground/accumulator-shadow.png",
        priority = "high",
        width = 120,
        height = 27,
        repeat_count = repeat_count,
        shift = util.by_pixel(49, 12),
        draw_as_shadow = true,
		repeat_count = repeat_count,
        hr_version =
        {
          filename = "__modmashgraphics__/graphics/entity/underground/hr-accumulator-shadow.png",
          priority = "high",
          width = 234,
          height = 53,
          repeat_count = repeat_count,
          shift = util.by_pixel(49, 12),
          draw_as_shadow = true,
		  repeat_count = repeat_count,
          scale = 0.5
        }
      }
    }
  }
end

function underground_used_battery_picture(tint, repeat_count)
  return
  {
    layers =
    {
      {
        filename = "__modmashgraphics__/graphics/entity/underground/used-battery-cell.png",
        priority = "high",
        width = 33,
        height = 94,
        shift = util.by_pixel(0, -10),
        animation_speed = 0.5,
		repeat_count = repeat_count,
        tint = tint,
        hr_version =
        {
          filename = "__modmashgraphics__/graphics/entity/underground/hr-used-battery-cell.png",
          priority = "high",
          width = 75,
          height = 189,
          shift = util.by_pixel(0, -11),
          animation_speed = 0.5,
          scale = 0.5,
		  repeat_count = repeat_count,
          tint = tint
        }
      },
      {
        filename = "__modmashgraphics__/graphics/entity/underground/accumulator-shadow.png",
        priority = "high",
        width = 120,
        height = 27,
        repeat_count = repeat_count,
        shift = util.by_pixel(49, 12),
        draw_as_shadow = true,
		repeat_count = repeat_count,
        hr_version =
        {
          filename = "__modmashgraphics__/graphics/entity/underground/hr-accumulator-shadow.png",
          priority = "high",
          width = 234,
          height = 53,
          repeat_count = repeat_count,
          shift = util.by_pixel(49, 12),
          draw_as_shadow = true,
		  repeat_count = repeat_count,
          scale = 0.5
        }
      }
    }
  }
end

function underground_accumulator_charge()
  return
  {
    layers =
    {
      underground_accumulator_picture({ r=1, g=1, b=1, a=1 } , 24),
      {
        filename = "__modmashgraphics__/graphics/entity/underground/accumulator-charge.png",
        width = 45,
        height = 100,
        line_length = 6,
        frame_count = 24,
        blend_mode = "additive",
        shift = util.by_pixel(0, -22),
        hr_version =
        {
          filename = "__modmashgraphics__/graphics/entity/underground/hr-accumulator-charge.png",
          width = 89,
          height = 206,
          line_length = 6,
          frame_count = 24,
          blend_mode = "additive",
          shift = util.by_pixel(0, -22),
          scale = 0.5
        }
      }
    }
  }
end

function underground_accumulator_discharge()
  return
  {
    layers =
    {
      underground_accumulator_picture({ r=1, g=1, b=1, a=1 } , 24),
      {
        filename = "__modmashgraphics__/graphics/entity/underground/accumulator-discharge.png",
        width = 44,
        height = 104,
        line_length = 6,
        frame_count = 24,
        blend_mode = "additive",
        shift = util.by_pixel(-2, -22),
        hr_version =
        {
          filename = "__modmashgraphics__/graphics/entity/underground/hr-accumulator-discharge.png",
          width = 85,
          height = 210,
          line_length = 6,
          frame_count = 24,
          blend_mode = "additive",
          shift = util.by_pixel(-1, -23),
          scale = 0.5
        }
      }
    }
  }
end

data:extend(
{
	{		
		type = "container",
		name = underground_access,
		icon = "__modmashgraphics__/graphics/icons/underground-access.png",
		icon_size = 32,
		--fast_replaceable_group = "container",
		flags = {
			"placeable-neutral",
			"player-creation"
		},
		minable = {hardness = 0.2, mining_time = 0.5, result = underground_access},
		max_health = 350,
		corpse = "medium-small-remnants",
		collision_box = {{-0.8, -0.8 }, {0.8, 0.8}},
		selection_box = {{-1, -1 }, {1, 1}},
		--enabled = false,
		resistances =
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
		--fast_replaceable_group = "container",
		--logistic_mode = "passive-provider",
		--C:\Resources\ModMash\base\graphics\entity\gun-turret\gun-turret-base.png or hr-
		inventory_size = 8,
		open_sound = { filename = "__base__/sound/metallic-chest-open.ogg", volume=0.65 },
		close_sound = { filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.7 },
		vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
		picture =
		{
			  filename = "__modmashgraphics__/graphics/entity/underground/access01.png",
			  priority = "high",
			  width = 76,
			  height = 60,
			  axially_symmetrical = false,
			  direction_count = 1,
			  frame_count = 1,
			  shift = util.by_pixel(1, -1),
			  hr_version =
			  {
				filename = "__modmashgraphics__/graphics/entity/underground/hr-access01.png",
				priority = "high",
				width = 150,
				height = 118,
				axially_symmetrical = false,
				direction_count = 1,
				frame_count = 1,
				shift = util.by_pixel(0.5, -1),
				scale = 0.5
			  }
		},
		circuit_wire_connection_point = circuit_connector_definitions["chest"].points,
		circuit_connector_sprites = circuit_connector_definitions["chest"].sprites,
		circuit_wire_max_distance = default_circuit_wire_max_distance,
		allow_copy_paste = true
	},
	{		
		type = "container",
		name = underground_access2,
		icon = "__modmashgraphics__/graphics/icons/underground-access2.png",
		icon_size = 32,
		flags = {"placeable-player", "player-creation"},
		minable = {hardness = 0.2, mining_time = 0.5, result = underground_access2},
		max_health = 350,
		corpse = "medium-small-remnants",
		collision_box = {{-0.8, -0.8 }, {0.8, 0.8}},
		selection_box = {{-1, -1 }, {1, 1}},
		--enabled = false,
		resistances =
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
		inventory_size = 14,
		open_sound = { filename = "__base__/sound/metallic-chest-open.ogg", volume=0.65 },
		close_sound = { filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.7 },
		vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
		picture =
		{
			  filename = "__modmashgraphics__/graphics/entity/underground/access02.png",
			  priority = "high",
			  width = 76,
			  height = 60,
			  axially_symmetrical = false,
			  direction_count = 1,
			  frame_count = 1,
			  shift = util.by_pixel(1, -1),
			  hr_version =
			  {
				filename = "__modmashgraphics__/graphics/entity/underground/hr-access02.png",
				priority = "high",
				width = 150,
				height = 118,
				axially_symmetrical = false,
				direction_count = 1,
				frame_count = 1,
				shift = util.by_pixel(0.5, -1),
				scale = 0.5
			  }
		},
		circuit_wire_connection_point = circuit_connector_definitions["chest"].points,
		circuit_connector_sprites = circuit_connector_definitions["chest"].sprites,
		circuit_wire_max_distance = default_circuit_wire_max_distance,
		allow_copy_paste = true
	},
	{
		type = "accumulator",
		name = underground_accumulator,
		icon = "__modmashgraphics__/graphics/icons/underground-accumulator.png",
		icon_size = 32,
		flags = {"placeable-neutral", "player-creation"},
		minable = {mining_time = 0.1, result = underground_accumulator},
		max_health = 150,
		corpse = "small-remnants",
		dying_explosion = "accumulator-explosion",
		collision_box = {{-0.4, -0.4}, {0.4, 0.4}},
		selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
		drawing_box = {{-5, -1}, {0.5, 0.5}},
		energy_source =
		{
		  type = "electric",
		  buffer_capacity = "10MJ",
		  usage_priority = "tertiary",
		  input_flow_limit = "500kW",
		  output_flow_limit = "500kW"
		},
		picture = underground_accumulator_picture(),
		charge_animation = underground_accumulator_charge(),
		-- water_reflection = accumulator_reflection(),

		charge_cooldown = 30,
		charge_light = {intensity = 0.3, size = 7, color = {r = 1.0, g = 1.0, b = 1.0}},
		discharge_animation = underground_accumulator_discharge(),
		discharge_cooldown = 60, 
		discharge_light = {intensity = 0.7, size = 7, color = {r = 1.0, g = 1.0, b = 1.0}},
		vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
		working_sound =
		{
			sound =
			{
			filename = "__base__/sound/accumulator-working.ogg",
			volume = 1
			},
			idle_sound =
			{
			filename = "__base__/sound/accumulator-idle.ogg",
			volume = 0.5
			},
			--persistent = true,
			max_sounds_per_type = 3,
			fade_in_ticks = 10,
			fade_out_ticks = 30
		},

		circuit_wire_connection_point = circuit_connector_definitions["chest"].points,
		circuit_connector_sprites = circuit_connector_definitions["chest"].sprites,
		circuit_wire_max_distance = default_circuit_wire_max_distance,

		default_output_signal = {type = "virtual", name = "signal-A"}
    },
	{
		type = "resource",
		name = "alien-ore",
		icon = "__modmashgraphics__/graphics/icons/alien-ore.png",
		icon_size = 32,
		flags = {"placeable-neutral"},
		order="a-b-z",
		tree_removal_probability = 0.8,
		tree_removal_max_distance = 32 * 32,
		minable =
		{
		  mining_particle = "alien-ore-particle",
		  mining_time = 1,
		  result = "alien-ore"
		},
		collision_box = {{ -0.1, -0.1}, {0.1, 0.1}},
		selection_box = {{ -0.5, -0.5}, {0.5, 0.5}},
		autoplace = 
		{
			create = false,
			starting_area = false,
			richness = 0.0,
			size = 0.0
		},
		stage_counts = {15000, 9500, 5500, 2900, 1300, 400, 150, 80},
		stages =
		{
		  sheet =
		  {
			filename = "__modmashgraphics__/graphics/entity/alien-ore/alien-ore.png",
			priority = "extra-high",
			size = 64,
			frame_count = 8,
			variation_count = 8,
			hr_version =
			{
			  filename = "__modmashgraphics__/graphics/entity/alien-ore/hr-alien-ore.png",
			  priority = "extra-high",
			  size = 128,
			  frame_count = 8,
			  variation_count = 8,
			  scale = 0.5
			}
		  }
		},
		map_color = {r=1.0, g=0.0, b=0.5}
	},
	{
		type = "accumulator",
		name = "battery-cell",
		icon = "__modmashgraphics__/graphics/icons/battery-cell.png",
		icon_size = 32,
		flags = {"placeable-neutral", "player-creation"},
		minable = {mining_time = 0.1, result = "used-battery-cell"},
		max_health = 150,
		corpse = "small-remnants",
		dying_explosion = "accumulator-explosion",
		collision_box = {{-0.4, -0.4}, {0.4, 0.4}},
		selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
		drawing_box = {{-5, -1}, {0.5, 0.5}},
		energy_source =
		{
		  type = "electric",
		  buffer_capacity = "10MJ",
		  usage_priority = "tertiary",
		  input_flow_limit = "0kW",
		  output_flow_limit = "500kW"
		},
		picture = underground_battery_picture(),
		charge_animation = underground_accumulator_charge(),
		-- water_reflection = accumulator_reflection(),

		charge_cooldown = 30,
		charge_light = {intensity = 0.3, size = 7, color = {r = 1.0, g = 1.0, b = 1.0}},
		discharge_animation = underground_accumulator_discharge(),
		discharge_cooldown = 60, 
		discharge_light = {intensity = 0.7, size = 7, color = {r = 1.0, g = 1.0, b = 1.0}},
		vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
		working_sound =
		{
			sound =
			{
			filename = "__base__/sound/accumulator-working.ogg",
			volume = 1
			},
			idle_sound =
			{
			filename = "__base__/sound/accumulator-idle.ogg",
			volume = 0.5
			},
			--persistent = true,
			max_sounds_per_type = 3,
			fade_in_ticks = 10,
			fade_out_ticks = 30
		},

		circuit_wire_connection_point = circuit_connector_definitions["chest"].points,
		circuit_connector_sprites = circuit_connector_definitions["chest"].sprites,
		circuit_wire_max_distance = default_circuit_wire_max_distance,

		default_output_signal = {type = "virtual", name = "signal-A"}
    },
	{
		type = "accumulator",
		name = "used-battery-cell",
		icon = "__modmashgraphics__/graphics/icons/used-battery-cell.png",
		icon_size = 32,
		flags = {"placeable-neutral", "player-creation"},
		minable = {mining_time = 0.1, result = "used-battery-cell"},
		max_health = 150,
		corpse = "small-remnants",
		dying_explosion = "accumulator-explosion",
		collision_box = {{-0.4, -0.4}, {0.4, 0.4}},
		selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
		drawing_box = {{-5, -1}, {0.5, 0.5}},
		energy_source =
		{
		  type = "electric",
		  buffer_capacity = "0MJ",
		  usage_priority = "tertiary",
		  input_flow_limit = "0kW",
		  output_flow_limit = "0kW"
		},
		picture = underground_used_battery_picture(),
		charge_animation = underground_accumulator_charge(),
		-- water_reflection = accumulator_reflection(),

		charge_cooldown = 30,
		charge_light = {intensity = 0.3, size = 7, color = {r = 1.0, g = 1.0, b = 1.0}},
		discharge_animation = underground_accumulator_discharge(),
		discharge_cooldown = 60, 
		discharge_light = {intensity = 0.7, size = 7, color = {r = 1.0, g = 1.0, b = 1.0}},
		vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
		working_sound =
		{
			sound =
			{
			filename = "__base__/sound/accumulator-working.ogg",
			volume = 1
			},
			idle_sound =
			{
			filename = "__base__/sound/accumulator-idle.ogg",
			volume = 0.5
			},
			--persistent = true,
			max_sounds_per_type = 3,
			fade_in_ticks = 10,
			fade_out_ticks = 30
		},

		circuit_wire_connection_point = circuit_connector_definitions["chest"].points,
		circuit_connector_sprites = circuit_connector_definitions["chest"].sprites,
		circuit_wire_max_distance = default_circuit_wire_max_distance,

		default_output_signal = {type = "virtual", name = "signal-A"}
    }
})

if not data.raw["resource"][modmash.defines.names.titanium_ore_name] then
data:extend(
{
	{
		type = "resource",
		name = modmash.defines.names.titanium_ore_name,
		icon = "__modmashgraphics__/graphics/icons/titanium-ore.png",
		icon_size = 32,
		flags = {"placeable-neutral"},
		order="a-b-z",
		tree_removal_probability = 0.8,
		tree_removal_max_distance = 32 * 32,
		minable =
		{
		  mining_particle = "iron-ore-particle",
		  mining_time = 1.5,
		  result = modmash.defines.names.titanium_ore_name
		},
		collision_box = {{ -0.1, -0.1}, {0.1, 0.1}},
		selection_box = {{ -0.5, -0.5}, {0.5, 0.5}},
		autoplace = 
		{
			create = false,
			starting_area = false,
			richness = 0.0,
			size = 0.0
		},
		stage_counts = {15000, 9500, 5500, 2900, 1300, 400, 150, 80},
		stages =
		{
		  sheet =
		  {
			filename = "__modmashgraphics__/graphics/entity/ores/titanium-ore.png",
			priority = "extra-high",
			size = 64,
			frame_count = 8,
			variation_count = 8,
			hr_version =
			{
			  filename = "__modmashgraphics__/graphics/entity/ores/hr-titanium-ore.png",
			  priority = "extra-high",
			  size = 128,
			  frame_count = 8,
			  variation_count = 8,
			  scale = 0.5
			}
		  }
		},
		map_color = {0.315, 0.425, 0.480}
	}
})
end

if not data.raw["resource"]["sand"] then
data:extend(
{
	{
		type = "resource",
		name = "sand",
		icon = "__modmashgraphics__/graphics/icons/sand.png",
		icon_size = 32,
		flags = {"placeable-neutral"},
		order="a-b-z",
		tree_removal_probability = 0.8,
		tree_removal_max_distance = 32 * 32,
		minable =
		{
		  mining_particle = "stone-particle",
		  mining_time = 0.75,
		  result = "sand"
		},
		collision_box = {{ -0.1, -0.1}, {0.1, 0.1}},
		selection_box = {{ -0.5, -0.5}, {0.5, 0.5}},
		autoplace = 
		{
			create = false,
			starting_area = false,
			richness = 0.0,
			size = 0.0
		},
		stage_counts = {15000, 9500, 5500, 2900, 1300, 400, 150, 80},
		stages =
		{
		  sheet =
		  {
			filename = "__modmashgraphics__/graphics/entity/ores/sand.png",
			priority = "extra-high",
			size = 64,
			frame_count = 8,
			variation_count = 8,
			hr_version =
			{
			  filename = "__modmashgraphics__/graphics/entity/ores/hr-sand.png",
			  priority = "extra-high",
			  size = 128,
			  frame_count = 8,
			  variation_count = 8,
			  scale = 0.5
			}
		  }
		},
		map_color = {r=0.9, g=0.9, b=0.9}
	}
	})
end

if not data.raw["resource"]["sulfur"] then
data:extend(
{
	{
		type = "resource",
		name = "sulfur",
		icon = "__base__/graphics/icons/sulfur.png",
		icon_size = 64, icon_mipmaps = 4,
		flags = {"placeable-neutral"},
		order="a-b-z",
		tree_removal_probability = 0.8,
		tree_removal_max_distance = 32 * 32,
		minable =
		{
		  mining_particle = "stone-particle",
		  mining_time = 1.75,
		  result = "sulfur"
		},
		collision_box = {{ -0.1, -0.1}, {0.1, 0.1}},
		selection_box = {{ -0.5, -0.5}, {0.5, 0.5}},
		autoplace = 
		{
			create = false,
			starting_area = false,
			richness = 0.0,
			size = 0.0
		},
		stage_counts = {15000, 9500, 5500, 2900, 1300, 400, 150, 80},
		stages =
		{
		  sheet =
		  {
			filename = "__modmashgraphics__/graphics/entity/ores/sulfur-ore.png",
			priority = "extra-high",
			size = 64,
			frame_count = 8,
			variation_count = 8,
			hr_version =
			{
			  filename = "__modmashgraphics__/graphics/entity/ores/hr-sulfur-ore.png",
			  priority = "extra-high",
			  size = 128,
			  frame_count = 8,
			  variation_count = 8,
			  scale = 0.5
			}
		  }
		},
		map_color = {r=0.95, g=0.75, b=0.0}
	}
	})
end

local rock_names = {
  "rock-huge",
  "rock-big",
  "sand-rock-big"
}

for k=1, #rock_names do
local r = table.deepcopy(data.raw["simple-entity"][rock_names[k]])
	local desc = modmash.util.get_name_for(r.name)
	r.name = "mm_"..r.name
	r.loot = nil
	r.localised_name = desc
	r.max_health = r.max_health/3
	r.minable =
    {
      mining_particle = "stone-particle",
      mining_time = 0.75,
      results = {{name = "stone", amount_min = 1, amount_max = 8}, {name = "sand", amount_min = 1, amount_max = 5}},
    }
	data:extend({r})
end

for k=1, #rock_names do
local r = table.deepcopy(data.raw["simple-entity"][rock_names[k]])
	local desc = modmash.util.get_name_for(r.name)
	r.name = "mm_dark-"..r.name
	r.loot = nil
	r.localised_name = desc
	r.max_health = r.max_health/3
	r.minable =
    {
      mining_particle = "stone-particle",
      mining_time = 0.75,
      results = {
		{name = "stone", amount_min = 1, amount_max = 8, probability = 0.5}, 
		{name = "sand", amount_min = 1, amount_max = 5, probability = 0.5},
		{name = "alien-ore", amount_min = 0, amount_max = 5, probability = 0.5},
		{name = modmash.defines.names.titanium_ore_name, amount_min = 0, amount_max = 5, probability = 0.5},
		{name = "super-material", amount_min = 0, amount_max = 1, probability = 0.005},
		},
    }
	for j=1, #r.pictures do
		r.pictures[j].tint = {0.25,0.25,0.25,1}
		if r.pictures[j].hr_version then
			r.pictures[j].hr_version.tint = {0.25,0.25,0.25,1}
		end
	end
	data:extend({r})
end

for k=1, 7 do
local t = table.deepcopy(data.raw["tile"]["dirt-"..k])
	t.name = "mm_dark-"..t.name
	if t.autoplace ~= nil then t.autoplace.default_enabled = false end
	t.tint = {0.15,0.15,0.15,1}
	data:extend({t})
end

local digger_biter = table.deepcopy(data.raw["unit"]["small-biter"])
digger_biter.name = "digger-biter"
digger_biter.attack_parameters.ammo_type = make_unit_melee_ammo_type(30)
data:extend({digger_biter})

local digger_spawner = table.deepcopy(data.raw["unit-spawner"]["biter-spawner"])
digger_spawner.name = "digger-spawner"

--[[
unit :: string: Prototype name of the unit that would be spawned
spawn_points :: array of SpawnPoint: Each SpawnPoint is a table: 
evolution_factor :: double: Evolution factor for which this weight applies.
weight :: double: Probability of spawning this unit at this evolution fac
]]
digger_spawner.result_units = 
{
	{"digger-biter", {{0.0, 0.4}}},
	{"small-biter", {{0.0, 0.3}, {0.6, 0.0}}},
	{"small-spitter", {{0.25, 0.0}, {0.5, 0.3}, {0.7, 0.0}}},
	{"medium-biter", {{0.2, 0.0}, {0.6, 0.3}, {0.7, 0.1}}},
	{"medium-spitter", {{0.4, 0.0}, {0.7, 0.3}, {0.9, 0.1}}},
	{"big-spitter", {{0.5, 0.0}, {1.0, 0.4}}},
	{"big-biter", {{0.5, 0.0}, {1.0, 0.4}}},
	{"behemoth-biter", {{0.9, 0.0}, {1.0, 0.3}}},
	{"behemoth-spitter", {{0.9, 0.0}, {1.0, 0.3}}},
}

data:extend({digger_spawner})