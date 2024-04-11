class_name Character
extends CharacterBody2D

@export var speed: float = 300.0
@export var jump_speed: float = -400.0

@export var jump_note_player_scene: PackedScene

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

var jump_note_player: NotePlayer

var color: Color = Color.WHITE:
	set(value):
		color = value
		_update_color()

class InputActions:
	var move_left: String
	var move_right: String
	## Notes bitfield for the climb up action
	var move_up: int
	## Notes bitfield for the climb down action
	var move_down: int
	## Notes bitfield for the jump action
	var jump: int

var _input_actions: Dictionary = {}
const _scale: Array[String] = ["A", "B", "C", "D", "E", "F", "G"]
var current_tone: Globals.Tone = Globals.Tone.A:
	get:
		return current_tone
	set(value):
		if current_tone != value:
			current_tone = value
			color = Config.tone_colors[current_tone]
			current_tone_changed.emit(current_tone)

var current_octave: int = 0:
	get:
		return current_octave
	set(value):
		if current_octave != value:
			current_octave = value
			current_octave_changed.emit(current_octave)

signal current_tone_changed(tone: Globals.Tone)
signal current_octave_changed(octave: int)

var on_floor: bool = false:
	get:
		return on_floor
	set(value):
		if on_floor != value:
			on_floor = value
			if on_floor:
				exit_climb()
			on_floor_changed.emit(on_floor)

var climbing: bool = false
var jumping: bool = false
var current_ladder: Ladder
var current_input_actions: InputActions

@onready var _keyboard_controller: KeyboardController = $KeyboardController
var _previous_direction: Vector2

signal on_floor_changed(value: bool)
signal direction_changed(direction: float)
## Emitted when player jumps. notes: bitfield containing the currently pressed notes
signal jumped(notes: int)
signal interact(player: Character, notes: int)

func enter_climb(ladder: Ladder) -> void:
	if not climbing:
		climbing = true
		current_ladder = ladder
#		print("enter climb")

func exit_climb() -> void:
	if climbing:
		climbing = false
		current_ladder = null
#		print("exit climb")

func _update_color():
	if is_node_ready():
		%MusicBoy.modulate = color

func _ready() -> void:
	color = Config.tone_colors[current_tone]
	_setup_input_actions()

func _setup_input_actions():
	_keyboard_controller.notes_changed.connect(_on_keyboard_controller_notes_changed)
	_input_actions.clear()
	for note in Globals.Tone.size():
		var actions: InputActions = InputActions.new()
		actions.move_left = "ui_left"
		actions.move_right = "ui_right"
		actions.jump = Globals.get_bitfield_from_notes([note as Globals.Tone])

		_input_actions[note] = actions

func _physics_process(delta: float) -> void:
	_update_movement(delta)

func _update_movement(delta: float) -> void:
	on_floor = is_on_floor()

	if climbing:
		current_input_actions = InputActions.new()
		current_input_actions.move_up = current_ladder.climb_up_notes
		current_input_actions.move_down = current_ladder.climb_down_notes
	else:
		current_input_actions = _input_actions[current_tone]

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

	if jumping:
		# Handle jump
		jumping = false
		velocity.y = jump_speed
	elif not on_floor:
		# Add the gravity.
		velocity.y += gravity * delta

	var direction: Vector2 = Vector2.ZERO

	if climbing:
		direction.y = _keyboard_controller.get_action_strength(current_input_actions.move_down) - _keyboard_controller.get_action_strength(current_input_actions.move_up)
		if direction.y:
			velocity.y = direction.y * speed
		else:
			velocity.y = move_toward(velocity.y, 0, speed)
		velocity.x = 0
	else:
		direction.x = Input.get_axis(current_input_actions.move_left, current_input_actions.move_right)
		if direction.x:
			velocity.x = direction.x * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)

	if direction != _previous_direction:
		direction_changed.emit(direction)
		_previous_direction = direction

	_update_animations()

	move_and_slide()

func _update_jump(prev_notes: int, cur_notes: int) -> void:
	if not climbing:
		# Prevent jumping if releasing a key that will lead to the jump notes, e.g. [5, 6] => [5]
		if on_floor and prev_notes < cur_notes and cur_notes == current_input_actions.jump:
			jumped.emit(cur_notes)

func _update_animations() -> void:
	var anim_pos  = %AnimationPlayer.current_animation_position

	if velocity.y != 0:
		if velocity.x > 0:
			%AnimationPlayer.current_animation = "jump_right"
		elif velocity.x < 0:
			%AnimationPlayer.current_animation = "jump_left"
		else:
			%AnimationPlayer.current_animation = "jump_center"
	else:
		if velocity.x > 0:
			%AnimationPlayer.current_animation = "bounce_right"
		elif velocity.x < 0:
			%AnimationPlayer.current_animation = "bounce_left"
		else:
			%AnimationPlayer.current_animation = "bounce_center"

	%AnimationPlayer.seek(anim_pos)

#	print("current anim = ", %AnimationPlayer.current_animation, " ", %AnimationPlayer.current_animation_position)

func _on_jumped(_notes: int) -> void:
	jumping = true
	jump_note_player = jump_note_player_scene.instantiate()
	jump_note_player.tone = current_tone
	jump_note_player.octave = current_octave
	add_child(jump_note_player)
	jump_note_player.start()


func _on_tile_detector_area_tone_changed(tone) -> void:
	current_tone = tone


func _on_tile_detector_area_octave_changed(octave) -> void:
	current_octave = octave


func _on_keyboard_controller_notes_changed(prev_notes: int, cur_notes: int) -> void:
	interact.emit(self, cur_notes)

	_update_jump(prev_notes, cur_notes)
