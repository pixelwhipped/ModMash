
local surfaces = game.surfaces
for _, surface in pairs(surfaces) do
	local top
	if string.find(surface.name, "%-deep%-underground$") then
		top = string.gsub(surface.name, "%-deep%-underground$", "")
	elseif string.find(surface.name, "%-underground$") then
		top = string.gsub(surface.name, "%-underground$", "")
	end

	if top and surfaces[top] then
		for chunk in surface.get_chunks() do
			--replace a chunk at a tile to avoid blowing up ram
			--does not replace hidden out-of-map tiles (Honktown - I don't think there is a way to replace them...)
			local tiles = surface.find_tiles_filtered{area = chunk.area, name = "out-of-map"}
			local to_set = {}
			for _, tile in pairs(tiles) do
				table.insert(to_set, {position = tile.position, name = "underground-out-of-map"})
			end
			if #to_set > 0 then
				surface.set_tiles(to_set, true, false)
			end
		end
	end
end