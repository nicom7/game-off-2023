extends Node

static var _debug_settings_path: String

@export var enabled: bool = false

func _on_interactive_object_body_entered(body):
	if enabled:
		print(body, " entered ", get_parent())

func _on_interactive_object_body_exited(body):
	if enabled:
		print(body, " exited ", get_parent())

func _on_interactive_object_interacted(player, _interactive_object):
	if enabled:
		print(player, " interacted ", get_parent())
