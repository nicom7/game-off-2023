class_name RandomLevelInfo
extends LevelInfo

@export var note_count_min: int = 2
@export var note_count_max: int = 7

## Will choose a random tonic note if scale degrees are included in the scale info resource
@export var random_tonic: bool = true
## Will choose a random inversion for the scale (e.g. [0, 4, 7, 10] => [4, 7, 10, 0])
@export var random_inversion: bool = true

@export_dir var scales_folder_path: String = "res://levels/scales/"
