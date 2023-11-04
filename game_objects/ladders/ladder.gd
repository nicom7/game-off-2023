class_name Ladder
extends StaticBody2D

@export var climb_up_action: String
@export var climb_down_action: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$LowerInteraction.interact_action = climb_up_action
	$UpperInteraction.interact_action = climb_down_action

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
