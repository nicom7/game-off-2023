extends Node

var version_str: String:
	get:
		return _version_str
	set(_value):
		pass

var _version_str: String

# Called when the node enters the scene tree for the first time.
func _ready():
	var config = ConfigFile.new()
	if config.load("res://version.cfg") == OK:
		_version_str = config.get_value("application", "config/version", "")
		if OS.is_debug_build():
			_version_str += " [DEBUG]"
		ProjectSettings.set_setting("application/config/version", _version_str)
	else:
		printerr("Can't open version.cfg file")
