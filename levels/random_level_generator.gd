class_name RandomLevelGenerator
extends LevelInfoProvider

@export var note_count_min: int = 2
@export var note_count_max: int = 7

const NOTES_PER_STAGE_COUNT_MAX: int = 2

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

	notes_per_stage_max = randi_range(1, NOTES_PER_STAGE_COUNT_MAX)

	var _stage_count_min = ceili(notes.size() / float(notes_per_stage_max))
	var _stage_count_max = notes.size()

	stage_count_max = randi_range(_stage_count_min, _stage_count_max)


func _load_scales() -> void:
	_scales.clear()

	var dir: DirAccess = DirAccess.open("res://levels/scales/")
	var resources = Globals.get_resources(dir)

	for r in resources:
		if r is ScaleInfo:
			var _notes = (r as ScaleInfo).notes
			if not _scales.has(_notes.size()):
				_scales[_notes.size()] = []
			_scales[_notes.size()].append(_notes)

	print(_scales)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_load_scales()
	generate()

	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
