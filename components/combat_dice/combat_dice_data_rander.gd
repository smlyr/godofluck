class_name CombatDiceDataRander
extends IDiceDataRander


@export var total_points: int


# Make a random dice data
func make_data() -> IDiceData:
    var dice := CombatDiceData.new()
    var combat := RNG.randi_range(0, total_points)
    dice.combat = combat
    var rest_points := total_points - combat
    @warning_ignore("int_as_enum_without_cast")
    dice.action = RNG.randi_range(0, CombatDiceData.Action.size() - 1)
    match dice.action:
        CombatDiceData.Action.Attack:
            dice.operand = rest_points
        CombatDiceData.Action.Defend:
            dice.operand = rest_points * 2
        CombatDiceData.Action.Heal:
            @warning_ignore("integer_division")
            dice.operand = rest_points / 2
            if rest_points % 2 == 1:
                dice.combat += 1
    return dice
