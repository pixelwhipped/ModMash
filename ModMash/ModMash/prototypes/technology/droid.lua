--[[Code check 29.2.20
no changes
--]]
if not modmash or not modmash.util then require("prototypes.scripts.util") end

local get_name_for = modmash.util.get_name_for


if data.raw["technology"]["electronics"].effects == nil then
	data.raw["technology"]["electronics"].effects = {}
end

table.insert(
data.raw["technology"]["electronics"].effects,
{type = "unlock-recipe",recipe = "droid"}
)
table.insert(
data.raw["technology"]["electronics"].effects,
{type = "unlock-recipe",recipe = "droid-chest"}
)

data:extend(
{
  {
    type = "technology",
    name = "enhance-drone-targeting-1",
	localised_name = {"technology-description.enhance-drone-targeting-1"},
	localised_description =  {"technology-description.enhance-drone-targeting-1"},
	icon = "__modmashgraphics__/graphics/icons/construction_drone_icon.png",
    icon_size = 64,
    effects =
    {
    },
    prerequisites =
    {
      "electronics"
    },
    unit =
    {
      count = 200,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},	
      },
      time = 45
    },
    upgrade = true,
    order = "a-b-d",
  },
}
)

local create_technology = function(level)
	return  
	{
		{
			type = "technology",
			name = "enhance-drone-targeting-"..level,
			icon = "__modmashgraphics__/graphics/icons/construction_drone_icon.png",
			icon_size = 64,
			localised_name = {"",{"technology-description.enhance-drone-targeting-1"}," ",level},-- get_name_for("enhance-drone-targeting-1",nil,(" "..level)),
			localised_description =  {"technology-description.enhance-drone-targeting-1"},
			--localised_name = "Drone Targeting Enhancement "..level,
			--localised_description = "Increases the droid search range",
			effects =
			{
			},
			prerequisites =
			{
				"enhance-drone-targeting-"..(level-1)
			},
			unit =
			{
				count = (200+(level*25)),
				ingredients =
				{
					{"automation-science-pack", 1},
					{"logistic-science-pack", 1},	
				},
				time = 45
			},
			upgrade = true,
			order = "a-b-d",
		},
	}
end

for k=2, 6 do
	data:extend(create_technology(k))
end