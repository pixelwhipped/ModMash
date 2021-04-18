local local_update_masks = function()
    local mask = {"object-layer", "item-layer", "floor-layer", "water-tile"}
    for name,_ in pairs(data.raw["curved-rail"]) do
        if not data.raw["curved-rail"][name].collision_mask then
            data.raw["curved-rail"][name].collision_mask = mask
        end
        table.insert(data.raw["curved-rail"][name].collision_mask, "layer-13")
    end
end

local local_create_rail_subway_animation= function(path)
    return {
        north = {
            layers = {
                {
                    filename = "__modmashsplinterunderground__/graphics/entity/"..path.."/N.png",
                    frame_count = 1,
                    height = 512,
                    hr_version =nil,
                    line_length = 1,
                    priority = "high",
                    scale = 1,
                    shift = util.by_pixel(-96+32,96),--{-1,2.6},
                    width = 256
                }
            }
        },
        east = {
            layers = {
                {
                    filename = "__modmashsplinterunderground__/graphics/entity/"..path.."/E.png",
                    frame_count = 1,
                    height = 256,
                    line_length = 1,
                    priority = "high",
                    scale = 1,
                    shift = util.by_pixel(-88,-80),
                    width = 512,
                }
            }
        },
        south = {
            layers = {
                {
                    filename = "__modmashsplinterunderground__/graphics/entity/"..path.."/S.png",
                    frame_count = 1,
                    height = 512,
                    hr_version = nil,
                    line_length = 1,
                    priority = "high",
                    scale = 1,
                    shift = util.by_pixel(64,-80),
                    width = 256
                }
            }
        },
        west = {
            layers = {
                {
                    filename = "__modmashsplinterunderground__/graphics/entity/"..path.."/W.png",
                    frame_count = 1,
                    height = 256,
                    hr_version = nil,
                    line_length = 1,
                    priority = "high",
                    scale = 1,
                    shift = util.by_pixel(104,48),
                    width = 512,
                }
            }
        }
    }
    end

local local_create_fake_stopy_animation= function()
    local img = {
                    filename = "__modmashsplinterunderground__/graphics/entity/fake-stop/fake-stop.png",
                    frame_count = 1,
                    height = 48,
                    hr_version =nil,
                    line_length = 1,
                    priority = "high",
                    scale = 1,
                    width = 48
                }
    return {
        north = { layers = { img } },
        east = { layers = { img } },
        south = { layers = { img } },
        west = { layers = { img } }
    }
    end

local local_create_fake_stop = function()
    local subway = util.table.deepcopy(data.raw['train-stop']["train-stop"])
    subway.icon = "__modmashsplinter__/graphics/icons/bad-icon.png"
    subway.icon_size = 64
    subway.icon_mipmaps = 4
    subway.name = "fake-stop"
    subway.minable.result = nil
    subway.selection_box = nil
    subway.collision_box = {{-0.5, -0.5}, {0.5, 0.5}}
    subway.corpse = nil
    subway.light1 = nil
    subway.light2 = nil
    subway.animations = nil
    subway.top_animations = local_create_fake_stopy_animation()
    subway.rail_overlay_animations = nil
    subway.collision_mask = {}
    subway.max_health = 99999
    subway.circuit_wire_connection_points = nil
    subway.circuit_wire_max_distance = nil
    subway.circuit_connector_sprites = nil
    subway.chart_name = false
    subway.alert_when_damaged = false
    subway.create_ghost_on_death = false
    subway.selectable_in_game = false

    data:extend({   
        subway,
        {
            type = "item",
            name = "fake-stop",
            icon = "__modmashsplinter__/graphics/icons/bad-icon.png",
            icon_size = 64,
            icon_mipmaps = 4,
            flags = {},
            subgroup = "transport",
            order = "a[train-system]-c[fake-stop]",
            place_result = "fake-stop",
            stack_size = 1
        }--[[,
        {
            type = "recipe",
            name = "fake-stop",
            enabled = true,
            ingredients = {{ "stone", 1 }},
            energy_required = 1,
            result = "fake-stop",
            requester_paste_multiplier = 1
        },]]
    })
end
     
local local_create_rail_subway = function(name, health,rail_overlay_animations,top_animations,ingredients)
    local subway = util.table.deepcopy(data.raw['train-stop']["train-stop"])
    subway.name = name
    subway.minable.result = name
    subway.selection_box = {{-6, -2}, {2, 5}}
    subway.collision_box = {{-6, -4.25}, {2, 9.5}}
    subway.corpse = nil
    subway.light1 = nil
    subway.light2 = nil
    subway.animations = nil
    subway.top_animations = top_animations
    subway.rail_overlay_animations = rail_overlay_animations
    subway.collision_mask = {"layer-13", "player-layer"}
    subway.max_health = health
    data:extend({   
        subway,
        {
            type = "item",
            name = name,
            icon = "__modmashsplinterunderground__/graphics/icons/"..name..".png",
            icon_size = 64,
            icon_mipmaps = 4,
            flags = {},
            subgroup = "transport",
            order = "a[train-system]-c["..name.."]",
            place_result = name,
            stack_size = 1
        },
        {
            type = "recipe",
            name = name,
            enabled = false,
            ingredients = ingredients,
            energy_required = 4.5,
            result = name,
            requester_paste_multiplier = 1
        },
    })
end

local level_one_rail_overlay_animations = local_create_rail_subway_animation("rail1bottom")
local level_one_top_animations = local_create_rail_subway_animation("rail1top")

local level_two_rail_overlay_animations = local_create_rail_subway_animation("rail2bottom")
local level_two_top_animations = local_create_rail_subway_animation("rail2top")

local_update_masks()

local_create_rail_subway("subway-level-one",1000,level_one_rail_overlay_animations,level_one_top_animations,{{ "train-stop", 2 },{ "rail", 8 },{ "stone", 20 }})
local_create_rail_subway("subway-level-two",1000,level_two_rail_overlay_animations,level_two_top_animations,{{ "subway-level-one", 1 },{ "stone", 20 }})
local_create_fake_stop()

data:extend({
  {
	type = "technology",
    name = "subway-level-one",
    icon = "__base__/graphics/technology/automated-rail-transportation.png",
    icon_size = 256, icon_mipmaps = 4,
    effects = {
      {
        type = "unlock-recipe",
        recipe = "subway-level-one"
      }
	},
    prerequisites = {"automated-rail-transportation"},
    unit =
    {
      count = 100,
      ingredients =
      {
        {"automation-science-pack", 3},
        {"logistic-science-pack", 3},	
      },
      time = 15
    },
    order = "a-f-d"
  },
  {
	type = "technology",
    name = "subway-level-one-more1",
    icon = "__base__/graphics/technology/automated-rail-transportation.png",
    icon_size = 256, icon_mipmaps = 4,
    effects = {},
    prerequisites = {"subway-level-one"},
    unit =
    {
      count = 100,
      ingredients =
      {
        {"automation-science-pack", 3},
        {"logistic-science-pack", 3},	
      },
      time = 15
    },
    order = "a-f-d"
  },
  {
	type = "technology",
    name = "subway-level-two",
    icon = "__base__/graphics/technology/automated-rail-transportation.png",
    icon_size = 256, icon_mipmaps = 4,
    effects = {
      {
        type = "unlock-recipe",
        recipe = "subway-level-two"
      }
	},
    prerequisites = {"subway-level-one","underground"},
    unit =
    {
      count = 100,
      ingredients =
      {
        {"automation-science-pack", 3},
        {"logistic-science-pack", 3},	
      },
      time = 15
    },
    order = "a-f-d"
  },
  {
	type = "technology",
    name = "subway-level-two-more1",
    icon = "__base__/graphics/technology/automated-rail-transportation.png",
    icon_size = 256, icon_mipmaps = 4,
    effects = {},
    prerequisites = {"subway-level-two"},
    unit =
    {
      count = 100,
      ingredients =
      {
        {"automation-science-pack", 3},
        {"logistic-science-pack", 3},	
      },
      time = 15
    },
    order = "a-f-d"
  },
})

data:extend({
    {
		icon = "__modmashsplinterunderground__/graphics/icons/signal-0-1.png",
		icon_mipmaps = 4,
		icon_size = 64,
		name = "stop-signal-0-1",
		order = "zz",
		subgroup = "virtual-signal",
		type = "virtual-signal"
	},{
		icon = "__modmashsplinterunderground__/graphics/icons/signal-1-0.png",
		icon_mipmaps = 4,
		icon_size = 64,
		name = "stop-signal-1-0",
		order = "zz",
		subgroup = "virtual-signal",
		type = "virtual-signal"
	},{
		icon = "__modmashsplinterunderground__/graphics/icons/signal-1-2.png",
		icon_mipmaps = 4,
		icon_size = 64,
		name = "stop-signal-1-2",
		order = "zz",
		subgroup = "virtual-signal",
		type = "virtual-signal"
	},{
		icon = "__modmashsplinterunderground__/graphics/icons/signal-2-1.png",
		icon_mipmaps = 4,
		icon_size = 64,
		name = "stop-signal-2-1",
		order = "zz",
		subgroup = "virtual-signal",
		type = "virtual-signal"
	},
  })