if modmash.defines.names.droid_name ~= "droid" then return end

function compilatron_animations(tint1)
	return
	{
	  layers =
	  {
	  { --layer
		width = 40,
		height = 52,
		frame_count = 2,
		axially_symmetrical = false,
		direction_count = 32,
		shift = util.by_pixel(0.0, -14.0),
		tint = tint1,
		stripes =
		{
		  {
			filename = "__base__/graphics/entity/compilatron/compilatron-walk-1.png",
			width_in_frames = 2,
			height_in_frames = 16
		  },
		  {
			filename = "__base__/graphics/entity/compilatron/compilatron-walk-2.png",
			width_in_frames = 2,
			height_in_frames = 16
		  }
		},

		hr_version =
		{
		  width = 78,
		  height = 104,
		  frame_count = 2,
		  axially_symmetrical = false,
		  direction_count = 32,
		  shift = util.by_pixel(0.0, -14),
		  scale = 0.5,
		  tint = tint1,
		  stripes =
		  {
			{
			  filename = "__base__/graphics/entity/compilatron/hr-compilatron-walk-1.png",
			  width_in_frames = 2,
			  height_in_frames = 16
			},
			{
			  filename = "__base__/graphics/entity/compilatron/hr-compilatron-walk-2.png",
			  width_in_frames = 2,
			  height_in_frames = 16
			}
		  },
		}
	  },

	  { -- shadow
		width = 72,
		height = 30,
		frame_count = 2,
		direction_count = 32,
		shift = util.by_pixel(19, 0.0),
		draw_as_shadow = true,
		stripes = util.multiplystripes(2,
		{
		  {
			filename = "__base__/graphics/entity/compilatron/compilatron-walk-shadow.png",
			width_in_frames = 1,
			height_in_frames = 32
		  }
		}),
		hr_version =
		{
		  width = 142,
		  height = 56,
		  frame_count = 2,
		  axially_symmetrical = false,
		  direction_count = 32,
		  shift = util.by_pixel(15.5, -0.5),
		  draw_as_shadow = true,
		  scale = 0.5,
		  stripes = util.multiplystripes(2,
		  {
			{
			  filename = "__base__/graphics/entity/compilatron/hr-compilatron-walk-shadow.png",
			  width_in_frames = 1,
			  height_in_frames = 32
			}
		  })
		}
	  }
	  }
	}
end

local tint1 = {r=1, g=0.4, b=0.4, a=1} -- red
local tint2 = {r=0.4, g=1, b=0.4, a=1} -- green
local tint3 = {r=0.5, g=0.5, b=0.5, a=0.9} -- gray
local tint4 = {r=0, g=0.9, b=1, a=1} -- azul
local tint5 = {r=0.5, g=0, b=0.5, a=1} -- roxo
local tint6 = {r=1, g=1, b=0.5, a=1} -- amarelo
local tint7 = {r=1, g=1, b=1, a=1} -- white

local good_icon =
    {
      filename = "__modmashgraphics__/graphics/good-alert.png",
      priority = "extra-high-no-scale",
      width = 64,
      height = 64,
      flags = {"icon"}
    },

data:extend(
{
  {
    type = "item",
    name = "good-alert",
    icon = "__modmashgraphics__/graphics/good-alert.png",
    icon_size = 64,
	subgroup = "production-machine",
    order = "alerts",
    stack_size = 1
  }
}
)
data:extend(
{
	{
		duration_in_ticks = 180000,

		animation= {
			frame_count = 1,
			width = 40,
			priority = "extra-high",
			animation_speed = 0.0001,
			filename =  "__modmashgraphics__/graphics/stickers/droid-attack-sticker.png",
			height= 52,
			shift = util.by_pixel(0.0, -14.0),
		},
		single_particle = true,
		target_movement_modifier = 1,
		type = "sticker",
		name = "droid-attack-sticker"
	},
	{
		duration_in_ticks = 180000,

		animation= {
			frame_count = 1,
			width = 40,
			priority = "extra-high",
			animation_speed = 0.0001,
			filename =  "__modmashgraphics__/graphics/stickers/droid-build-sticker.png",
			height= 52,
			shift = util.by_pixel(0.0, -14.0),
		},
		single_particle = true,
		target_movement_modifier = 1,
		type = "sticker",
		name = "droid-build-sticker"
	},
	{
		duration_in_ticks = 180000,

		animation= {
			frame_count = 1,
			width = 40,
			priority = "extra-high",
			animation_speed = 0.0001,
			filename =  "__modmashgraphics__/graphics/stickers/droid-repair-sticker.png",
			height= 52,
			shift = util.by_pixel(0.0, -14.0),
		},
		single_particle = true,
		target_movement_modifier = 1,
		type = "sticker",
		name = "droid-repair-sticker"
	},
	{
		duration_in_ticks = 180000,

		animation= {
			frame_count = 1,
			width = 40,
			priority = "extra-high",
			animation_speed = 0.0001,
			filename =  "__modmashgraphics__/graphics/stickers/droid-scout-sticker.png",
			height= 52,
			shift = util.by_pixel(0.0, -14.0),
		},
		single_particle = true,
		target_movement_modifier = 1,
		type = "sticker",
		name = "droid-scout-sticker"
	},
	{
		duration_in_ticks = 180000,
		animation= {
			frame_count = 1,
			width = 40,
			priority = "extra-high",
			animation_speed = 0.0001,
			filename =  "__modmashgraphics__/graphics/stickers/droid-collect-sticker.png",
			height= 52,
			shift = util.by_pixel(0.0, -14.0),
		},
		single_particle = true,
		target_movement_modifier = 1,
		type = "sticker",
		name = "droid-collect-sticker"
	},
	{
		type = "unit",
		name = "droid",
		icon_size = 64,
		icon = "__modmashgraphics__/graphics/icons/construction_drone_icon.png",
		flags = {"placeable-player", "player-creation", "placeable-off-grid"},
		max_health = 450,
		subgroup="creatures",
		order="e-a-b-d",
		map_color = {r = 0, g = 0.5, b = 1, a = 1},
		has_belt_immunity = true,		
		alert_when_damaged = true,
		can_open_gates = true,
		affected_by_tiles = true,
		enabled = false,
		healing_per_tick = 0.01,

		collision_box = {{-0.4*0.3, -0.4*0.3}, {0.4*0.3, 0.4*0.3}},
		selection_box = {{-0.8*0.8, -0.8*0.8}, {0.8, 0.8*0.8}},
		sticker_box = {{-0.5, -0.5}, {0.5, 0.5}},
		collision_mask =  {"item-layer", "water-tile"}, --"object-layer"
		vision_distance = 30,
		movement_speed = 0.15,
		minable = {hardness = 0.1, mining_time = 0.1, result = "droid"},
		pollution_to_join_attack = 0.0,
		distraction_cooldown = 0,
		distance_per_frame =  0.05,

		corpse = "small-remnants",
		dying_explosion = "medium-explosion",

		resistances =
		{
			{
				type = "physical",
				decrease = 5,
				percent = 40
			},
			{
				type = "explosion",
				decrease = 5,
				percent = 70
			},
			{
				type = "acid",
				decrease = 1,
				percent = 30
			},
			{
				type = "fire",
				percent = 100
			}
		},
		attack_parameters = {
			type = "beam",
			damage_modifier = 100,
			range = 0.5,
			cooldown = 35,
			fire_penalty = 1,
			min_attack_distance = 0,
			movement_slow_down_factor = 0,
			ammo_type = {
      			category = "combat-robot-laser",
      			energy_consumption = "0kJ",
      			action = {
      				type = "direct",
      				action_delivery = {
      					type = "beam",
      					beam = "electric-beam",
      					max_length = 0.5,
      					duration = 30,
      				}
      			}
			},
			animation = compilatron_animations(tint7)
		},
			
		--idle = compilatron_animations,
		run_animation =compilatron_animations(tint7),		
		working_sound =
		{
		  sound =
		  {
			filename = "__base__/sound/fight/compilatron-1.ogg",
			volume = 0
		  },
		  {
			filename = "__base__/sound/fight/compilatron-2.ogg",
			volume = 0
		  },
		  apparent_volume = 1,
		  max_sounds_per_type = 4,
		  probability = 1 / (6 * 60) -- average pause between the sound is 6 seconds
		}
	},
	{		
		type = "container",
		name = "droid-chest",
		icon = "__modmashgraphics__/graphics/icons/droid-chest.png",
		icon_size = 32,
		flags = {"placeable-player", "player-creation"},
		minable = {hardness = 0.2, mining_time = 0.5, result = "droid-chest"},
		max_health = 350,
		corpse = "small-remnants",
		collision_box = {{-0.35, -0.35}, {0.35, 0.35}},
		selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
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
		fast_replaceable_group = "container",
		logistic_mode = "passive-provider",
		inventory_size = 32,
		open_sound = { filename = "__base__/sound/metallic-chest-open.ogg", volume=0.65 },
		close_sound = { filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.7 },
		vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
		picture =
		{
		  layers =
		  {
			{
			  filename = "__modmashgraphics__/graphics/entity/droid/droid-chest-storage-s.png",
			  priority = "extra-high",
			  width = 32,
			  height = 36,
			  shift = util.by_pixel(0.5, -2),
			  hr_version =
			  {
				filename = "__modmashgraphics__/graphics/entity/droid/hr-droid-chest-storage-s.png",
				priority = "extra-high",
				width = 64,
				height = 80,
				shift = util.by_pixel(-0.25, -0.5),
				scale = 0.5
			  }
			},
		  },
		},
		circuit_wire_connection_point = circuit_connector_definitions["chest"].points,
		circuit_connector_sprites = circuit_connector_definitions["chest"].sprites,
		circuit_wire_max_distance = default_circuit_wire_max_distance
	}
})

local local_create_beam_type = function(name, tint, interval, damage, damage_type)
	local beam =
	{
	  type = "beam",
	  name = name,
	  localised_name = name,
	  flags = {"not-on-map"},
	  damage_interval = 1000,
	  width = 0.5,
	  random_target_offset = true,
	  target_offset_y = -0.3,
	  head =
	  {
		filename = "__base__/graphics/entity/beam/beam-head.png",
		line_length = 16,
		width = 45,
		height = 39,
		frame_count = 16,
		animation_speed = 0.5,
		blend_mode = "additive",
		tint = tint
	  },
	  tail =
	  {
		filename = "__base__/graphics/entity/beam/beam-tail.png",
		line_length = 16,
		width = 45,
		height = 39,
		frame_count = 16,
		blend_mode = "additive",
		tint = tint
	  },
	  body =
	  {
		{
		  filename = "__base__/graphics/entity/beam/beam-body-1.png",
		  line_length = 16,
		  width = 45,
		  height = 39,
		  frame_count = 16,
		  blend_mode = "additive",
		  tint = tint
		},
		{
		  filename = "__base__/graphics/entity/beam/beam-body-2.png",
		  line_length = 16,
		  width = 45,
		  height = 39,
		  frame_count = 16,
		  blend_mode = "additive",
		  tint = tint
		},
		{
		  filename = "__base__/graphics/entity/beam/beam-body-3.png",
		  line_length = 16,
		  width = 45,
		  height = 39,
		  frame_count = 16,
		  blend_mode = "additive",
		  tint = tint
		},
		{
		  filename = "__base__/graphics/entity/beam/beam-body-4.png",
		  line_length = 16,
		  width = 45,
		  height = 39,
		  frame_count = 16,
		  blend_mode = "additive",
		  tint = tint
		},
		{
	      filename = "__base__/graphics/entity/beam/beam-body-5.png",
		  line_length = 16,
		  width = 45,
		  height = 39,
		  frame_count = 16,
		  blend_mode = "additive",
		  tint = tint
		},
		{
		  filename = "__base__/graphics/entity/beam/beam-body-6.png",
		  line_length = 16,
		  width = 45,
		  height = 39,
		  frame_count = 16,
		  blend_mode = "additive",
		  tint = tint
		}
	  }
	}
	if interval ~= nil and damage ~=nil and damage_type ~= nil then
	  beam.interval = interval
	  beam.action = 
	  {
		  type = "direct",
		  action_delivery =
		  {
			type = "instant",
			target_effects =
			{
			  {
				type = "damage",
				damage = { amount = damage, type = "beam"}
			  }
			}
		  }
	  }
	end
	return beam
end

data:extend({
	local_create_beam_type("droid_standard_beam",tint4,nil,nil,nil),
	local_create_beam_type("droid_attack_beam",tint4,20,4,nil)
})