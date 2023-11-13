@tool
class_name PlatformSet
extends Node2D

@export var tone: Globals.Tone = Globals.Tone.A:
	set(value):
		if tone != value:
			tone = value
			_update_tone()

func get_bounding_rect() -> Rect2:
	return $BoundingRect.global_transform * $BoundingRect.shape.get_rect()

func get_switch_blocks() -> Array[SwitchBlock]:
	var switch_blocks: Array[SwitchBlock] = []
	for c in get_children():
		if c is SwitchBlock:
			switch_blocks.append(c as SwitchBlock)

	return switch_blocks

func get_ladders() -> Array[Ladder]:
	var ladders: Array[Ladder] = []
	for c in get_children():
		if c is Ladder:
			ladders.append(c as Ladder)

	return ladders

func _update_tone() -> void:
	if not is_node_ready():
		return

	for sb in get_switch_blocks():
		sb.tone = tone

	var tilemap: TileMap = $TileMap
	# Skip layer 0 (Platform layer)
	for layer in range(1, tilemap.get_layers_count()):
		tilemap.set_layer_enabled(layer, false)
	tilemap.set_layer_enabled(tone + 1, true)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_tone()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
