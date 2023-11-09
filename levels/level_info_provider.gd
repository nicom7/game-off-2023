extends Node

@export_range(1, 99) var stage_count: int = 7
@export_range(1, 99) var notes_per_stage_max: int = 1
@export var notes: Array[Globals.Tone] = []

var _stage_notes: Dictionary = {}

func get_stage_notes(stage: int) -> Array[Globals.Tone]:
	return _stage_notes[stage]


func _update_stage_notes():
	_stage_notes.clear()
	var remaining_notes = notes.duplicate()

	for i in stage_count:
		_stage_notes[i] = []
		for j in notes_per_stage_max:
			_stage_notes[i].append(remaining_notes.pop_front())
			if remaining_notes.size() < stage_count - i:
				break
		if remaining_notes.is_empty():
			break

	print(_stage_notes)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_stage_notes()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
