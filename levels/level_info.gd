class_name LevelInfo
extends Resource

## Maximum number of stages
@export_range(1, Globals.STAGE_COUNT_MAX) var stage_count_max: int = Globals.STAGE_COUNT_MAX
## Maximum number of notes per stage
@export_range(1, Globals.NOTES_PER_STAGE_MAX) var notes_per_stage_max: int = Globals.NOTES_PER_STAGE_MAX
## Maximum length of the block sequence to generate
@export_range(1, 99) var sequence_length_max: int = Globals.SEQUENCE_LENGTH_MAX
## The path of the scene to use for the level
@export_file("*.tscn") var level_scene_path: String = "res://levels/world_a.tscn"
## True to create a new level provider (and different stage notes) each time it is queried via get_current_level_provider()
@export var regenerate: bool = false
