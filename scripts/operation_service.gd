extends Node


func enable_operation(enabled: bool = true) -> void:
    for operation: Button in get_tree().get_nodes_in_group("Operation"):
        if operation.has_method("can_use"):
            operation.disabled = not (operation.can_use() and enabled)
        else:
            operation.disabled = not enabled
