@tool
class_name Platform
extends TileMap

@export var size: Vector2i = Vector2i.ONE * 2:
	set(value):
		size = value
		_update_size()

@export var tone: Globals.Tone = Globals.Tone.A:
	set(value):
		if tone != value:
			tone = value
			_update_tone()

@export var octave: int = 0

## Display keyboard keys instead of tones
@export var show_keys: = false:
	set(value):
		if show_keys != value:
			show_keys = value
			_update_show_keys()


func _update_size():
	if not is_node_ready():
		return

	var tile_size = tile_set.tile_size
	var platform_size: Vector2 = tile_size * size
	%BottomPivot.position.y = platform_size.y
	%RightPivot.position.x = platform_size.x

	var cells: Array[Vector2i] = []
	for i in size.x:
		for j in size.y:
			cells.append(Vector2i(i, j))

	# Clear all previous cells
	clear()

	for cell in cells:
		set_cell(0, cell, 0, Vector2i.ZERO)

	set_cells_terrain_connect(0, cells, 0, 0)


func _update_tone() -> void:
	if not is_node_ready():
		return

	var tone_color = Config.tone_colors[tone]
	self.set_layer_modulate(0, tone_color)

	%LeftToneLabel.tone = tone
	%RightToneLabel.tone = tone


func _update_show_keys() -> void:
	if not is_node_ready():
		return

	%LeftToneLabel.show_keys = show_keys
	%RightToneLabel.show_keys = show_keys


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_size()
	_update_tone()
	_update_show_keys()
