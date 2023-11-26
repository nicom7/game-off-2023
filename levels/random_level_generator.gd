class_name RandomLevelGenerator
extends LevelProvider

@export var level_info: RandomLevelInfo

var _scales: Dictionary = {}

func initialize() -> void:
	generate()

func generate() -> Array[Globals.Tone]:
	_load_scales()
	var notes = _generate_notes()
	_update_stage_notes(level_info.stage_count_max, level_info.notes_per_stage_max, notes)
	return notes

func _generate_notes() -> Array[Globals.Tone]:
	var scale_keys: Array = _scales.keys()

	scale_keys.sort()

	var beg_idx = scale_keys.bsearch(level_info.note_count_min)
	var end_idx = scale_keys.bsearch(level_info.note_count_max, false)

	scale_keys = scale_keys.slice(beg_idx, end_idx)
	var note_count = scale_keys.pick_random()
	var valid_scales = _scales[note_count]
	var notes = valid_scales.pick_random()

	var _notes_per_stage_max = level_info.notes_per_stage_max
	var _notes_per_stage_min = clampi(ceili(notes.size() / (level_info.stage_count_max as float)), 1, _notes_per_stage_max)

	level_info.notes_per_stage_max = randi_range(_notes_per_stage_min, _notes_per_stage_max)

	var _stage_count_max = level_info.stage_count_max
	var _stage_count_min = clampi(ceili(notes.size() / (level_info.notes_per_stage_max as float)), 1, _stage_count_max)

	level_info.stage_count_max = randi_range(_stage_count_min, _stage_count_max)

	return notes

func _load_scales():
	var dir: DirAccess = DirAccess.open(level_info.scales_folder_path)
	var resources = Globals.get_resources(dir)

	for r in resources:
		if r is ScaleInfo:
			var si = r as ScaleInfo

			var _degrees = si.degrees
			if not _degrees.is_empty():
				if level_info.random_tonic:
					si.tonic = randi_range(0, Globals.Tone.size() - 1) as Globals.Tone
				if level_info.random_inversion:
					si.inversion = randi_range(0, _degrees.size() - 1)
				si.notes = _get_notes_from_degrees(_degrees, si.tonic, si.inversion)

			var _notes = si.notes
			if not _scales.has(_notes.size()):
				_scales[_notes.size()] = []
			_scales[_notes.size()].append(_notes)

	print(_scales)

func _get_notes_from_degrees(degrees: Array[int], tonic: Globals.Tone, inversion: int) -> Array[Globals.Tone]:
	var _notes: Array[Globals.Tone] = []
	for i in degrees.size():
		var offset_idx = (i + inversion) % degrees.size()
		_notes.append(Globals.get_note_from_degree(degrees[offset_idx], tonic))

	return _notes
