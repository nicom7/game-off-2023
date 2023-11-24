class_name BasicLevelInfo
extends LevelInfo

## Maximum number of stages
@export_range(1, Globals.STAGE_COUNT_MAX) var stage_count_max: int = Globals.STAGE_COUNT_MAX
## Maximum number of notes per stage
@export_range(1, Globals.NOTES_PER_STAGE_MAX) var notes_per_stage_max: int = Globals.NOTES_PER_STAGE_MAX
## Array of notes, from bottom stage to top stage, from left to right
@export var notes: Array[Globals.Tone] = []
