class_name CombatDice
extends IDice



func _ready() -> void:
    super()


func update_appearance() -> void:
    var combat_data := data as CombatDiceData
    $Combat.text = "%d" % combat_data.combat
    var action: String
    match combat_data.action:
        CombatDiceData.Action.Attack:
            action = "⚔"
        CombatDiceData.Action.Heal:
            action = "⚕"
        CombatDiceData.Action.Defend:
            action = "🛡"
    $Bet.text = "%s%d" % [action, combat_data.operand]


func set_clickable_active(active: bool) -> void:
    $Sprite2D.modulate = Color.GREEN if active else Color.WHITE
