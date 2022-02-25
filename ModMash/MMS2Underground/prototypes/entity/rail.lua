local local_create_rail_subway_animation= function(path)
    return {
        north = {
            layers = {
                {
                    filename = "__mms2underground__/graphics/entity/"..path.."/N.png",
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
                    filename = "__mms2underground__/graphics/entity/"..path.."/E.png",
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
                    filename = "__mms2underground__/graphics/entity/"..path.."/S.png",
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
                    filename = "__mms2underground__/graphics/entity/"..path.."/W.png",
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
                    filename = "__mms2underground__/graphics/entity/fake-stop/fake-stop.png",
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
    subway.icon = "__mms2common__/graphics/icons/bad-icon.png"
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
            icon = "__mms2common__/graphics/icons/bad-icon.png",
            icon_size = 64,
            icon_mipmaps = 4,
            flags = {},
            subgroup = "transport",
            order = "a[train-system]-c[fake-stop]",
            place_result = "fake-stop",
            stack_size = 1
        }
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
            icon = "__mms2underground__/graphics/icons/"..name..".png",
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


local_create_rail_subway("subway-level-one",1000,level_one_rail_overlay_animations,level_one_top_animations,{{ "train-stop", 2 },{ "rail", 8 },{ "stone", 20 }})

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
  }
})

data:extend({
    {
		icon = "__mms2underground__/graphics/icons/signal-0-1.png",
		icon_mipmaps = 4,
		icon_size = 64,
		name = "stop-signal-0-1",
		order = "zz",
		subgroup = "virtual-signal",
		type = "virtual-signal"
	},{
		icon = "__mms2underground__/graphics/icons/signal-1-0.png",
		icon_mipmaps = 4,
		icon_size = 64,
		name = "stop-signal-1-0",
		order = "zz",
		subgroup = "virtual-signal",
		type = "virtual-signal"
	}
  })


 local generate_signal_combinator = function(combinator,name)
    combinator.pictures =
    { layers =
      {
        {
          filename = "__mms2underground__/graphics/entity/combinator/combinator-"..name..".png",
          width = 58,
          height = 52,
          frame_count = 1,
          direction_count = 4,
          shift = util.by_pixel(0, 5),
          hr_version =
          {
            scale = 0.5,
            filename = "__mms2underground__/graphics/entity/combinator/hr-combinator-"..name..".png",
            width = 114,
            height = 102,
            frame_count = 1,
            direction_count = 4,
            shift = util.by_pixel(0, 5)
          }
        },
        {
          filename = "__base__/graphics/entity/combinator/constant-combinator-shadow.png",
          width = 50,
          height = 34,
          frame_count = 1,
          direction_count = 4,
          shift = util.by_pixel(9, 6),
          draw_as_shadow = true,
          hr_version =
          {
            scale = 0.5,
            filename = "__base__/graphics/entity/combinator/hr-constant-combinator-shadow.png",
            width = 98,
            height = 66,
            frame_count = 1,
            direction_count = 4,
            shift = util.by_pixel(8.5, 5.5),
            draw_as_shadow = true
          }
        }
      }
    }--)
end

local wire_connection_points=
    {
      {
        shadow =
        {
         -- copper = util.by_pixel(0.0, -82.5),
          red = util.by_pixel(8.0, -10.0),
          green = util.by_pixel(-8, -10.0)
        },
        wire =
        {
         -- copper = util.by_pixel(0.0, -82.5),
          red = util.by_pixel(-8.0, -10.0),
          green = util.by_pixel(8, -10.0)
        }
      },
      { --facing right
        shadow =
        {
         -- copper = util.by_pixel(1.5, -81.0),
          red = util.by_pixel(16, -8),
          green = util.by_pixel(16, 0)
        },
        wire =
        {
         -- copper = util.by_pixel(1.5, -81.0),
          red = util.by_pixel(16, -8),
          green = util.by_pixel(16, -0)
        }
      },
      { -- facing down
        shadow =
        {
         -- copper = util.by_pixel(1.5, -81.0),
          red = util.by_pixel(8, 0),
          green = util.by_pixel(-8, 0)
        },
        wire =
        {
        --  copper = util.by_pixel(2.5, -79.5),
          red = util.by_pixel(8.0, 0),
          green = util.by_pixel(-8.0, 0)
        }
      },
      { -- facing left
        shadow =
        {
         -- copper = util.by_pixel(0.5, -86.5),
          red = util.by_pixel(-16, 0),
          green = util.by_pixel(-16, -8)
        },
        wire =
        {
         -- copper = util.by_pixel(0.5, -86.5),
          red = util.by_pixel(-16, 0),
          green = util.by_pixel(-16, -8)
        }
      }
    }


local ugc1 = util.table.deepcopy(data.raw['constant-combinator']["constant-combinator"])
ugc1.name = "underground-combinator-l1"
ugc1.type = "electric-pole"
generate_signal_combinator(ugc1,"l1")


ugc1.icon = "__mms2underground__/graphics/icons/combinator-l1.png"
ugc1.icon_mipmaps = 4
ugc1.icon_size = 64
ugc1.minable.result = "underground-combinator-l1"
ugc1.supply_area_distance = 0
ugc1.connection_points = wire_connection_points
ugc1.maximum_wire_distance = 9

data:extend({
    {
        type = "item",
        name = "underground-combinator-l1",
        icon = "__mms2underground__/graphics/icons/combinator-l1.png",
        icon_size = 64,
        icon_mipmaps = 4,
        flags = {},
        subgroup = "transport",
        order = "a[train-system]-d[underground-combinator-l1]",
        place_result = "underground-combinator-l1",
        stack_size = 1
    },
    ugc1,
    {
        type = "recipe",
        name = "underground-combinator-l1",
        enabled = false,
        ingredients = {
            {
              "copper-cable",
              8
            },
            {
              "electronic-circuit",
              4
            }
        },
        energy_required = 4.5,
        result = "underground-combinator-l1",
        requester_paste_multiplier = 1
    }
})