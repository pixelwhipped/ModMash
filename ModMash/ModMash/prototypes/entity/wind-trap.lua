--[[Code check 29.2.20
remove localized strings
--]]
data:extend(
{
{
    type = "assembling-machine",
    name = "wind-trap",
    icon = "__modmashgraphics__/graphics/icons/wind-trap.png",
    icon_size = 32,
    flags = {"placeable-neutral", "placeable-player", "player-creation"},
    minable = {mining_time = 1, result = "wind-trap"},
    max_health = 200,
    crafting_categories = {"wind-trap"},
    crafting_speed = 1,
    ingredient_count = 1,
    module_specification = nil,
    allowed_effects = nil,
    fast_replaceable_group = nil,
    corpse = "big-remnants",
    resistances =
    {
      {
        type = "fire",
        percent = 70
      }
    },
    fluid_boxes =
    {
      {
		base_area = 10,
		base_level = 1,
		pipe_picture = assembler2pipepictures(),
        pipe_covers = pipecoverspictures(),
		production_type = "output",
		pipe_connections =
		{
			{
				position = {0, 2},
				type = "output"
			}
		},		
      },
	  off_when_no_fluid_recipe = false
    },
	always_draw_idle_animation = false,
    collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-input",
      emissions = -0.12,
	  drain = "20kW",
    },
    energy_usage = "200kW",
    vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    working_sound =
    {
      sound =
      {
        filename = "__base__/sound/burner-mining-drill.ogg",
        volume = 0.8
      },
    },
    animation =
    {
      layers =
      {
        {
          filename = "__modmashgraphics__/graphics/entity/wind-trap/wind-trap.png",
          priority = "high",
          width = 142,
          height = 113,
          frame_count = 8,
          line_length = 8,
          shift = {0.84, -0.09},
        },
      }
    },
  },
}
)