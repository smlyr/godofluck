class_name DiceQueue
extends Node2D


signal slide_finished


@export var size: Vector2
@export var dice_proto: PackedScene
@export var capacity: int
@export_enum("UP", "DOWN", "LEFT", "RIGHT")
var slide_direction_str: String
@export var dice_rander: IDiceDataRander


var slide_direction: Vector2
var slots: Array[Vector2]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    match slide_direction_str:
        "UP":
            slide_direction = Vector2(0, -1)
        "DOWN":
            slide_direction = Vector2(0, 1)
        "LEFT":
            slide_direction = Vector2(-1, 0)
        "RIGHT":
            slide_direction = Vector2(1, 0)
    $Sprite2D.scale = size
    calc_slots()
    for _i in capacity:
        enqueue()
        await call_adjust_anim(0.2)


func enqueue() -> void:
    var dice := dice_proto.instantiate() as IDice
    dice.rander = dice_rander
    $Dices.add_child(dice)
    dice.position = slots.back()
    

func dequeue() -> Node2D:
    var dice:Node2D = $Dices.get_child(0)
    dice.hide()
    dice.reparent($Dequeue)
    return dice


func slide() -> Node2D:
    var res = dequeue()
    enqueue()
    call_adjust_anim(0.5)
    return res


func call_adjust_anim(t: float) -> void:
    var tween := get_tree().create_tween().set_parallel(true)
    var i := 0
    for dice in $Dices.get_children():
        tween.tween_property(dice, "position", slots[i], t)
        i += 1
    await tween.finished
    slide_finished.emit()


func calc_slots() -> void:
    slots = []
    # ci is changing direction fi is fixed direction
    var ci: int = 1 if slide_direction[0] == 0 else 0
    var fi: = 1 - ci
    var cur_pos := Vector2(0, 0)
    cur_pos[fi] = size[fi] / 2
    cur_pos[ci] = size[ci] / capacity / 2
    var delta_pos := Vector2(0, 0)
    delta_pos[ci] = size[ci] / capacity
    if slide_direction[ci] > 0: # because the first is the head of queue in enumerating children
        cur_pos[ci] = size[ci] - cur_pos[ci]
        delta_pos[ci] = -delta_pos[ci]
    cur_pos -= size / 2
    for _i in capacity:
        slots.push_back(cur_pos)
        cur_pos += delta_pos
    slots.push_back(cur_pos)
