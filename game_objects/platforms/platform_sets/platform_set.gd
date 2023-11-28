@tool
class_name PlatformSet
extends Node2D

@export var tone: Globals.Tone = Globals.Tone.A:
	set(value):
		if tone != value:
			tone = value
			_update_tone()

@export var octave: int = 0:
	set(value):
		if octave != value:
			octave = value
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

func get_platforms() -> Array[Platform]:
	var platforms: Array[Platform] = []
	for c in get_children():
		if c is Platform:
			platforms.append(c as Platform)

	return platforms

func _update_tone() -> void:
	if not is_node_ready():
		return

	for sb in get_switch_blocks():
		sb.tone = tone
		sb.octave = octave

	for p in get_platforms():
		p.tone = tone
		p.octave = octave

	for l in get_ladders():
		l.color = Config.tone_colors[tone].lightened(Globals.LIGHT_COLOR_AMOUNT)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_tone()
