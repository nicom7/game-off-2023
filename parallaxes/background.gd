@tool
extends CanvasLayer

@export var background: Background:
	get:
		return background
	set(value):
		background = value
		_update_sprites()

enum Background
{
	OCEAN_1,
	OCEAN_2,
	OCEAN_3,
	OCEAN_4,
}

func _ready() -> void:
	_update_sprites()

func _update_sprites() -> void:
	if not is_node_ready():
		return

	var layers = %ParallaxBackground.get_children()
	for i in layers.size():
		var layer = layers[i]
		var sprites: Array[Node] = layer.get_children()
		for s in sprites:
			var sprite = (s as AnimatedSprite2D)
			sprite.animation = (Background.keys()[background] as String).to_lower()
			sprite.frame = i
