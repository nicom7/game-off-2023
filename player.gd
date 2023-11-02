extends CharacterBody2D

@export var speed: float = 300.0
@export var jump_speed: float = -400.0

@export var current_floor_map: TileMap

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

var _floor_map_layer_info: Dictionary = {}

class InputActions:
	var move_left: String
	var move_right: String
	var jump: String

var _input_actions: Dictionary = {}
const _tones: Array[String] = ["A", "B", "C"]
var current_tone: String = "A"

func _ready() -> void:
	_setup_floor_map_layer_info()
	_setup_input_actions()
	
func _setup_floor_map_layer_info():
	_floor_map_layer_info.clear()
	if current_floor_map:
		for l in current_floor_map.get_layers_count():
			var name = current_floor_map.get_layer_name(l)
			_floor_map_layer_info[name] = l
	
func _setup_input_actions():
	_input_actions.clear()
	for tone in _tones:
		var actions: InputActions = InputActions.new()
		actions.move_left = tone + "_left"
		actions.move_right = tone + "_right"
		actions.jump = tone + "_jump"
		
		_input_actions[tone] = actions
	
func _physics_process(delta: float) -> void:
	_update_tone(delta)
	_update_movement(delta)
	
func _update_tone(delta: float) -> void:
	var custom_data = _get_floor_custom_data($TileDetector.global_position, "Tones", "Tone")
	if custom_data != null:
		current_tone = custom_data
	print(current_tone)
	
func _update_movement(delta: float) -> void:
	var current_input_actions: InputActions = _input_actions[current_tone]
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed(current_input_actions.jump) and is_on_floor():
		velocity.y = jump_speed

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis(current_input_actions.move_left, current_input_actions.move_right)
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

func _get_floor_custom_data(pos: Vector2, tile_map_layer: String, data_layer: String):
	var tile_data = _get_floor_tile_data(pos, tile_map_layer)
	if tile_data:
		var custom_data = tile_data.get_custom_data(data_layer)
		if custom_data:
			return custom_data
			
	return null
	
func _get_floor_tile_data(pos: Vector2, layer: String):
	var tile_data: TileData
	if current_floor_map:
		var layer_idx = _floor_map_layer_info[layer] if _floor_map_layer_info.has(layer) else 0
		var floor_pos = current_floor_map.local_to_map(current_floor_map.to_local(pos))
		tile_data = current_floor_map.get_cell_tile_data(layer_idx, floor_pos)
		
	return tile_data
