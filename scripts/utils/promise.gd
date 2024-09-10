class_name Promise

signal completed(args) # array

enum MODE {ANY, ALL}
var mode: int = MODE.ANY

var _has_emitted: Dictionary = {} # signal: {has_emitted: bool, data: any}
var _completed: bool = false


func _init(signals: Array[Signal], _mode: int) -> void:
    mode = _mode
    for s in signals:
        s.connect(func():
            _has_emitted[s] = true
            _check_completion(), CONNECT_ONE_SHOT)
        _has_emitted[s] = false


func _check_completion():
    if _completed:
        return
    if mode == MODE.ANY:
        _check_any_completion()
    elif mode == MODE.ALL:
        _check_all_completion()


func _check_any_completion() -> void:
    for s in _has_emitted.keys():
        if _has_emitted[s]:
            completed.emit()


func _check_all_completion() -> void:    
    for s in _has_emitted.keys():
        if not _has_emitted[s]:
            return
    completed.emit()
    
    
