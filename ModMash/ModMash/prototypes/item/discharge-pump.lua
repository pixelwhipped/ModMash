data:extend(
{
  {
    type = "item",
    name = "mm-discharge-water-pump",
	localised_name = "Discharge Pump",
	localised_description = "Discharges excess fluid.  Will cause pollution depending on fluid type",
    icon = "__modmash__/graphics/icons/discharge-pump.png",
    icon_size = 32,
    subgroup = "extraction-machine",
    order = "b[fluids]-a[pffshore-pump]",
    place_result = "mm-discharge-water-pump",
    stack_size = 50
  },
})