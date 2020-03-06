for index, force in pairs(game.forces) do
    if force.technologies["enrichment-3"].researched then -- When the fluid-handling-3 is already researched, we need to enable the modmash-check-valve
	force.recipes["light-oil-conversion-crude-oil"].enabled = true
  end
end