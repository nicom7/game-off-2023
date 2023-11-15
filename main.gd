extends Node2D

var world_scene: PackedScene = preload("res://levels/world_a.tscn")
var _world: Node2D

func _create_world():
	_world = world_scene.instantiate()
	_world.finished.connect(_on_world_finished, CONNECT_DEFERRED)
	add_child(_world)

func _destroy_world():
	remove_child(_world)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_create_world()

func _on_world_finished() -> void:
	_destroy_world()
	_create_world()
