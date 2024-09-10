class_name HealthBar
extends Node2D


signal dead


@export var max_health: int = 100:
    set(m):
        max_health = m
        $UnderBlood.max_value = max_health
        $OverBlood.max_value = max_health
        $Block.max_value = max_health
        if health > max_health:
            health = max_health


@export var health: int = 100:
    set(h):
        health = h
        _on_update_health()


@export var blocks: int = 0:
    set(b):
        blocks = b
        _on_update_blocks()


@onready var under_layer: TextureProgressBar = $UnderBlood
@onready var over_layer: TextureProgressBar = $OverBlood
@onready var block_layer: TextureProgressBar = $Block


func _ready() -> void:
    _on_update_health()
    _on_update_blocks()


var tween: Tween
func _on_update_health() -> void:
    $BloodNumber.text = "%d" % health
    if tween and tween.is_running():
        tween.stop()
        if block_layer.value != blocks:
            block_layer.value = blocks
    tween = create_tween()
    tween.tween_property(over_layer, "value", health, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
    tween.tween_property(under_layer, "value", health, 0.25).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _on_update_blocks() -> void:
    $BlockNumber.text = "%d" % blocks
    if tween and tween.is_running():
        tween.stop()
        if over_layer.value != health:
            over_layer.value = health
        if under_layer.value != health:
            under_layer.value = health
    tween = create_tween()
    tween.tween_property(block_layer, "value", blocks, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func reset() -> void:
    health = max_health
    blocks = 0


func take_damage(damage: int) -> void:
    if blocks > 0:
        var damage_blocks = min(damage, blocks)
        blocks -= damage_blocks
        damage -= damage_blocks
    if damage > 0:
        var damage_health = min(damage, health)
        health -= damage_health
        damage -= damage_health
        if health == 0:
            dead.emit()


func heal(amount: int) -> void:
    var heal_amount = min(amount, max_health - health)
    health += heal_amount


func reset_blocks() -> void:
    blocks = 0


func add_blocks(amount: int) -> void:
    blocks += amount
