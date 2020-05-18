for index, force in pairs(game.forces) do
  if force.technologies["underground"].researched then
    force.recipes["recharged-battery-cell"].enabled = true
	force.recipes["battery-cell"].enabled = true
  end
end