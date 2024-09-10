class_name IDice
extends Node2D


@export var rander: IDiceDataRander
@export var clickable: Node
@export var data: IDiceData


func init_data_if_not_set() -> void:
    if not data:
        data = rander.make_data()
    update_appearance()


func reroll_once() -> void:
    if not rander:
        print("no rander")
        return
    data = rander.make_data()
    update_appearance()


func update_appearance() -> void:
    print("Implement by subclass")


# may include rotate and other effects
func reroll() -> void:
    print("Implement by subclass")


func unclickable() -> void:
    if clickable:
        clickable.remove_from_group("Clickable")


func set_clickable_active(_active: bool) -> void:
    pass


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    if clickable:
        clickable.add_to_group("Clickable")
        clickable.set_meta("owner", self)
    init_data_if_not_set()
