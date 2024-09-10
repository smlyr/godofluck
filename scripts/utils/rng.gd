class_name RNG


static var rng: RandomNumberGenerator = RandomNumberGenerator.new()


static func set_seed(_seed: int) -> void:
    rng.seed = _seed


static func set_state(state: int) -> void:
    rng.state = state


static func randi_range(l: int, h: int) -> int:
    return rng.randi_range(l, h)
    

static func randf_range(l: float, h: float) -> float:
    return rng.randf_range(l, h)
