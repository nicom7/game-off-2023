class_name LevelManager
extends Node

@export var level_infos: Array[LevelInfo] = []
@export var avoid_duplicates: bool = true
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

	var li: LevelInfo = level_infos[current_level]
	return _create_level_provider(li) if li.regenerate else _level_providers[current_level]

func _update_current_level() -> void:
	if is_node_ready():
		_current_level = clampi(_current_level, 0, _level_providers.size() - 1)

func _create_level_provider(level_info: LevelInfo) -> LevelProvider:
	var provider: LevelProvider
	if level_info is RandomLevelInfo:
		provider = RandomLevelGenerator.new()
		provider.level_info = level_info
	elif level_info is BasicLevelInfo:
		provider = BasicLevelProvider.new()
		provider.level_info = level_info

	provider.sequence_length_max = level_info.sequence_length_max
	provider.level_scene_path = level_info.level_scene_path
	provider.initialize()

	return provider

func _generate_level_providers() -> void:
	_level_providers.clear()

	for li in level_infos:
		var provider: LevelProvider = _create_level_provider(li)

		const MAX_ATTEMPTS = 10
		var attempts = 0
		if avoid_duplicates:
			while _has_stage_notes(provider.stage_notes) and attempts < MAX_ATTEMPTS:
				provider = _create_level_provider(li)
				attempts += 1

		_level_providers.append(provider)

func _has_stage_notes(notes: Dictionary) -> bool:
	var notes_hash = notes.hash()
	for p in _level_providers:
		if notes_hash == p.stage_notes.hash():
			push_warning("stage notes already exists in list (", notes, " == ", p.stage_notes, ")")
			return true

	return false

func _ready() -> void:
	_generate_level_providers()
	_update_current_level()
