data_final_fixes = true
require ("prototypes.scripts.defines")
local table_contains = modmashsplinterboom.util.table.contains

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

for _,landmine in pairs(data.raw["land-mine"]) do
	local e = local_convert_source_effect(landmine)
	if e ~= nil then 
		if landmine.flags ~= nil then
			if not table_contains(landmine.flags,"not-repairable") then table.insert(landmine.flags,"not-repairable") end	
		else 
			landmine.flags = {"not-repairable"}
		end
		landmine.create_ghost_on_death = false
		landmine.dying_explosion = nil
		landmine.dying_trigger_effect = e
		data.raw["land-mine"][landmine.name] = landmine
	end
end
