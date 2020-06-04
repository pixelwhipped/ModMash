--[[Code check 29.2.20
removed old comments
--]]
local recycling_state = {
    type = "simple-entity-with-force",
    name = "recycling-machine-indicator",
    flags = {"not-blueprintable", "not-deconstructable", "not-on-map", "placeable-off-grid"},
    icon = "__modmashgraphics__/graphics/stickers/blank-icon.png",
    icon_size = 32,
    max_health = 100,
    selectable_in_game = false,
    mined_sound = nil,
    minable = nil,
    collision_box = nil,
    selection_box = nil,
    collision_mask = {},
    render_layer = "explosion",
    vehicle_impact_sound = nil,
    pictures =
    {
        {
            filename = "__modmashgraphics__/graphics/stickers/recycling-automatic.png",
            priority = "extra-high",
            x = 0,
            y = 0,
            width = 17,
            height = 17,
            scale = 1,
        },
        {
            filename = "__modmashgraphics__/graphics/stickers/recycling-manual.png",
            priority = "extra-high",
            x = 0,
            y = 0,
            width = 17,
            height = 17,
            scale = 1,
        },
    },
}
data:extend({recycling_state})

data:extend(
{
  {
    type = "assembling-machine",
	stack_size = 50,
    name = "recycling-machine",
	localised_description = {"item-description.recycling-machine",settings.startup["modmash-setting-adjust-binding"].value},
    icon = "__modmashgraphics__/graphics/icons/recycling-machine.png",
    icon_size = 32,	
    flags = {"placeable-neutral","placeable-player", "player-creation"},
    minable = {hardness = 0.2, mining_time = 0.5, result = "recycling-machine"},
    max_health = 600,
    corpse = "big-remnants",
    dying_explosion = "medium-explosion",
    resistances = 
    {
      {
        type = "fire",
        percent = 70
      }
    },
    open_sound = { filename = "__base__/sound/machine-open.ogg", volume = 0.85 },
    close_sound = { filename = "__base__/sound/machine-close.ogg", volume = 0.75 },
    working_sound =
    {
      sound = {
        {
          filename = "__base__/sound/assembling-machine-t3-1.ogg",
          volume = 0.8
        },
        {
          filename = "__base__/sound/assembling-machine-t3-2.ogg",
          volume = 0.8
        },
      },
      idle_sound = { filename = "__base__/sound/idle1.ogg", volume = 0.6 },
      apparent_volume = 1.5,
    },
    collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
    fast_replaceable_group = "assembling-machine",
    animation =
    {
      layers =
      {
        {
          filename = "__modmashgraphics__/graphics/entity/recycling-machine/recycling-machine.png",
          priority = "high",
          width = 142,
          height = 113,
          frame_count = 32,
          line_length = 8,
          shift = {0.84, -0.09},
        },
      }
    },
    source_inventory_size = 2,
    result_inventory_size = 5,
    crafting_categories = {"recycling"},
    crafting_speed = 4,
    energy_source =
    {	  
      type = "electric",
      usage_priority = "secondary-input",
      emissions_per_minute = 3
    },
    energy_usage = "240kW",
    ingredient_count = 10,
    module_specification =
    {
      module_slots = 5,
      module_info_icon_shift = {0, 0.5},
      module_info_multi_row_initial_height_modifier = -0.3
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
				position = {0, -2},
				type = "output"
			}
		},		
      },
	  off_when_no_fluid_recipe = false
    },
    allowed_effects = {"consumption", "speed", "productivity", "pollution"}
  }
}
)