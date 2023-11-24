class_name LevelInfo
extends Resource

# TODO: Move to LevelProvider
var stage_notes: Dictionary:
	get:
		if _stage_notes.is_empty():
			_update_stage_notes()
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
# END TODO
