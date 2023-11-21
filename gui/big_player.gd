@tool
extends Control


func _on_resized() -> void:
	$Node2D.position = size / 2.0

func _ready() -> void:
	_on_resized()
