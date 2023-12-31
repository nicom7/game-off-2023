@tool
extends CanvasLayer

@export var background: Background:
	get:
		return background
	set(value):
		background = value
		_update_sprites()

@export var background_infos: Array[BackgroundInfo] = []

enum Background
{
	OCEAN_1,
	OCEAN_2,
	OCEAN_3,
	OCEAN_4,
	OCEAN_5,
	OCEAN_6,
	OCEAN_7,
	OCEAN_8,
}

const DEFAULT_BACKGROUND_INFO: BackgroundInfo = preload("res://parallaxes/default_background_info.tres")

func _ready() -> void:
	_update_sprites()

func _update_sprites() -> void:
	if not is_node_ready():
		return

	var background_info: BackgroundInfo = DEFAULT_BACKGROUND_INFO.duplicate()

	var background_name = (Background.keys()[background] as String).to_lower()

	# Use specified background info resource
	var custom_background_info = background_infos[background]
	for i in custom_background_info.parallax_scales.size():
		background_info.parallax_scales[i] = custom_background_info.parallax_scales[i]

	var layers = %ParallaxBackground.get_children()
	for i in layers.size():
		var plx_layer = layers[i] as ParallaxLayer
		plx_layer.motion_scale = background_info.parallax_scales[i]
		var sprites: Array[Node] = plx_layer.get_children()
		for s in sprites:
			var sprite = s as AnimatedSprite2D
			sprite.animation = background_name
			sprite.frame = i
