class_name CombatDiceData
extends IDiceData


enum Action {
    Attack,
    Defend,
    Heal
}


@export var combat: int
@export var action: Action
# operate number
@export var operand: int
