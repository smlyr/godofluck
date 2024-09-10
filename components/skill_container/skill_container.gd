class_name SkillContainer
extends Node2D


signal energy_changed


@export var skill_proto: PackedScene
@export var capacity: int = 2
@export var energy: int = 1:
    set(e):
        energy = e
        if $Number:
            $Number.text = "%d" % energy
@export var skills_data: Array[SkillData]
@export var grid_container: GridContainer


func _ready() -> void:
    $Number.text = "%d" % energy
    grid_container.columns = capacity
    for skill_data in skills_data:
        var skill_ins = skill_proto.instantiate() as Skill
        skill_ins.data = skill_data
        skill_ins.skill_container = self
        add_skill(skill_ins)


func update_capacity(cap: int) -> void:
    capacity = cap
    grid_container.columns = capacity


func add_skill(skill: Skill) -> void:
    grid_container.add_child(skill)
    skill.skill_container = self
    energy_changed.connect(skill._container_enery_changed)


func remove_skill(skill: Skill) -> void:
    skill.queue_free()


func is_skill_full() -> bool:
    return grid_container.get_child_count() == capacity


func can_use(skill: Skill) -> bool:
    return skill.data.cost <= energy


func cost_energy(skill: Skill) -> void:
    energy -= skill.data.cost


func _on_combat_board_combat_finished() -> void:
    energy += 1
