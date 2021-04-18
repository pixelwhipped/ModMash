
require("prototypes.scripts.defines") 
local print  = modmashsplinterelectronics.util.print
local local_on_configuration_changed = function(event) 	
	
	 local changed = event.mod_changes and event.mod_changes["modmashsplinterelectronics"]
	
	if changed then
		if (changed.old_version == nil or changed.old_version < "1.1.4") and changed.new_version == "1.1.4" then
			print(changed)
			for index, force in pairs(game.forces) do
			  force.reset_technology_effects()
			end
		end
	 end
end

script.on_configuration_changed(local_on_configuration_changed)
