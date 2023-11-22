extends Camera2D

@export_node_path("Node2D") var target_node_path: NodePath:
	set(value):
		target_node_path = value
		if is_node_ready():
			set_target_node(get_node(value))

@export var move_speed: float = 1
@export var position_easing: Curve = Curve.new()

@export var target_zoom: Vector2 = Vector2.ONE:
	get:
		return _target_zoom
	set(value):
		set_target_zoom(value)

@export var zoom_speed: float = 1
@export var zoom_easing: Curve = Curve.new()

var _zoom_cursor: float = 0
@onready var _previous_zoom: Vector2 = zoom
@onready var _target_zoom: Vector2 = zoom

var _pos_cursor: float = 0
var _previous_pos: Vector2 = Vector2.ZERO
@onready var _target_node: Node2D = get_node(target_node_path)

## Set the new node target to value. Set instant to true to bypass node easing and change target instantly.
func set_target_node(value: Node2D, instant: bool = false) -> void:
	if _target_node != value:
		_previous_pos = global_position
		_target_node = value
		if instant:
			_pos_cursor = 1
		else:
			_pos_cursor = 1 - _pos_cursor

## Set the new zoom target to value. Set instant to true to bypass zoom easing and change zoom instantly.
func set_target_zoom(value: Vector2, instant: bool = false) -> void:
	if _target_zoom != value:
		_previous_zoom = _target_zoom
		_target_zoom = value
		if instant:
			_zoom_cursor = 1
		else:
			_zoom_cursor = 1 - _zoom_cursor

	if instant:
		zoom = value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_target_node(_target_node, true)
	set_target_zoom(_target_zoom, true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_update_position(delta)
	_update_zoom(delta)

func _update_position(delta: float) -> void:
	if _target_node == null:
		return

	if _previous_pos == Vector2.ZERO:
		_previous_pos = _target_node.global_position

	var cursor = position_easing.sample_baked(_pos_cursor)
	global_position.x = remap(cursor, 0, 1, _previous_pos.x, _target_node.global_position.x)
	global_position.y = remap(cursor, 0, 1, _previous_pos.y, _target_node.global_position.y)

	_pos_cursor = clampf(_pos_cursor + delta * move_speed, 0, 1)

func _update_zoom(delta: float) -> void:
	var cursor = zoom_easing.sample_baked(_zoom_cursor)
	zoom.x = remap(cursor, 0, 1, _previous_zoom.x, _target_zoom.x)
	zoom.y = remap(cursor, 0, 1, _previous_zoom.y, _target_zoom.y)

	_zoom_cursor = clampf(_zoom_cursor + delta * zoom_speed, 0, 1)
