class_name CondDice
extends IDice



func _ready() -> void:
    super()


func update_appearance() -> void:
    var cond_data := data as CondDiceData
    $Number.text = "%d" % cond_data.number
