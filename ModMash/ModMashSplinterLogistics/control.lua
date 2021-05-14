require("prototypes.scripts.defines") 
if not global.modmashsplinterlogistics then global.modmashsplinterlogistics = {} end

require("prototypes.scripts.loader") 
require("prototypes.scripts.inserters") 

local local_on_configuration_changed = function(event) 	
	
	 local changed = event.mod_changes and event.mod_changes["modmashsplinterlogistics"]
	if changed then
		if (changed.old_version == nil or changed.old_version < "1.1.9")  then
		
			for index, force in pairs(game.forces) do
			  force.reset_technology_effects()
			end
		end
	 end
end

script.on_configuration_changed(local_on_configuration_changed)