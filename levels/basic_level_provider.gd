class_name BasicLevelProvider
extends LevelProvider

@export var level_info: BasicLevelInfo

func initialize() -> void:
	_update_stage_notes(level_info.stage_count_max, level_info.notes_per_stage_max, level_info.notes)
