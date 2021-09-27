data_final_fixes = true
require("prototypes.scripts.defines") 
local dirt_prefix  = modmashsplinterunderground.defines.names.dirt_prefix

for k=1, 7 do
	local name = dirt_prefix.."dirt-"..k
	if data.raw["tile"][name] == nil then
		local t = table.deepcopy(data.raw["tile"]["dirt-"..k])
		if t == nil then t = table.deepcopy(data.raw["tile"]["landfill"]) end		 
		t.name = name
		t.pollution_absorption_per_second = 0
		if t.autoplace ~= nil then t.autoplace.default_enabled = false end
		t.tint = {0.35,0.35,0.35,1}
		data:extend({t})
	end
end