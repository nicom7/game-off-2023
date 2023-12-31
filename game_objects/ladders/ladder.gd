@tool
class_name Ladder
extends Node2D

@export_range(2, 99) var size: int = 2:
	set(value):
		size = value
		_update_size()

var color: Color = Color.WHITE:
	set(value):
		color = value
		_update_color()

## Notes bitfield for the climb up action
var climb_up_notes: int
## Notes bitfield for the climb down action
var climb_down_notes: int

var _upper_tone: Globals.Tone = Globals.Tone.B:
	set(value):
		if _upper_tone != value:
			_upper_tone = value
			_update_upper_tone()

var _lower_tone: Globals.Tone = Globals.Tone.A:
	set(value):
		if _lower_tone != value:
			_lower_tone = value
			_update_lower_tone()

func _update_upper_tone() -> void:
	if not is_node_ready() or Engine.is_editor_hint():
		return

	climb_up_notes = Globals.get_bitfield_from_notes([_upper_tone])
	$BottomPivot/LowerInteraction.interact_notes = climb_up_notes

func _update_lower_tone() -> void:
	if not is_node_ready() or Engine.is_editor_hint():
		return

	climb_down_notes = Globals.get_bitfield_from_notes([_lower_tone])
	$TopPivot/UpperInteraction.interact_notes = climb_down_notes

func _update_size():
	if not is_node_ready():
		return

	var sprite_size: Vector2 = %Ladder.texture.get_size()
	sprite_size.y *= size
	%Ladder.region_rect = Rect2(Vector2.ZERO, sprite_size)
	%Area2D.scale.y = size
	%BottomPivot.position.y = sprite_size.y

func _update_color():
	if is_node_ready():
		%Ladder.modulate = color


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_size()
	_update_upper_tone()
	_update_lower_tone()


func _on_lower_interaction_interacted(player, interactive_object) -> void:
	if player and not player.climbing:
		player.global_position = interactive_object.global_position
		player.enter_climb(self)


func _on_upper_interaction_interacted(player, interactive_object) -> void:
	if player and not player.climbing:
		player.global_position = interactive_object.global_position
		player.enter_climb(self)


func _on_area_2d_body_exited(body: Node2D) -> void:
	var player = body as Character
	if player and player.climbing:
		player.exit_climb()


func _on_bottom_tile_detector_area_tone_changed(tone) -> void:
	_lower_tone = tone


func _on_top_tile_detector_area_tone_changed(tone) -> void:
	_upper_tone = tone
