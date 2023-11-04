class_name Ladder
extends StaticBody2D

@export var climb_up_action: String
@export var climb_down_action: String

@export_range(2, 10) var size: int = 3:
	set(value):
		size = value
		_update_size()
		
func _update_size():
	if !is_node_ready():
		return
		
	var sprite_size: Vector2 = %Ladder.texture.get_size()
	sprite_size.y *= size
	%Ladder.region_rect = Rect2(Vector2.ZERO, sprite_size)
	var sprite_size_y = %RightSprite.region_rect.size.y / %RightSprite.hframes
	%RightSprite.position.x = (size - 1) * sprite_size_y
	
	$LowerInteraction.position.x = size * sprite_size_y / 2
	$InteractiveObject/InteractZone.scale.x = size
	
	$CollisionShapeClosed.position.x = size * sprite_size_y / 2
	$CollisionShapeClosed.scale.x = size
	
	$CollisionShapeOpened2.position.x = size * sprite_size_y - $CollisionShapeOpened2.shape.get_rect().size.x / 2

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
