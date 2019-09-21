for index, force in pairs(game.forces) do
  if force.technologies["enrichment-4"].researched then -- When the fluid-handling-4 is already researched, we need to enable the modmash-check-valve
	force.recipes["alien-artifact-enrichment-process-to-ore"].enabled = true
  end
end