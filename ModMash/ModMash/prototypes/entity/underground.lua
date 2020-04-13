if not modmash or not modmash.util then require("prototypes.scripts.util") end

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
		name = "underground-access",
		icon = "__modmashgraphics__/graphics/icons/underground-access.png",
		icon_size = 32,
		flags = {"placeable-player", "player-creation"},
		minable = {hardness = 0.2, mining_time = 0.5, result = "underground-access"},
		max_health = 350,
		corpse = "medium-small-remnants",
		collision_box = {{-0.8, -0.8 }, {0.8, 0.8}},
		selection_box = {{-1, -1 }, {1, 1}},
		enabled = false,
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
			  filename = "__base__/graphics/entity/gun-turret/gun-turret-base.png",
			  priority = "high",
			  width = 76,
			  height = 60,
			  axially_symmetrical = false,
			  direction_count = 1,
			  frame_count = 1,
			  shift = util.by_pixel(1, -1),
			  hr_version =
			  {
				filename = "__base__/graphics/entity/gun-turret/hr-gun-turret-base.png",
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
		circuit_wire_max_distance = default_circuit_wire_max_distance
	},
	{
		type = "accumulator",
		name = "underground-accumulator",
		icon = "__modmashgraphics__/graphics/icons/underground-accumulator.png",
		icon_size = 32,
		flags = {"placeable-neutral", "player-creation"},
		minable = {mining_time = 0.1, result = "underground-accumulator"},
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
	}
})

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