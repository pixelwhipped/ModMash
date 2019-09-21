for index, force in pairs(game.forces) do
  if force.technologies["logistics"].researched then -- When the logistics is already researched, we need to enable the modmash-check-valve
    force.recipes["modmash-check-valve"].enabled = true
  end
end