extends Node2D

@export_range(1, 7) var stage_count: int = 7:
	set(value):
		if stage_count != value:
			stage_count = value
			_update_stages()

var player_tone: Globals.Tone
@export var ambient_note_player_scene: PackedScene
var ambient_note_player: NotePlayer

@onready var _camera: Camera2D = %Camera
var _bounding_rect: Rect2
var _overview_zoom: Vector2

var _stages: Array[Node] = []

func _setup_boundaries():
	for i in stage_count:
		for c in _stages[i].get_children():
			var ps: PlatformSet = c as PlatformSet
			if ps:
				_bounding_rect = _bounding_rect.merge(ps.get_bounding_rect())

	# Use center of overview rect as camera center
	%CameraCenter.global_position = _bounding_rect.get_center()

	# Adjust camera zoom to view all level
	_overview_zoom = Vector2(get_viewport_rect().size.x / _bounding_rect.size.x, get_viewport_rect().size.y / _bounding_rect.size.y)

	# Preserve aspect ratio
	_overview_zoom = Vector2.ONE * minf(_overview_zoom.x, _overview_zoom.y)

	_camera.set_target_node(%CameraCenter, true)
	_camera.set_target_zoom(_overview_zoom, true)
	_camera.zoom = _overview_zoom

func _setup_walls() -> void:
	$Environment/Walls/Floor.global_position = _bounding_rect.end
	$Environment/Walls/LeftWall.global_position = _bounding_rect.position
	$Environment/Walls/RightWall.global_position = _bounding_rect.end

func _setup_stages() -> void:
	_stages = $Environment/Stages.get_children()

func _update_stages() -> void:
	if not is_node_ready():
		return

	for s in _stages:
		$Environment/Stages.remove_child(s)

	for i in stage_count:
		$Environment/Stages.add_child(_stages[i])

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_stages()
	_update_stages()
	_setup_boundaries()
	_setup_walls()
	%BlockSequence.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


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
		_camera.set_target_node(%Player)
		_camera.set_target_zoom(Vector2.ONE)


func _on_block_sequence_sequence_finished(valid) -> void:
	_camera.drag_horizontal_enabled = false
	_camera.drag_vertical_enabled = false
	_camera.set_target_node(%CameraCenter)
	_camera.set_target_zoom(_overview_zoom)
