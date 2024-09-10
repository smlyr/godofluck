extends Node


func set_clickable_dice_active(active: bool):
    for clickable in get_tree().get_nodes_in_group("Clickable"):
        var dice := clickable.get_meta("owner") as IDice
        dice.set_clickable_active(active)
