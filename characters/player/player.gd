class_name Character
extends CharacterBody2D

@export var speed: float = 300.0
@export var jump_speed: float = -400.0

@export var jump_note_player_scene: PackedScene

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

var jump_note_player: NotePlayer

class InputActions:
	var move_left: String
	var move_right: String
	var move_up: String
	var move_down: String
	var jump: String

var _input_actions: Dictionary = {}
const _scale: Array[String] = ["A", "B", "C", "D", "E", "F", "G"]
var current_tone: Globals.Tone = Globals.Tone.A:
	get:
		return current_tone
	set(value):
		if current_tone != value:
			current_tone = value
			current_tone_changed.emit(current_tone)

signal current_tone_changed(tone: Globals.Tone)

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
var current_ladder: Ladder

signal on_floor_changed(value: bool)
signal jumped
signal interact(player: Character, action: String)

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

func _ready() -> void:
	_setup_input_actions()

func _setup_input_actions():
	_input_actions.clear()
	for note in _scale.size():
		var actions: InputActions = InputActions.new()
		actions.move_left = "ui_left"
		actions.move_right = "ui_right"
		actions.jump = _scale[note] + "_note"

		_input_actions[note] = actions

func _physics_process(delta: float) -> void:
	_update_movement(delta)

func _input(event: InputEvent):
	for tone in Globals.Tone.size():
		var action = Globals.get_action_from_tone(tone)
		if event.is_action_pressed(action):
			interact.emit(self, action)
			return

func _update_movement(delta: float) -> void:
	var current_input_actions: InputActions

	on_floor = is_on_floor()

	if climbing:
		current_input_actions = InputActions.new()
		current_input_actions.move_up = current_ladder.climb_up_action
		current_input_actions.move_down = current_ladder.climb_down_action
	else:
		current_input_actions = _input_actions[current_tone]

	if not climbing:
		if on_floor and Input.is_action_just_pressed(current_input_actions.jump):
			# Handle Jump.
			jumped.emit()
			velocity.y = jump_speed
		elif not on_floor:
			# Add the gravity.
			velocity.y += gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

	if climbing:
		var direction := Input.get_axis(current_input_actions.move_up, current_input_actions.move_down)
		if direction:
			velocity.y = direction * speed
		else:
			velocity.y = move_toward(velocity.y, 0, speed)
		velocity.x = 0
	else:
		var direction := Input.get_axis(current_input_actions.move_left, current_input_actions.move_right)
		if direction:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

func _on_jumped() -> void:
	jump_note_player = jump_note_player_scene.instantiate()
	jump_note_player.tone = current_tone
	add_child(jump_note_player)
	jump_note_player.start()


func _on_tile_detector_area_tone_changed(tone) -> void:
	current_tone = tone
