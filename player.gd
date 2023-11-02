extends CharacterBody2D

@export var current_floor_map: TileMap

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

var floor_map_layer_info: Dictionary = {}

func _ready() -> void:
	_setup_floor_map_layer_info()
	
func _setup_floor_map_layer_info():
	floor_map_layer_info.clear()
	if current_floor_map:
		for l in current_floor_map.get_layers_count():
			var name = current_floor_map.get_layer_name(l)
			floor_map_layer_info[name] = l
	
func _physics_process(delta: float) -> void:
	_update_controls(delta)
	_update_movement(delta)
	
func _update_controls(delta: float) -> void:
	var custom_data = _get_floor_custom_data($TileDetector.global_position, "Tones", "Tone")
	var pitch: String = custom_data if custom_data != null else "-"
	print(pitch)
	
func _update_movement(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

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
		var layer_idx = floor_map_layer_info[layer] if floor_map_layer_info.has(layer) else 0
		var floor_pos = current_floor_map.local_to_map(current_floor_map.to_local(pos))
		tile_data = current_floor_map.get_cell_tile_data(layer_idx, floor_pos)
		
	return tile_data
