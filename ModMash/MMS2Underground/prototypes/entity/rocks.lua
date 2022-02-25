require("prototypes.scripts.defines") 
local get_name_for = mms2underground.util.get_name_for
local level_one_rock_prefix  = mms2underground.defines.names.level_one_rock_prefix
local dirt_prefix  = mms2underground.defines.names.dirt_prefix
local rock_names  = mms2underground.defines.names.rock_names
local level_one_attack_rock = mms2underground.defines.names.level_one_attack_rock

local local_generate_rocks = function(prefix,tint)
	for k=1, #rock_names do
		local name = prefix..rock_names[k]
		if data.raw["simple-entity"][name] == nil then
			local r = table.deepcopy(data.raw["simple-entity"][rock_names[k]])
			r.name = name
			r.loot = nil
			r.dying_trigger_effect = nil
			if r.autoplace ~= nil then r.autoplace.default_enabled = false end
			r.max_health = r.max_health/3
			r.minable =
			{
			  mining_particle = "stone-particle",
			  mining_time = 0.75,
			  results = {{name = "stone", amount_min = 1, amount_max = 8, probability = 0.5}},
			}
			for j=1, #r.pictures do
				r.pictures[j].tint = tint
				if r.pictures[j].hr_version then
					r.pictures[j].hr_version.tint = tint
				end
			end
			data:extend({r})
		end
	end
end

local_generate_rocks(level_one_rock_prefix, {0.8,0.8,0.8,1.0})