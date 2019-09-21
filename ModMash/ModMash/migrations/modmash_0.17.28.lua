for index, force in pairs(game.forces) do
  if force.technologies["enrichment-2"].researched then -- When the fluid-handling-2 is already researched, we need to enable the modmash-check-valve
    force.recipes["copper-enrichment-process"].enabled = true
  end
end