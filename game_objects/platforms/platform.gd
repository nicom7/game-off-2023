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
		show_keys = value
		if is_node_ready():
			%LeftLabel.visible = not show_keys
			%RightLabel.visible = not show_keys
			%LeftKeyLabel.visible = show_keys
			%RightKeyLabel.visible = show_keys

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

	var label = Globals.get_label_from_tone(tone)
	%LeftLabel.text = label
	%LeftLabel.self_modulate = tone_color.lightened(Globals.LIGHT_COLOR_AMOUNT)
	%RightLabel.text = label
	%RightLabel.self_modulate = tone_color.lightened(Globals.LIGHT_COLOR_AMOUNT)

	var key_label = "{%s}" % Globals.get_action_from_tone(tone)
	if not Engine.is_editor_hint():
		# Do not run the following in editor because it will crash
		key_label = Globals.format_input_actions(key_label)
	%LeftKeyLabel.text = key_label
	%LeftKeyLabel.self_modulate = tone_color.lightened(Globals.LIGHT_COLOR_AMOUNT)
	%RightKeyLabel.text = key_label
	%RightKeyLabel.self_modulate = tone_color.lightened(Globals.LIGHT_COLOR_AMOUNT)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_size()
	_update_tone()
