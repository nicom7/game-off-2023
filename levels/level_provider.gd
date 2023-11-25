class_name LevelProvider
extends Node

var stage_notes: Dictionary:
	get:
		return _stage_notes

var _stage_notes: Dictionary = {}

func initialize() -> void:
	pass

func _update_stage_notes(stage_count_max: int, notes_per_stage_max: int, notes: Array[Globals.Tone]):
	_stage_notes.clear()
	var remaining_notes = notes.duplicate()

	for i in stage_count_max:
		_stage_notes[i] = []
		for j in notes_per_stage_max:
			_stage_notes[i].append(remaining_notes.pop_front())
			if remaining_notes.size() < stage_count_max - i:
				break
		if remaining_notes.is_empty():
			break

	print(_stage_notes)

func _ready() -> void:
	initialize()
