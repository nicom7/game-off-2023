extends Node2D

@export var play_tutorial: bool = true

var _world: World
var _master_volume: float
@onready var _tutorial_active = play_tutorial
@onready var _level_manager: LevelManager = $LevelManager

func _create_world(_tutorial: bool):
	var provider: LevelProvider = _level_manager.get_current_level_provider()
	_world = load(provider.level_scene_path).instantiate()
	_world.level_provider = provider
	_world.current_state = World.GameState.INTRO
	_world.finished.connect(_on_world_finished, CONNECT_DEFERRED)
	add_child(_world)

func _destroy_world():
	remove_child(_world)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_create_world(play_tutorial)
	$HUD.show_title()
	$Transition.fade_in()


func _on_world_finished() -> void:
	_tutorial_active = false
	$HUD.skip_tutorial_visible = false
	$Transition.fade_out()


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


func _on_transition_finished(anim_name) -> void:
	match anim_name:
		"fade_in":
			_world.current_state = World.GameState.PLAYING
			$HUD.skip_tutorial_visible = _tutorial_active
		"fade_out":
			_destroy_world()
			$LevelManager.current_level += 1
			_create_world(false)
			$Transition.fade_in()


func _on_hud_skip_tutorial_pressed() -> void:
	_world.current_state = World.GameState.FINISHED
