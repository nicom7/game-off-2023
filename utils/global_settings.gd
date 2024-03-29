extends Node

var _settings: Dictionary = {}

@export var settings_info: SettingsInfo = preload("res://utils/default_settings.tres")
@export var settings_path: String = "user://global_settings.cfg"

var _config: ConfigFile = ConfigFile.new()

func _init():
	load_settings()

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_settings()

func set_setting(path: String, n: String, value: Variant):
	_settings[path][n] = value
	save_settings()

func get_setting(path: String, n: String) -> Variant:
	return _settings[path][n]

func load_settings():
	_settings = settings_info.values
	if _config.load(settings_path) == OK:
		for section in _settings.keys():
			var section_settings = _settings[section]
			for setting in section_settings.keys():
				section_settings[setting] = _config.get_value(section, setting, section_settings[setting])

func save_settings():
	for section in _settings.keys():
		var section_settings = _settings[section]
		for setting in section_settings.keys():
			_config.set_value(section, setting, section_settings[setting])

	_config.save(settings_path)
