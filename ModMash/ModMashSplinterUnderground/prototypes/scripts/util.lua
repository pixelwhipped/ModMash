require("defines")
if remote == nil then
	require ("prototypes.entity.rocks")
end
local level_one_rock_prefix  = modmashsplinterunderground.defines.names.level_one_rock_prefix
local level_two_rock_prefix  = modmashsplinterunderground.defines.names.level_two_rock_prefix

local local_update_underground_loot = function(name,result)
	if result.name == nil or amount_min == nil or amount_max == nil then return end
	local loot = data.raw["simple-entity"][name].minable.results
	for k = 1, #loot do
		if loot[k].name == result.name then
			data.raw["simple-entity"][name].minable.results[k] = result
			return
		end
	end
	table.insert(data.raw["simple-entity"][name].minable.results,result)
end

if remote == nil then
	function register_underground_one_loot(results)
		for k=1, #rock_names do			
			local name = level_one_rock_prefix..t.name
			if results.name ~= nil then
				local_update_underground_loot(name,results)
			else
				for j=1, #results do
					local_update_underground_loot(name,results[j])
				end
			end			
		end
	end

	function register_underground_two_loot(results)
		for k=1, #rock_names do			
			local name = level_two_rock_prefix..t.name
			if results.name ~= nil then
				local_update_underground_loot(name,results)
			else
				for j=1, #results do
					local_update_underground_loot(name,results[j])
				end
			end			
		end
	end
end
