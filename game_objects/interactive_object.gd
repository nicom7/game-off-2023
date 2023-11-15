class_name InteractiveObject
extends Area2D

var interact_notes: int
var entered_objects: Dictionary

signal interacted(player: Character, interactive_object: InteractiveObject)

func _on_body_entered(body):
	entered_objects[body] = body
	if body is Character:
		var player = body as Character
		player.interact.connect(_on_player_interact)

func _on_body_exited(body):
	entered_objects.erase(body)
	if body is Character:
		var player = body as Character
		player.interact.disconnect(_on_player_interact)

func _on_player_interact(player: Character, notes: int):
	if interact_notes == notes:
		interacted.emit(player, self)
