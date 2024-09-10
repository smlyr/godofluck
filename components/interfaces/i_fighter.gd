class_name IFighter
extends Node2D

@export var health: int:
    set(h):
        health = h
        if health_bar:
            health_bar.health = health


@export var max_health: int:
    set(mh):
        max_health = mh
        if health_bar:
            health_bar.max_health = max_health
            

@export var blocks: int:
    set(b):
        blocks = b
        if health_bar:
            health_bar.blocks = blocks


@onready var health_bar: HealthBar = find_child("HealthBar")


signal dead


func _ready() -> void:
    max_health = max_health
    health = health
    blocks = blocks
    health_bar.dead.connect(func(): dead.emit())
    

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
