for index, force in pairs(game.forces) do
  if force.technologies["fluid-handling-3"].researched then -- When the fluid-handling-3 is already researched, we need to enable the modmash-check-valve
	force.recipes["steam-engine-mk2"].enabled = true
  end
end