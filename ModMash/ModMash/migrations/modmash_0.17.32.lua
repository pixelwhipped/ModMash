for index, force in pairs(game.forces) do
  if force.technologies["oil-processing"].researched then -- When the fluid-handling-4 is already researched, we need to enable the modmash-check-valve
    force.recipes["petroleum-gas-from-solid-fuel"].enabled = true	
  end
end