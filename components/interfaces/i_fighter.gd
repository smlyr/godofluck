class_name IFighter
extends Node2D

@onready var health_bar: HealthBar = find_child("HealthBar")
var max_health: int:
    set(v):
        health_bar.max_health = v
    get():
        return health_bar.max_health
var health: int:
    set(v):
        health_bar.health = v
    get():
        return health_bar.health
var blocks: int:
    set(v):
        health_bar.blocks = v
    get():
        return health_bar.blocks

signal dead


func _ready() -> void:
    health_bar.dead.connect(func():
        dead.emit()
        hide()
    )


func take_damage(damage: int) -> void:
    health_bar.take_damage(damage)


func heal(amount: int) -> void:
    health_bar.heal(amount)


func reset_blocks() -> void:
    health_bar.reset_blocks()


func reset_health() -> void:
    health_bar.reset()


func add_blocks(amount: int) -> void:
    health_bar.add_blocks(amount)
