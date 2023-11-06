extends Camera2D

@export var target_node: Node2D
@export var target_zoom: Vector2 = Vector2.ONE:
	set(value):
		set_zoom_target(value, true)
			
@export var zoom_speed: float = 1
@export var zoom_easing: Curve = Curve.new()

var _zoom_cursor: float = 0
var _previous_zoom: Vector2 = Vector2.ONE
var _target_zoom: Vector2 = Vector2.ONE

## Set the new zoom target to value. Set instant to true to bypass zoom easing and change zoom instantly.
func set_zoom_target(value: Vector2, instant: bool = false) -> void:
		if _target_zoom != value:
			_previous_zoom = _target_zoom
			_target_zoom = value
			if instant:
				_previous_zoom = _target_zoom
			_zoom_cursor = 0
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	zoom = target_zoom


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = target_node.global_position
	
	var cursor = zoom_easing.sample_baked(_zoom_cursor)
	zoom.x = remap(cursor, 0, 1, _previous_zoom.x, _target_zoom.x)
	zoom.y = remap(cursor, 0, 1, _previous_zoom.y, _target_zoom.y)
	
	_zoom_cursor = clampf(_zoom_cursor + delta * zoom_speed, 0, 1)
	
