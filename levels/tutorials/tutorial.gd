class_name Tutorial
extends Node

@export var show_congrats: bool = true
signal finished

var _step: int = -1
var _texts: PackedStringArray = []
var _texts_web: PackedStringArray = []

signal step_changed(step: int)

func _get_texts() -> PackedStringArray:
	return _texts_web if OS.has_feature("web") else _texts

## Should be overridden by derived classes
func _init_texts() -> void:
	pass

func _format_texts() -> void:
	var new_texts: PackedStringArray = []
	for t in _texts:
		new_texts.append(Globals.format_input_actions(t))

	_texts = new_texts.duplicate()

	new_texts.clear()
	for t in _texts_web:
		new_texts.append(Globals.format_input_actions(t))

	_texts_web = new_texts.duplicate()

func _ready() -> void:
	_init_texts()
	_format_texts()

func current_step() -> int:
	return _step

func set_step(step: int) -> void:
	if step == _step:
		return

	_step = step
	step_changed.emit(_step)

	if _step >= _get_texts().size():
		if show_congrats:
			$Step/Label.text = "Well done!"
		finished.emit()
	elif _step >= 0:
		$Step/Label.text = _get_texts()[_step]

func next_step() -> void:
	set_step(_step + 1)
