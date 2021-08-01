require("prototypes.scripts.defines") 

if data.raw.item["gold-ore"] == nil then
data:extend(
{
  {
    type = "item",
    name = "gold-ore",
    icon = "__modmashsplintergold__/graphics/icons/gold-ore.png",
    icon_mipmaps = 4,
    icon_size = 64,
    pictures = {
        {
          filename = "__modmashsplintergold__/graphics/icons/gold-ore.png",
          mipmap_count = 4,
          scale = 0.25,
          size = 64
        },
        {
          filename = "__modmashsplintergold__/graphics/icons/gold-ore-1.png",
          mipmap_count = 4,
          scale = 0.25,
          size = 64
        },
        {
          filename = "__modmashsplintergold__/graphics/icons/gold-ore-2.png",
          mipmap_count = 4,
          scale = 0.25,
          size = 64
        },
        {
          filename = "__modmashsplintergold__/graphics/icons/gold-ore-3.png",
          mipmap_count = 4,
          scale = 0.25,
          size = 64
        }
    },
    subgroup = "raw-resource",    
    order = "g[gold-ore]",
    stack_size = 100
  },
  {
    type = "item",
    name = "gold-ore",
    icon = "__modmashsplintergold__/graphics/icons/gold-ore.png",
    icon_mipmaps = 4,
    icon_size = 64,
    pictures = {
        {
          filename = "__modmashsplintergold__/graphics/icons/gold-ore.png",
          mipmap_count = 4,
          scale = 0.25,
          size = 64
        },
        {
          filename = "__modmashsplintergold__/graphics/icons/gold-ore-1.png",
          mipmap_count = 4,
          scale = 0.25,
          size = 64
        },
        {
          filename = "__modmashsplintergold__/graphics/icons/gold-ore-2.png",
          mipmap_count = 4,
          scale = 0.25,
          size = 64
        },
        {
          filename = "__modmashsplintergold__/graphics/icons/gold-ore-3.png",
          mipmap_count = 4,
          scale = 0.25,
          size = 64
        }
    },
    subgroup = "raw-resource",    
    order = "g[gold-ore]",
    stack_size = 100
  }
})
end

if data.raw.item["gold-plate"] == nil then
data:extend(
{
  {
    type = "item",
    name = "gold-plate",
    icon = "__modmashsplintergold__/graphics/icons/gold-plate.png",
    icon_mipmaps = 4,
    icon_size = 64,
    subgroup = "raw-material",
    order = "d[gold-plate]",
    stack_size = 100
  }
})
end

if data.raw.item["gold-cable"] == nil then
data:extend(
 {
  {
    type = "item",
    name = "gold-cable",
    icon = "__modmashsplintergold__/graphics/icons/gold-cable.png",
    icon_mipmaps = 4,
    icon_size = 64,
    subgroup = "intermediate-product",
    order = "a[copper-cable][gold-wire]",
    stack_size = 200,
	wire_count = 1
  }
})
end

data:extend(
{
  {
    type = "item",
    name = "gold-statue",
    icon = "__modmashsplintergold__/graphics/icons/statue.png",
    icon_mipmaps = 4,
    icon_size = 64,
    subgroup = "defensive-structure",
    place_result = "gold-statue",
    order = "e[rocket-silo][statue]",
    stack_size = 1
  },
  {
    type = "beacon",
    name = "gold-statue",
    icon = "__modmashsplintergold__/graphics/icons/statue.png",
    icon_mipmaps = 4,
    icon_size = 64,
    flags = {"placeable-neutral", "player-creation", "filter-directions"},
    distribution_effectivity = 0.7,
    minable = {mining_time = 20, result = "gold-statue"},
    energy_source = {
        type = "electric",
        usage_priority = "secondary-input"
      },
    energy_usage = "300kW",
    allowed_effects = {
        "consumption",
        "speed",
        "pollution"
      },
    animation_progress = 1,
    apply_module_tint = "secondary",
    apply_module_tint_to_light = "none",
    min_animation_progress = 0,
    module_icons_suppressed = true,
    module_tint_mode = "mix",
    supply_area_distance = 12,
    module_specification = {
        module_info_icon_scale = 1,
        module_info_icon_shift = {
          0,
          0.5
        },
        module_info_max_icons_per_row = 1,
        module_info_multi_row_initial_height_modifier = 0.3,
        module_slots = 1
      },
    max_health = 5000,
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
    radius_visualisation_picture = {
        filename = "__base__/graphics/entity/beacon/beacon-radius-visualization.png",
        height = 10,
        priority = "extra-high-no-scale",
        width = 10
      },
    graphics_set = {
        animation_list = {
            {
                always_draw = true,
                animation = {
                    layers = {
                        {
                            filename = "__modmashsplintergold__/graphics/entity/gold-statue.png",
                            priority = "high",
                            shift = {3.25,-2.25},
                            width = 323,
                            height = 243
                        }                     
                    }                    
                }
            },render_layer = "object"
        }
    },
    --[[picture = {
        filename = "__modmashsplintergold__/graphics/entity/gold-statue.png",
        priority = "high",
        shift = {3.25,-2.25},
        width = 323,
        height = 243
	}]]
  }
  --[[
  {
    type = "simple-entity",
    name = "gold-statue",
    icon = "__modmashsplintergold__/graphics/icons/statue.png",
    icon_mipmaps = 4,
    icon_size = 64,
    flags = {"placeable-neutral", "player-creation", "filter-directions"},
    minable = {mining_time = 20, result = "gold-statue"},
    max_health = 5000,
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
        filename = "__modmashsplintergold__/graphics/entity/gold-statue.png",
        priority = "high",
        shift = {3.25,-2.25},
        width = 323,
        height = 243
	}
  }]]
})

if deadlock_stacking then
  local Items = {
		{titanium_ore_name, "deadlock-stacking-1"},
		{"sand", "deadlock-stacking-1"},
		{"alien-ore", "deadlock-stacking-1"},
		{"titanium-plate", "deadlock-stacking-1"},
		{"alien-plate", "deadlock-stacking-1"},
		{"glass", "deadlock-stacking-1"}
	}

	for _, item in pairs(Items) do
		local name = item[1]
		local tech = item[2]
		if data.raw.item[name] then
			if not data.raw.item["deadlock-stack-" .. name] then
				deadlock.add_stack(name, nil, tech, 64, "item", 4)
			end
		end
	end
end

if deadlock_stacking then
  local Items = {
		{"gold-ore", "deadlock-stacking-1"},
		{"gold-plate", "deadlock-stacking-1"},
		{"gold-cable", "deadlock-stacking-1"}
	}

	for _, item in pairs(Items) do
		local name = item[1]
		local tech = item[2]
		if data.raw.item[name] then
			if not data.raw.item["deadlock-stack-" .. name] then
				deadlock.add_stack(name, nil, tech, 64, "item", 4)
			end
		end
	end
end