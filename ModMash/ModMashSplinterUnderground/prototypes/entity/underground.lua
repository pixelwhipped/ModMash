require("prototypes.scripts.defines") 
local underground_accumulator  = modmashsplinterunderground.defines.names.underground_accumulator
local underground_access  = modmashsplinterunderground.defines.names.underground_access
local underground_access2  = modmashsplinterunderground.defines.names.underground_access2
local used_battery_cell  = modmashsplinterunderground.defines.names.used_battery_cell
local battery_cell  = modmashsplinterunderground.defines.names.battery_cell

function underground_accumulator_picture(tint, repeat_count)
  return
  {
    layers =
    {
      {
        filename = "__modmashsplinterunderground__/graphics/entity/underground/accumulator.png",
        priority = "high",
        width = 33,
        height = 94,
        shift = util.by_pixel(0, -10),
        animation_speed = 0.5,
		repeat_count = repeat_count,
        tint = tint,
        hr_version =
        {
          filename = "__modmashsplinterunderground__/graphics/entity/underground/hr-accumulator.png",
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
        filename = "__modmashsplinterunderground__/graphics/entity/underground/accumulator-shadow.png",
        priority = "high",
        width = 120,
        height = 27,
        repeat_count = repeat_count,
        shift = util.by_pixel(49, 12),
        draw_as_shadow = true,
		repeat_count = repeat_count,
        hr_version =
        {
          filename = "__modmashsplinterunderground__/graphics/entity/underground/hr-accumulator-shadow.png",
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
        filename = "__modmashsplinterunderground__/graphics/entity/underground/battery-cell.png",
        priority = "high",
        width = 33,
        height = 94,
        shift = util.by_pixel(0, -10),
        animation_speed = 0.5,
		repeat_count = repeat_count,
        tint = tint,
        hr_version =
        {
          filename = "__modmashsplinterunderground__/graphics/entity/underground/hr-battery-cell.png",
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
        filename = "__modmashsplinterunderground__/graphics/entity/underground/accumulator-shadow.png",
        priority = "high",
        width = 120,
        height = 27,
        repeat_count = repeat_count,
        shift = util.by_pixel(49, 12),
        draw_as_shadow = true,
		repeat_count = repeat_count,
        hr_version =
        {
          filename = "__modmashsplinterunderground__/graphics/entity/underground/hr-accumulator-shadow.png",
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
        filename = "__modmashsplinterunderground__/graphics/entity/underground/used-battery-cell.png",
        priority = "high",
        width = 33,
        height = 94,
        shift = util.by_pixel(0, -10),
        animation_speed = 0.5,
		repeat_count = repeat_count,
        tint = tint,
        hr_version =
        {
          filename = "__modmashsplinterunderground__/graphics/entity/underground/hr-used-battery-cell.png",
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
        filename = "__modmashsplinterunderground__/graphics/entity/underground/accumulator-shadow.png",
        priority = "high",
        width = 120,
        height = 27,
        repeat_count = repeat_count,
        shift = util.by_pixel(49, 12),
        draw_as_shadow = true,
		repeat_count = repeat_count,
        hr_version =
        {
          filename = "__modmashsplinterunderground__/graphics/entity/underground/hr-accumulator-shadow.png",
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

function underground_accumulator_charge(base_picture)
  return
  {
    layers =
    {
      base_picture,
      {
        filename = "__modmashsplinterunderground__/graphics/entity/underground/accumulator-charge.png",
        width = 45,
        height = 100,
        line_length = 6,
        frame_count = 24,
        blend_mode = "additive",
        shift = util.by_pixel(0, -22),
        hr_version =
        {
          filename = "__modmashsplinterunderground__/graphics/entity/underground/hr-accumulator-charge.png",
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

function underground_accumulator_discharge(base_picture)
  return
  {
    layers =
    {
      base_picture,
      {
        filename = "__modmashsplinterunderground__/graphics/entity/underground/accumulator-discharge.png",
        width = 44,
        height = 104,
        line_length = 6,
        frame_count = 24,
        blend_mode = "additive",
        shift = util.by_pixel(-2, -22),
        hr_version =
        {
          filename = "__modmashsplinterunderground__/graphics/entity/underground/hr-accumulator-discharge.png",
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
		icon = "__modmashsplinterunderground__/graphics/icons/underground-access.png",
		icon_size = 64,
		icon_mipmaps = 4,
		flags = {"placeable-neutral", "placeable-player", "player-creation"},
		minable = {hardness = 0.2, mining_time = 0.5, result = underground_access},
		max_health = 350,
		corpse = "medium-small-remnants",
		collision_box = {{-0.8, -0.8 }, {0.8, 0.8}},
		selection_box = {{-1, -1 }, {1, 1}},
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
		inventory_size = 8,
		open_sound = { filename = "__base__/sound/metallic-chest-open.ogg", volume=0.65 },
		close_sound = { filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.7 },
		vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
		picture =
		{
			  filename = "__modmashsplinterunderground__/graphics/entity/underground/access01.png",
			  priority = "high",
			  width = 76,
			  height = 60,
			  axially_symmetrical = false,
			  direction_count = 1,
			  frame_count = 1,
			  shift = util.by_pixel(1, -1),
			  hr_version =
			  {
				filename = "__modmashsplinterunderground__/graphics/entity/underground/hr-access01.png",
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
		icon = "__modmashsplinterunderground__/graphics/icons/underground-access2.png",
		icon_size = 64,
		icon_mipmaps = 4,
		flags = {"placeable-neutral", "placeable-player", "player-creation"},
		minable = {hardness = 0.2, mining_time = 0.5, result = underground_access2},
		max_health = 350,
		corpse = "medium-small-remnants",
		collision_box = {{-0.8, -0.8 }, {0.8, 0.8}},
		selection_box = {{-1, -1 }, {1, 1}},
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
			  filename = "__modmashsplinterunderground__/graphics/entity/underground/access02.png",
			  priority = "high",
			  width = 76,
			  height = 60,
			  axially_symmetrical = false,
			  direction_count = 1,
			  frame_count = 1,
			  shift = util.by_pixel(1, -1),
			  hr_version =
			  {
				filename = "__modmashsplinterunderground__/graphics/entity/underground/hr-access02.png",
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
		icon = "__modmashsplinterunderground__/graphics/icons/underground-accumulator.png",
		icon_size = 64,
		icon_mipmaps = 4,
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
		charge_animation = underground_accumulator_charge(underground_accumulator_picture({ r=1, g=1, b=1, a=1 } , 24)),

		charge_cooldown = 30,
		charge_light = {intensity = 0.3, size = 7, color = {r = 1.0, g = 1.0, b = 1.0}},
		discharge_animation = underground_accumulator_discharge(underground_accumulator_picture({ r=1, g=1, b=1, a=1 } , 24)),
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
		name = battery_cell,
		icon = "__modmashsplinterunderground__/graphics/icons/battery-cell.png",
		icon_size = 64,
		icon_mipmaps = 4,
		flags = {"placeable-neutral", "player-creation"},
		minable = {mining_time = 0.1, result = used_battery_cell},
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
		charge_animation = underground_accumulator_charge(underground_battery_picture({ r=1, g=1, b=1, a=1 } , 24)),

		charge_cooldown = 30,
		charge_light = {intensity = 0.3, size = 7, color = {r = 1.0, g = 1.0, b = 1.0}},
		discharge_animation = underground_accumulator_discharge(underground_battery_picture({ r=1, g=1, b=1, a=1 } , 24)),
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
		name = used_battery_cell,
		icon = "__modmashsplinterunderground__/graphics/icons/used-battery-cell.png",
		icon_size = 64,
		icon_mipmaps = 4,
		flags = {"placeable-neutral", "player-creation"},
		minable = {mining_time = 0.1, result = used_battery_cell},
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
		picture = underground_used_battery_picture(),
		charge_animation = underground_accumulator_charge(underground_used_battery_picture({ r=1, g=1, b=1, a=1 } , 24)),

		charge_cooldown = 30,
		charge_light = {intensity = 0.3, size = 7, color = {r = 1.0, g = 1.0, b = 1.0}},
		discharge_animation = underground_accumulator_discharge(underground_used_battery_picture({ r=1, g=1, b=1, a=1 } , 24)),
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