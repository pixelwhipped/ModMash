for index, force in pairs(game.forces) do
    if force.technologies["fluid-handling-3"].researched then -- When the fluid-handling-3 is already researched, we need to enable the modmash-check-valve
	force.recipes["super-material"].enabled = true
	force.recipes["modmash-super-boiler-valve"].enabled = true
	force.recipes["super-material-crude"].enabled = true
	force.recipes["super-material-235"].enabled = true
  end
end