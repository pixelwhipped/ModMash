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


local function hasStr(inlist,instr)

	if not(inlist) then return false; end
	
	for _,entry in pairs(inlist) do
		if(entry==instr) then
			return true;
		end
	end
	return false;
end
for _,t in pairs(data.raw["tile"]) do
	if (t.transitions) then
		for _,entry in pairs(t.transitions) do
			if(hasStr(entry.to_tiles,"out-of-map")) then
				table.insert(entry.to_tiles,"underground-out-of-map");
			end
		end
	end
end