--af ,f2,cc fail
--af,f2 pass
--af cc pass
--f2, af pass
--cc, f2 pass
--af pass
--f2 pass
--cc pass


modmash = { util = get_liborio() }
data_final_fixes = true
require("prototypes.entity.logistics")
require ("prototypes.scripts.types")

local table_contains = modmash.util.table.contains

local local_add_loot_to_entity = function(entityType, entityName, probability, countMin, countMax)
	if settings.startup["modmash-alien-loot-chance"].value == 0 then return end
    if data.raw[entityType] ~= nil then
        if data.raw[entityType][entityName] ~= nil then
            if data.raw[entityType][entityName].loot == nil then
                data.raw[entityType][entityName].loot = {}
            end
			local loot_probability = settings.startup["modmash-alien-loot-chance"].value/100.0
            table.insert(data.raw[entityType][entityName].loot, 
			{
				item = "alien-ore", probability = probability * loot_probability, count_min = countMin, count_max = countMax
			}
			)
			table.insert(data.raw[entityType][entityName].loot,
			{
				item = "alien-artifact", probability = (probability / 20) * loot_probability, count_min = 1, count_max = 1
			}
			)
        end
    end end

local local_create_entity_loot = function()
	if settings.startup["modmash-alien-loot-chance"].value == 0 then return end
	local max_health = 0
	for i,unit in pairs(data.raw["unit"]) do
		if unit.subgroup == "enemies" and unit.max_health then
			if unit.max_health > max_health then max_health = unit.max_health end
		end end

	for i,unit in pairs(data.raw["unit"]) do
		if unit.subgroup == "enemies" and unit.max_health then
			local min = (unit.max_health/max_health)*3
			local max = (unit.max_health/max_health)*50
			local_add_loot_to_entity("unit",unit.name,0.9,math.ceil(min),math.ceil(max))
		end end
	end

local_create_entity_loot()

--adjusting healing properties of fish as superseded by juice
--data.raw["capsule"]["raw-fish"].capsule_action.attack_parameters.ammo_type.action.action_delivery.target_effects.damage = {type = "physical", amount = -20}
local target_effects = data.raw["capsule"]["raw-fish"].capsule_action.attack_parameters.ammo_type.action.action_delivery.target_effects
if target_effects.damage then target_effects.damage = {type = "physical", amount = -20} end
if target_effects[1] and target_effects[1].type == "damage" then target_effects[1].damage = {type = "physical", amount = -20} end

function make_kill_all(obj)
  if type(obj) ~= 'table' then return obj end
  local s = {}
  local res = setmetatable({}, getmetatable(obj))
  s[obj] = res
  for k, v in pairs(obj) do
      if not (k == "force" or k == "affects_target") then
        res[make_kill_all(k)] = make_kill_all(v)
      end
  end
  return res
end
local local_convert_source_effect = function(landmine)
	if landmine.action == nil then return nil end
	if landmine.action.action_delivery == nil then return nil end
	if landmine.action.action_delivery.source_effects == nil then return nil end
	local effects = table.deepcopy(landmine.action.action_delivery.source_effects)
	effects = make_kill_all(effects)
	return effects
end

--[[
for k=1, 7 do
	if data.raw["tile"]["mm_dark-dirt-"..k] == nil then
		local t = table.deepcopy(data.raw["tile"]["dirt-"..k])
		t.name = "mm_dark-"..t.name
		if t.autoplace ~= nil then t.autoplace.default_enabled = false end
		t.tint = {0.15,0.15,0.15,1}
		data:extend({t})
	end
end]]


for _,landmine in pairs(data.raw["land-mine"]) do
	local e = local_convert_source_effect(landmine)
	if e ~= nil then 
		log("Updating "..landmine.name)
		--log(serpent.block(landmine))
		if landmine.flags ~= nil then
			if not table_contains(landmine.flags,"not-repairable") then table.insert(landmine.flags,"not-repairable") end	
		else 
			landmine.flags = {"not-repairable"}
		end
		landmine.create_ghost_on_death = false
		landmine.dying_explosion = nil
	--	log(serpent.block(e))
		landmine.dying_trigger_effect = e
		data.raw["land-mine"][landmine.name] = landmine
	else
		--modmash.util.log("Cannot Update "..landmine.name)
	end
end

--allow productivity for recipes
	
	
if settings.startup["modmash-setting-allow-production"].value == true then
	if mods["space-exploration"] then return end
	local add_productivity_recipes = {"light-oil-conversion-crude-oil"}
	for k, v in pairs(data.raw.module) do
		if v.name:find("productivity%-module") then
			if v.limitation ~= nil then
				for r = 1, #add_productivity_recipes do local prod = add_productivity_recipes[r]	
					table.insert(v.limitation,prod)
				end
			end
		end
	end


	for k, v in pairs(data.raw.beacon) do
		table.insert(v.allowed_effects, "productivity")
	end
end