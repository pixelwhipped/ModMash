--[[Code check 29.2.20
no changes
--]]
local function patch_technology(technology, recipe)
	if data.raw["technology"][technology] then
		table.insert(data.raw["technology"][technology].effects, {
			type="unlock-recipe",
			recipe=recipe
		})
	end
end

patch_technology("military-2","titanium-rounds-magazine")
patch_technology("military-2","alien-rounds-magazine")