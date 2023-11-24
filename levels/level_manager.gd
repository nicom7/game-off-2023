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

var _processed_level_infos: Array[LevelInfo] = []

func get_current_level_info() -> LevelInfo:
	if current_level < 0 or current_level >= _processed_level_infos.size():
		return null

	return _processed_level_infos[current_level]

func _update_current_level() -> void:
	if is_node_ready():
		_current_level = clampi(_current_level, 0, _processed_level_infos.size() - 1)

func _generate_level_infos() -> void:
	_processed_level_infos.clear()
	for li in level_infos:
		# FIXME: HACK to force unique level info resources
		_processed_level_infos.append(li.duplicate())

func _ready() -> void:
	_generate_level_infos()
	_update_current_level()
