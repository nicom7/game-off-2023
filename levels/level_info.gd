class_name LevelInfo
extends Resource

## Maximum number of stages
@export_range(1, Globals.STAGE_COUNT_MAX) var stage_count_max: int = Globals.STAGE_COUNT_MAX
## Maximum number of notes per stage
@export_range(1, Globals.NOTES_PER_STAGE_MAX) var notes_per_stage_max: int = Globals.NOTES_PER_STAGE_MAX
## Maximum length of the block sequence to generate
@export_range(1, 99) var sequence_length_max: int = 4
