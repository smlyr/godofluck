extends Node

var active: bool = false
signal clicked(clickable)


func _unhandled_input(event: InputEvent) -> void:
    if not active:
        return
    var clickables = get_tree().get_nodes_in_group("Clickable")
    if event is InputEventMouseButton and event.is_pressed():
        if (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT:
            for clickable: Node2D in clickables:
                if clickable.get_rect().has_point(clickable.to_local(event.global_position)):
                    active = false
                    clicked.emit(clickable)
