class_name RandomLevelGenerator
extends LevelInfoProvider

@export var note_count_min: int = 2
@export var note_count_max: int = 7

var _scales: Dictionary = {}

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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
