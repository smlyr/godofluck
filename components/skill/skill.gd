class_name Skill
extends Button


@export var data: SkillData
var skill_container: SkillContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    text = data.skill_name
    pressed.connect(use)
    _container_enery_changed()


func _container_enery_changed() -> void:
    disabled = not skill_container.can_use(self)


func can_use() -> bool:
    return skill_container.can_use(self)


func use() -> void:
    if not can_use():
        return
    if data.skill_name == "Reroll":
        _on_reroll()
    if data.skill_name == "DropOne":
        _on_drop_one()
    if data.skill_name == "PlusOne":
        _on_plus_one()
    skill_container.cost_energy(self)


func _on_plus_one():
    OperationService.enable_operation(false)
    ClickableService.set_clickable_dice_active(true)
    ClickService.active = true
    ClickService.clicked.connect(func(c):
        var dice := c.get_meta("owner") as IDice
        if dice is CombatDice:
            dice.data.combat += 1
        else:
            dice.data.number += 1
        dice.update_appearance()
        ClickableService.set_clickable_dice_active(false)
        OperationService.enable_operation(true), CONNECT_ONE_SHOT)


func _on_drop_one():
    OperationService.enable_operation(false)
    ClickableService.set_clickable_dice_active(true)
    ClickService.active = true
    ClickService.clicked.connect(func(c):
        var dice := c.get_meta("owner") as IDice
        var dq: Node = dice.get_parent()
        while dq is not DiceQueue:
            dq = dq.get_parent()
        (dq as DiceQueue).drop_one(dice)
        ClickableService.set_clickable_dice_active(false)
        OperationService.enable_operation(true), CONNECT_ONE_SHOT)


func _on_reroll():
    OperationService.enable_operation(false)
    ClickableService.set_clickable_dice_active(true)
    ClickService.active = true
    ClickService.clicked.connect(func(c):
        var dice := c.get_meta("owner") as IDice
        dice.reroll_once()
        ClickableService.set_clickable_dice_active(false)
        OperationService.enable_operation(true), CONNECT_ONE_SHOT)
