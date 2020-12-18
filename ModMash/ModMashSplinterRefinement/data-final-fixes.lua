data_final_fixes = true
require("prototypes.scripts.defines") 
require ("prototypes.scripts.types")

local contains = modmashsplinterrefinement.util.table.contains

if contains(data.raw["assembling-machine"]["ore-refinery"].crafting_categories,"ore-refining") ~= true then
	table.insert(data.raw["assembling-machine"]["ore-refinery"].crafting_categories,"ore-refining")
end

if data.raw["assembling-machine"]["ore-refinery-2"] ~= nil and contains(data.raw["assembling-machine"]["ore-refinery-2"].crafting_categories,"ore-refining") ~= true then
	table.insert(data.raw["assembling-machine"]["ore-refinery-2"].crafting_categories,"ore-refining")
end