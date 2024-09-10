class_name CombatBoard
extends Node2D


signal combat_finished
signal deal_started(win: int, data: CombatDiceData)


@export var cond_queue: DiceQueue
@export var queue_pair: Array[DiceQueue]
@export var height: float
@export var n_combats: int:
    set(n):
        n_combats = n
        calc_slots()
@onready var branches: Array[Node2D] = [$Left, $Right]


var slots: Array[Vector2]
var combat_data: Array[CombatDiceData]
var scores: Array[int] = [0, 0]
var win:int


func _ready() -> void:
    var sigs: Array[Signal] = [queue_pair[0].first_fill_finished,
            queue_pair[1].first_fill_finished]
    if cond_queue:
        sigs.push_back(cond_queue.first_fill_finished)
    OperationService.enable_operation(false)
    await Promise.new(sigs, 1).completed
    OperationService.enable_operation(true)


func clear_board() -> void:
    for i in 2:
        for dice in branches[i].get_children():
            dice.queue_free()
    combat_data.clear()
    scores = [0, 0]


func calc_slots() -> void:
    slots = []
    for i in n_combats:
        slots.push_back(Vector2(0,
                height / (2*n_combats) * (1+2*i) - height / 2))


signal dice_pair_placed


func add_dice_pair_once() -> void:
    @warning_ignore("integer_division")
    var idx := combat_data.size() / 2
    var dice_pair: Array[CombatDice]
    for i in 2:
        dice_pair.append(queue_pair[i].slide())
        combat_data.push_back(dice_pair.back().data)
        dice_pair[i].reparent(branches[i])
        dice_pair[i].show()
    var tween := get_tree().create_tween().set_parallel()
    for i in 2:
        tween.tween_property(dice_pair[i], "position", slots[idx], 0.2)
    await tween.finished
    await pair_combat(dice_pair)
    dice_pair_placed.emit()


func pair_combat(dices: Array[CombatDice]) -> void:
    var datas :Array[CombatDiceData] = [dices[0].data, dices[1].data]
    if datas[0].combat > datas[1].combat:
        win = 0
    elif datas[0].combat < datas[1].combat:
        win = 1
    else:
        win = -1
        return
    scores[win] += 1
    var tween = get_tree().create_tween().set_parallel()
    tween.tween_property(dices[win], "scale", Vector2(1.1, 1.1), 0.1)
    tween.tween_property(dices[1-win], "scale", Vector2(0.9, 0.9), 0.1)
    await tween.finished


func combat() -> void:
    clear_board()
    if cond_queue:
        var cond: CondDice = cond_queue.slide()
        var cond_data := cond.data as CondDiceData
        n_combats = cond_data.number
        cond.queue_free()
    for _i in n_combats:
        add_dice_pair_once()
        await Promise.new([queue_pair[0].slide_finished, queue_pair[1].slide_finished,
                dice_pair_placed], 1).completed
    if win != -1:
        var lose_root: Node2D = branches[1-win]
        for dice in lose_root.get_children():
            dice.queue_free()
        var win_root: Node2D = branches[1-win]
        var tween = get_tree().create_tween()
        var combat_data_idx := win
        for dice in win_root.get_children():
            tween.tween_property(dice, "scale", Vector2(1.2, 1.2), 0.2)
            deal_started.emit(win, combat_data[combat_data_idx])
            combat_data_idx += 2
        await tween.finished
        combat_finished.emit()
    else:
        # Draw
        combat_finished.emit()
