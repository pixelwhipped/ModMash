for index, force in pairs(game.forces) do
  if force.technologies["fluid-handling-2"].researched then -- When the fluid-handling-2 is already researched, we need to enable the modmash-check-valve
    force.recipes["mm-discharge-water-pump"].enabled = true
  end
end