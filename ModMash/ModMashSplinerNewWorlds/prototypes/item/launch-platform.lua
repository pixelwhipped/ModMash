  local subgroup = "subspace-logistic"
if mods["modmashsplintersubspacelogistics"] == nil then subgroup = "logistic-network" end

data:extend(
{
    {
		type = "item",
		name = "launch-platform",
		icon = "__modmashsplinternewworlds__/graphics/icons/launch-platform-icon.png",
		icon_size = 64,
        icon_mipmaps = 4,   
		subgroup = subgroup,
		order = "f",
		place_result = "launch-platform",
		stack_size = 50
    },
})