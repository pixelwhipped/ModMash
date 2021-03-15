data_final_fixes = true
require("prototypes.scripts.defines") 
require("prototypes.scripts.types") 
local get_item_substitution  = modmashsplintergold.util.get_item_substitution

local sludge = get_item_substitution("sludge")
if sludge ~=nil then
	if data.raw.recipe["gold-ore"] ~= nil then
		if data.raw.recipe["gold-ore"].normal ~= nil and data.raw.recipe["gold-ore"].normal.results then
			for k=1, #data.raw.recipe["gold-ore"].normal.results do
				if data.raw.recipe["gold-ore"].normal.results[k].name == "water" then
					data.raw.recipe["gold-ore"].normal.results[k].name = sludge.name 
				end
			end
		end
		if data.raw.recipe["gold-ore"].expensive ~= nil and data.raw.recipe["gold-ore"].expensive.results then
			for k=1, #data.raw.recipe["gold-ore"].expensive.results do
				if data.raw.recipe["gold-ore"].expensive.results[k].name == "water" then
					data.raw.recipe["gold-ore"].expensive.results[k].name = sludge.name 
				end
			end
		end
	end
end

