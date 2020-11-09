for index, force in pairs(game.forces) do
  if force.technologies["fluid-handling-2"].researched then -- When the fluid-handling-2 is already researched, we need to enable the modmash-check-valve
    force.recipes["modmash-overflow-valve"].enabled = true
	force.recipes["modmash-underflow-valve"].enabled = true
	force.recipes["condenser-valve"].enabled = true
	force.recipes["mini-boiler"].enabled = true
  end
  if force.technologies["engine"].researched then
    if force.recipes["droid-chest"] ~= nil then force.recipes["droid-chest"].enabled = true end
	if force.recipes["droid"] ~= nil then force.recipes["droid"].enabled = true end
	--force.recipes["enhance-drone-targeting-1"].enabled = true
  end
  if force.technologies["logistics"].researched then
    if force.recipes["mini-loader"] ~= nil then force.recipes["mini-loader"].enabled = true end
  end
end