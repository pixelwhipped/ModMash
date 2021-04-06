require ("prototypes.scripts.defines")
local hide_from_player_crafting = true

if modmashsplinterthem.debug == true then
    hide_from_player_crafting = false
end

local concrete = table.deepcopy(data.raw["tile"]["refined-concrete"])
concrete.name="them-concrete"
if settings.startup["setting-mineable-concrete"].value == "Off" then
    concrete.minable = nil
end

concrete.map_color = {r=1.0, g=0.0, b=0.5}
concrete.tint = {r=0.3, g=0.0, b=0.32}
concrete.vehicle_friction_modifier = 0.7
concrete.walking_speed_modifier = 0.5

local scorched = table.deepcopy(data.raw["tile"]["grass-1"]) --"nuclear-ground"])
scorched.name="them-scorched-earth"
scorched.pollution_absorption_per_second = 0
scorched.autoplace = nil
scorched.map_color = {
    b = 38,
    g = 0,
    r = 12
  }
--scorched.variants.material_background.picture = "__modmashsplinterthem__/graphics/entity/terrain/scorched-matter-1.png"
--scorched.variants.material_background.hr_version.picture = "__modmashsplinterthem__/graphics/entity/terrain/hr-scorched-matter-1.png"
for j, v in pairs (scorched.variants.main) do --material_background
   -- for i, p in pairs (pictures) do
        if v.picture ~= nil then
            v.picture = "__modmashsplinterthem__/graphics/entity/terrain/scorched-matter-1.png"
            if v.hr_version ~= nil and v.hr_version.picture ~=nil then
                v.hr_version.picture = "__modmashsplinterthem__/graphics/entity/terrain/hr-scorched-matter-1.png"
            end
        end
   -- end
end


data:extend({
    {
      icon = "__modmashsplinter__/graphics/icons/bad-icon.png",
      icon_mipmaps = 4,
      icon_size = 64,
      name = "them-concrete",
      subgroup = "them",		    
	  order = "them-concrete",
      place_as_tile = {
        condition = {
          --"water-tile"
        },
        condition_size = 1,
        result = "them-concrete"
      },
      stack_size = 100,
      type = "item",
      hide_from_player_crafting = hide_from_player_crafting
    },
    concrete,
    scorched
    })

if modmashsplinterthem.debug == true then
    data:extend(
    {
        {
            type = "recipe",
            name = "them-concrete",
            ingredients = {{name = "stone", amount = 1}},
            result = "them-concrete",
            enabled = true
	    }
	})
end