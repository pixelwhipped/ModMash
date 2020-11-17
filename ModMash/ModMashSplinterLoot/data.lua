require ("prototypes.scripts.defines")
local loot_science_a = table.deepcopy(data.raw["simple-entity"]["crash-site-lab-broken"])
	loot_science_a.name = modmashsplinterloot.defines.names.loot_science_a
	loot_science_a.order = "zzzzz"
	loot_science_a.localised_name ="Crashed science lab"
	loot_science_a.max_health = 50
	loot_science_a.map_color = {r=1.0,g=0.45,b=0,a=1}

	local loot_science_b = table.deepcopy(data.raw["simple-entity"]["crash-site-lab-broken"])
	loot_science_b.name = modmashsplinterloot.defines.names.loot_science_b
	loot_science_b.order = "zzzzz"
	loot_science_b.localised_name ="Crashed science lab"
	loot_science_b.max_health = 50
	loot_science_b.map_color = {r=1.0,g=0.45,b=0,a=1}

	data.raw["container"]["crash-site-chest-1"].max_health = 50
	data.raw["container"]["crash-site-chest-2"].max_health = 50
	data.raw["container"]["crash-site-chest-1"].map_color = {r=1.0,g=0.45,b=0,a=1}
	data.raw["container"]["crash-site-chest-2"].map_color = {r=1.0,g=0.45,b=0,a=1}
	data:extend({loot_science_a,loot_science_b})