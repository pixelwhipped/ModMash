for index, force in pairs(game.forces) do
    if force.technologies["battery"].researched then
	force.recipes["underground-accumulator"].enabled = true
  end
end