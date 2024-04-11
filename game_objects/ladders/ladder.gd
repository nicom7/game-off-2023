@tool
class_name Ladder
extends Node2D

@export_range(2, 99) var size: int = 2:
	set(value):
		size = value
		_update_size()

@export var tone_label_fade_duration: float = 0.25

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

var show_keys: = false:
	set(value):
		if show_keys != value:
			show_keys = value
			_update_show_keys()


func _update_upper_tone() -> void:
	if not is_node_ready() or Engine.is_editor_hint():
		return

	climb_up_notes = Globals.get_bitfield_from_notes([_upper_tone])
	$BottomPivot/LowerInteraction.interact_notes = climb_up_notes

	%UpperToneLabel.tone = _upper_tone


func _update_lower_tone() -> void:
	if not is_node_ready() or Engine.is_editor_hint():
		return

	climb_down_notes = Globals.get_bitfield_from_notes([_lower_tone])
	$TopPivot/UpperInteraction.interact_notes = climb_down_notes

	%LowerToneLabel.tone = _lower_tone


func _update_size():
	if not is_node_ready():
		return

	var sprite_size: Vector2 = %Ladder.texture.get_size()
	sprite_size.y *= size
	%Ladder.region_rect = Rect2(Vector2.ZERO, sprite_size)
	%Area2D.scale.y = size
	%ToneLabelArea2D.scale.y = size
	%BottomPivot.position.y = sprite_size.y


func _update_color():
	if is_node_ready():
		%Ladder.modulate = color


func _update_show_keys():
	if not is_node_ready():
		return

	%LowerToneLabel.show_keys = show_keys
	%UpperToneLabel.show_keys = show_keys


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_size()
	_update_upper_tone()
	_update_lower_tone()


func _process(_delta: float) -> void:
	if not is_node_ready() or Engine.is_editor_hint():
		return

	var top_pivot: = %TopPivot/LabelPivot as Node2D
	var bottom_pivot: = %BottomPivot/LabelPivot as Node2D

	# Do not draw labels too far
	var min_top: = %TopPivot/UpperLabelMinPos as Node2D
	var min_bottom: = %BottomPivot/LowerLabelMinPos as Node2D
	var max_top: = %BottomPivot/UpperLabelMaxPos as Node2D
	var max_bottom: = %TopPivot/LowerLabelMaxPos as Node2D

	var r: = get_viewport_rect()

	top_pivot.position = min_top.position
	var tp_screen_pos = top_pivot.get_screen_transform() * top_pivot.position
	if tp_screen_pos.y < r.position.y:
		tp_screen_pos.y = r.position.y
	top_pivot.position = top_pivot.get_screen_transform().affine_inverse() * tp_screen_pos
	if top_pivot.global_position.y > max_top.global_position.y:
		top_pivot.global_position.y = max_top.global_position.y

	bottom_pivot.position = min_bottom.position
	var bp_screen_pos = bottom_pivot.get_screen_transform() * bottom_pivot.position
	if bp_screen_pos.y > r.end.y:
		bp_screen_pos.y = r.end.y
	bottom_pivot.position = bottom_pivot.get_screen_transform().affine_inverse() * bp_screen_pos
	if bottom_pivot.global_position.y < max_bottom.global_position.y:
		bottom_pivot.global_position.y = max_bottom.global_position.y


func _enter_climb(player, interactive_object) -> void:
	if player and not player.climbing:
		player.global_position = interactive_object.global_position
		player.enter_climb(self)


func _exit_climb(body: Node2D) -> void:
	var player = body as Character
	if player and player.climbing:
		player.exit_climb()


func _fade_tone_labels(_color: Color, _duration: float) -> void:
	create_tween().tween_property(%LowerToneLabel, "modulate", _color, _duration)
	create_tween().tween_property(%UpperToneLabel, "modulate", _color, _duration)



func _on_lower_interaction_interacted(player, interactive_object) -> void:
	_enter_climb(player, interactive_object)


func _on_upper_interaction_interacted(player, interactive_object) -> void:
	_enter_climb(player, interactive_object)


func _on_area_2d_body_exited(body: Node2D) -> void:
	_exit_climb(body)


func _on_bottom_tile_detector_area_tone_changed(tone) -> void:
	_lower_tone = tone


func _on_top_tile_detector_area_tone_changed(tone) -> void:
	_upper_tone = tone


func _on_tone_label_area_2d_body_entered(body: Node2D) -> void:
	var player = body as Character
	if player:
		_fade_tone_labels(Color.WHITE, tone_label_fade_duration)


func _on_tone_label_area_2d_body_exited(body: Node2D) -> void:
	var player = body as Character
	if player:
		_fade_tone_labels(Color(1, 1, 1, 0), tone_label_fade_duration)
