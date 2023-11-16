class_name Tutorial
extends Node

signal finished

var _step: int = -1

func current_step() -> int:
	return _step

func set_step(step: int) -> void:
	_step = step
	if _step >= _get_texts().size():
		$Step/Label.text = "Well done!"
		finished.emit()
	elif _step >= 0:
		$Step/Label.text = _get_texts()[_step]

func next_step() -> void:
	set_step(_step + 1)

## Should be overridden by derived classes
func _get_texts() -> PackedStringArray:
	return []
