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

var _level_providers: Array[LevelProvider] = []

func get_current_level_provider() -> LevelProvider:
	if current_level < 0 or current_level >= _level_providers.size():
		return null

	return _level_providers[current_level]

func _update_current_level() -> void:
	if is_node_ready():
		_current_level = clampi(_current_level, 0, _level_providers.size() - 1)

func _generate_level_providers() -> void:
	_level_providers.clear()

	for li in level_infos:
		var provider: LevelProvider
		if li is RandomLevelInfo:
			# TODO: Check for existing notes sequence
			provider = RandomLevelGenerator.new()
			provider.level_info = li
		elif li is BasicLevelInfo:
			provider = BasicLevelProvider.new()
			provider.level_info = li

		provider.initialize()
		_level_providers.append(provider)

func _ready() -> void:
	_generate_level_providers()
	_update_current_level()
