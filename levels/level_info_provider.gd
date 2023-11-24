class_name LevelInfoProvider
extends Node

## Maximum number of stages
@export_range(1, Globals.STAGE_COUNT_MAX) var stage_count_max: int = Globals.STAGE_COUNT_MAX
## Maximum number of notes per stage
@export_range(1, Globals.NOTES_PER_STAGE_MAX) var notes_per_stage_max: int = Globals.NOTES_PER_STAGE_MAX
## Array of notes, from bottom stage to top stage, from left to right
@export var notes: Array[Globals.Tone] = []

var stage_notes: Dictionary:
	get:
		return _stage_notes

var _stage_notes: Dictionary = {}

func _update_stage_notes():
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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_stage_notes()
