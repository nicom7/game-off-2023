extends Node2D

@export var play_tutorial: bool = true

var world_scene: PackedScene = preload("res://levels/world_a.tscn")
var world_tutorial_scene: PackedScene = preload("res://levels/tutorials/world_tutorial.tscn")
var _world: Node2D
var _master_volume: float

func _create_world(tutorial: bool):
	_world = (world_tutorial_scene if tutorial else world_scene).instantiate()
	_world.finished.connect(_on_world_finished, CONNECT_DEFERRED)
	add_child(_world)

func _destroy_world():
	remove_child(_world)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_create_world(play_tutorial)
	$HUD.show_title()


func _on_world_finished() -> void:
	_destroy_world()
	_create_world(false)


func _on_in_game_menu_closed() -> void:
	$InGameMenu.hide()
	$HUD.show()
	$PostFX.hide()

	AudioServer.set_bus_volume_db(0, _master_volume)
	await get_tree().create_timer(0.05).timeout

	get_tree().paused = false


func _on_hud_igm_pressed() -> void:
	get_tree().paused = true

	_master_volume = AudioServer.get_bus_volume_db(0)
	$HUD.hide()
	$InGameMenu.show()
	$PostFX.show()

	await get_tree().create_timer(0.05).timeout
	AudioServer.set_bus_volume_db(0, 0)
