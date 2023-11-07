@tool
class_name Ladder
extends Node2D

@export var upper_tone: Globals.Tone = Globals.Tone.B:
	set(value):
		if upper_tone != value:
			upper_tone = value
			_update_upper_tone()
			
@export var lower_tone: Globals.Tone = Globals.Tone.A:
	set(value):
		if lower_tone != value:
			lower_tone = value
			_update_lower_tone()
			
@export_range(2, 10) var size: int = 2:
	set(value):
		size = value
		_update_size()
		
var climb_up_action: String
var climb_down_action: String

func _update_upper_tone() -> void:
	climb_up_action = Globals.Tone.keys()[upper_tone] + "_note"
	
func _update_lower_tone() -> void:
	climb_down_action = Globals.Tone.keys()[lower_tone] + "_note"
	
func _update_size():
	if !is_node_ready():
		return
		
	var sprite_size: Vector2 = %Ladder.texture.get_size()
	sprite_size.y *= size
	%Ladder.region_rect = Rect2(Vector2.ZERO, sprite_size)
	%Area2D.scale.y = size
	%BottomPivot.position.y = sprite_size.y
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_size()
	_update_upper_tone()
	_update_lower_tone()
	
	$BottomPivot/LowerInteraction.interact_action = climb_up_action
	$TopPivot/UpperInteraction.interact_action = climb_down_action

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


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
