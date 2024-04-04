extends TabContainer

func _ready() -> void:
	# HACK: Temporary fix for misaligned tabs. Will be fixed in 4.2.2.
	# https://github.com/godotengine/godot/pull/88293
	add_theme_font_size_override("font_size", 24)
	update_minimum_size()
