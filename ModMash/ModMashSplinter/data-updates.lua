require("prototypes.scripts.defines") 
require("prototypes.scripts.util") 

for i,inserter in pairs(data.raw["inserter"]) do
	inserter.allow_custom_vectors = true
end
