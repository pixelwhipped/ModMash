local newtile = table.deepcopy(data.raw.tile["out-of-map"])
newtile.name = "underground-out-of-map"
newtile.localised_name = {"tile-name.out-of-map"}
newtile.localised_description = {"tile-description.out-of-map"}
newtile.pollution_absorption_per_second = .000008

data:extend{newtile}