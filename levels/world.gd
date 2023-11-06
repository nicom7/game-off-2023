extends Node2D

var player_tone: Globals.Tone
@export var ambient_note_player_scene: PackedScene
var ambient_note_player: NotePlayer

@onready var _camera: Camera2D = %Camera2D
@onready var _camera_target: Node2D = %CameraCenter
@onready var _overview: Polygon2D = %Overview
var _overview_rect: Rect2
var _overview_zoom: Vector2

func _setup_overview():
	for v in _overview.polygon:
		_overview_rect = _overview_rect.expand(v)
	
	# Use center of overview rect as camera center
	%CameraCenter.global_position = _overview_rect.get_center()
	print("rect ", _overview_rect)
	
	# Adjust camera zoom to view all level
	_overview_zoom = Vector2(get_viewport_rect().size.x / _overview_rect.size.x, get_viewport_rect().size.y / _overview_rect.size.y)
	
	# Preserve aspect ratio
	_overview_zoom = Vector2.ONE * minf(_overview_zoom.x, _overview_zoom.y)
	print("zoom ", _overview_zoom)
	
	%Camera2D.zoom = _overview_zoom
	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_overview()
	%BlockSequence.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_camera.global_position = _camera_target.global_position


func _on_player_current_tone_changed(tone: Globals.Tone) -> void:
	player_tone = tone
	if ambient_note_player:
		ambient_note_player.tone = player_tone

func _on_player_on_floor_changed(value) -> void:
	if value:
		ambient_note_player = ambient_note_player_scene.instantiate()
		ambient_note_player.tone = player_tone
		add_child(ambient_note_player)
		ambient_note_player.start()
	else:
		ambient_note_player.stop()
		ambient_note_player = null


func _on_block_sequence_finished() -> void:
	print("finished!")
	%NewBlockSequenceTimer.start()


func _on_new_block_sequence_timer_timeout() -> void:
	%BlockSequence.start()


func _on_block_sequence_sequence_played(demo_sequence: bool) -> void:
	if !demo_sequence:
		_camera.position_smoothing_enabled = true
		_camera.drag_horizontal_enabled = true
		_camera.drag_vertical_enabled = true
		_camera_target = %Player
		%Camera2D.zoom = Vector2.ONE


func _on_block_sequence_sequence_finished(valid) -> void:
	_camera.drag_horizontal_enabled = false
	_camera.drag_vertical_enabled = false
	_camera_target = %CameraCenter
	%Camera2D.zoom = _overview_zoom
