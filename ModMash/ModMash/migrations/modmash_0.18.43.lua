for index, force in pairs(game.forces) do
  if force.technologies["enrichment-3"].researched then
    force.recipes["sulfur-coal-conversion"].enabled = true
	force.recipes["sulfur-titanium-conversion"].enabled = true
  end
end