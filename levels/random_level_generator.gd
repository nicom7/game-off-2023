class_name RandomLevelGenerator
extends LevelInfoProvider

@export var note_count_min: int = 2
@export var note_count_max: int = 7

## Will choose a random tonic note if scale degrees are included in the scale info resource
@export var random_tonic: bool = true
## Will choose a random inversion for the scale (e.g. [0, 4, 7, 10] => [4, 7, 10, 0])
@export var random_inversion: bool = true

const NOTES_PER_STAGE_MAX: int = 2
const STAGE_COUNT_MAX: int = 7

var _scales: Dictionary = {}

func generate() -> void:
	var scale_keys: Array = _scales.keys()

	scale_keys.sort()

	var beg_idx = scale_keys.bsearch(note_count_min)
	var end_idx = scale_keys.bsearch(note_count_max, false)

	scale_keys = scale_keys.slice(beg_idx, end_idx)
	var note_count = scale_keys.pick_random()
	var valid_scales = _scales[note_count]
	notes = valid_scales.pick_random()

	var _notes_per_stage_max = NOTES_PER_STAGE_MAX
	var _notes_per_stage_min = clampi(ceili(notes.size() / (STAGE_COUNT_MAX as float)), 1, _notes_per_stage_max)

	notes_per_stage_max = randi_range(_notes_per_stage_min, _notes_per_stage_max)

	var _stage_count_max = STAGE_COUNT_MAX
	var _stage_count_min = clampi(ceili(notes.size() / (notes_per_stage_max as float)), 1, _stage_count_max)

	stage_count_max = randi_range(_stage_count_min, _stage_count_max)


func _load_scales() -> void:
	_scales.clear()

	var dir: DirAccess = DirAccess.open("res://levels/scales/")
	var resources = Globals.get_resources(dir)

	for r in resources:
		if r is ScaleInfo:
			var si = r as ScaleInfo

			var _degrees = si.degrees
			if not _degrees.is_empty():
				if random_tonic:
					si.tonic = randi_range(0, Globals.Tone.size() - 1) as Globals.Tone
				if random_inversion:
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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_load_scales()
	generate()

	super._ready()
