extends Node2D

var player_tone: Globals.Tone
@export var ambient_note_player_scene: PackedScene
var ambient_note_player: NotePlayer

@export var tutorial: bool = false

signal finished()
var _finished: bool = false

@onready var _camera: Camera2D = %Camera
var _bounding_rect: Rect2
var _overview_zoom: Vector2

var _stages: Array[Node] = []

func show_title() -> void:
	$Title.show()
	$Title/AnimationPlayer.play("fade_in")
	$Title/Timer.start()

func _get_platform_sets(stage: Node) -> Array[PlatformSet]:
	var platform_sets: Array[PlatformSet] = []
	for c in stage.get_children():
		var ps: PlatformSet = c as PlatformSet
		if ps:
			platform_sets.append(ps)

	return platform_sets

func _setup_boundaries():
	for i in $Environment/Stages.get_child_count():
		var sets = _get_platform_sets(_stages[i])
		for ps in sets:
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
	%BlockSequence.switch_blocks.clear()

	for s in _stages:
		$Environment/Stages.remove_child(s)

	var stage_notes: Dictionary
	if tutorial:
		stage_notes[0] = [Globals.Tone.C]
		stage_notes[1] = [Globals.Tone.G]
	else:
		stage_notes = $RandomLevelGenerator.stage_notes

	for i in stage_notes.size():
		var platform_sets = _get_platform_sets(_stages[i])
		for ps in platform_sets:
			_stages[i].remove_child(ps)
		for j in stage_notes[i].size():
			platform_sets[j].tone = stage_notes[i][j]
			%BlockSequence.switch_blocks.append_array(platform_sets[j].get_switch_blocks())
			_stages[i].add_child(platform_sets[j])
		$Environment/Stages.add_child(_stages[i])

func _start_ambient_note(tone: Globals.Tone) -> void:
	if _finished:
		return

	_stop_ambient_note()
	ambient_note_player = ambient_note_player_scene.instantiate()
	ambient_note_player.tone = tone
	add_child(ambient_note_player)
	ambient_note_player.start()

func _stop_ambient_note() -> void:
	if ambient_note_player:
		ambient_note_player.stop()
		ambient_note_player = null

func _fade_in() -> void:
	$Transition.fade_in()

func _fade_out() -> void:
	$Transition.fade_out()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_stages()
	_update_stages()
	_setup_boundaries()
	_setup_walls()
	_fade_in()


func _on_player_current_tone_changed(tone: Globals.Tone) -> void:
	player_tone = tone
	_stop_ambient_note()
	_start_ambient_note(player_tone)


func _on_player_on_floor_changed(value) -> void:
	if value:
		_start_ambient_note(player_tone)
	else:
		_stop_ambient_note()


func _on_block_sequence_finished() -> void:
	print("finished!")
	_finished = true
	_fade_out()


func _on_block_sequence_sequence_played(demo_sequence: bool) -> void:
	if !demo_sequence:
		_camera.position_smoothing_enabled = true
		_camera.drag_horizontal_enabled = true
		_camera.drag_vertical_enabled = true
		_camera.set_target_node(%Player)
		_camera.set_target_zoom(Vector2.ONE)

		if tutorial:
			$MovementTutorial.hide()
			$BlockSequenceTutorial.show()


func _on_block_sequence_sequence_finished(_valid) -> void:
	_camera.drag_horizontal_enabled = false
	_camera.drag_vertical_enabled = false
	_camera.set_target_node(%CameraCenter)
	_camera.set_target_zoom(_overview_zoom)


func _on_transition_finished(_anim_name: String) -> void:
	if _finished:
		finished.emit()
	elif tutorial:
		$MovementTutorial.show()
		$MovementTutorial.next_step()
	else:
		%BlockSequence.start()


func _on_title_timer_timeout() -> void:
	$Title/AnimationPlayer.play("fade_out")


func _on_movement_tutorial_finished() -> void:
	%BlockSequence.start()
