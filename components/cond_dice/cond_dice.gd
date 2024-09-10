class_name CondDice
extends IDice



func _ready() -> void:
    super()


func update_appearance() -> void:
    var cond_data := data as CondDiceData
    $Number.text = "%d" % cond_data.number


func set_clickable_active(active: bool) -> void:
    $Sprite2D.modulate = Color.GREEN if active else Color.WHITE
