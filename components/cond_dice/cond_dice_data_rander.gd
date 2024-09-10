class_name CondDiceDataRander
extends IDiceDataRander


@export var max_number: int = 6


# Make a random dice data
func make_data() -> IDiceData:
    return CondDiceData.new(RNG.randi_range(1, max_number))
