class_name LevelManager
extends Node

@export var level_infos: Array[LevelInfo] = []
@export var current_level: int = 0:
	get:
		return _current_level
	set(value):
		_current_level = value
		_update_current_level()
var _current_level: int

func get_current_level_provider() -> LevelInfoProvider:
	if current_level < 0 or current_level >= level_infos.size():
		return null

	var _level_provider = LevelInfoProvider.new()
	_level_provider.stage_count_max = level_infos[current_level].stage_count_max
	_level_provider.notes_per_stage_max = level_infos[current_level].notes_per_stage_max
	_level_provider.notes = level_infos[current_level].notes

	return _level_provider

func _update_current_level() -> void:
	if is_node_ready():
		_current_level = clampi(_current_level, 0, level_infos.size() - 1)

func _ready() -> void:
	_update_current_level()
