class_name World
extends Node2D

var player_tone: Globals.Tone
var player_octave: int

@export var ambient_note_player_scene: PackedScene
var ambient_note_player: NotePlayer

@export var level_info_provider: LevelInfoProvider
@export var tutorial: bool = false
@export var player_camera_zoom: Vector2 = Vector2.ONE

enum GameState
{
	INTRO,
	PLAYING,
	FINISHED
}

var current_state: GameState = GameState.PLAYING:
	set(value):
		if current_state != value:
			current_state = value
			_update_current_state()

signal finished()

@onready var _camera: Camera2D = %Camera
var _bounding_rect: Rect2
var _overview_zoom: Vector2

var _stages: Array[Node] = []

func _start() -> void:
	if tutorial:
		$MovementTutorial.show()
		$MovementTutorial.next_step()
	else:
		%BlockSequence.start()

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

	if %BlockSequence.active:
		_set_overview_camera(true)
	else:
		_set_player_camera(true)

func _setup_walls() -> void:
	$Environment/Walls/Floor.global_position = _bounding_rect.end
	$Environment/Walls/LeftWall.global_position = _bounding_rect.position
	$Environment/Walls/RightWall.global_position = _bounding_rect.end

func _update_current_state() -> void:
	if not is_node_ready():
		return

	match current_state:
		GameState.PLAYING:
			print("start!")
			_start()
		GameState.FINISHED:
			print("finished!")
			finished.emit()

func _setup_stages() -> void:
	%BlockSequence.switch_blocks.clear()

	_stages = $Environment/Stages.get_children()
	for s in _stages:
		$Environment/Stages.remove_child(s)

	var stage_notes: Dictionary
	if level_info_provider:
		stage_notes = level_info_provider.stage_notes

	var prev_tone: Globals.Tone = Globals.Tone.A
	var cur_octave: int = 0

	for i in stage_notes.size():
		var platform_sets = _get_platform_sets(_stages[i])
		for ps in platform_sets:
			_stages[i].remove_child(ps)
		for j in stage_notes[i].size():
			var cur_tone = stage_notes[i][j]
			if cur_tone < prev_tone:
				# Increase octave if tone is less than previous tone
				cur_octave += 1

			platform_sets[j].tone = cur_tone
			platform_sets[j].octave += cur_octave
			prev_tone = cur_tone

			%BlockSequence.switch_blocks.append_array(platform_sets[j].get_switch_blocks())
			_stages[i].add_child(platform_sets[j])
		$Environment/Stages.add_child(_stages[i])

	_adjust_octave(prev_tone, cur_octave)

func _adjust_octave(highest_tone: Globals.Tone, highest_octave: int) -> void:
	var octave_offset: int = 0

	if highest_octave > 0 and highest_tone > Globals.Tone.B:
		# Transpose one octave lower to avoid too high frequencies
		octave_offset -= 1

	for s in _stages:
		var platform_sets = _get_platform_sets(s)
		for ps in platform_sets:
			ps.octave += octave_offset

func _start_ambient_note(tone: Globals.Tone, octave: int) -> void:
	if not is_inside_tree():
		return

	_stop_ambient_note()
	ambient_note_player = ambient_note_player_scene.instantiate()
	ambient_note_player.tone = tone
	ambient_note_player.octave = octave
	add_child(ambient_note_player)
	ambient_note_player.start()

func _stop_ambient_note() -> void:
	if ambient_note_player:
		ambient_note_player.stop()
		ambient_note_player = null

func _set_player_camera(instant: bool = false) -> void:
	_camera.position_smoothing_enabled = true
	_camera.drag_horizontal_enabled = true
	_camera.drag_vertical_enabled = true
	_camera.set_target_node(%Player, instant)
	_camera.set_target_zoom(player_camera_zoom, instant)

func _set_overview_camera(instant: bool = false) -> void:
	_camera.drag_horizontal_enabled = false
	_camera.drag_vertical_enabled = false
	_camera.set_target_node(%CameraCenter, instant)
	_camera.set_target_zoom(_overview_zoom, instant)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_stages()
	_setup_boundaries()
	_setup_walls()
	_update_current_state()


func _on_player_current_tone_changed(tone: Globals.Tone) -> void:
	player_tone = tone
	if $Player.is_on_floor():
		_stop_ambient_note()
		_start_ambient_note(player_tone, player_octave)


func _on_player_current_octave_changed(octave: int) -> void:
	player_octave = octave
	if $Player.is_on_floor():
		_stop_ambient_note()
		_start_ambient_note(player_tone, player_octave)

func _on_player_on_floor_changed(value) -> void:
	if value:
		_start_ambient_note(player_tone, player_octave)
	else:
		_stop_ambient_note()


func _on_block_sequence_finished() -> void:
	current_state = GameState.FINISHED


func _on_block_sequence_sequence_played(demo_sequence: bool) -> void:
	if !demo_sequence:
		_set_player_camera()

		if tutorial:
			$MovementTutorial.hide()
			$BlockSequenceTutorial.show()


func _on_block_sequence_sequence_finished(_valid) -> void:
	_set_overview_camera()


func _on_movement_tutorial_finished() -> void:
	%BlockSequence.start()
