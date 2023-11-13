extends Area2D

signal tone_changed(tone: Globals.Tone)

func _on_body_entered(body: Node2D) -> void:
	var floor_map: TileMap = body as TileMap
	if floor_map:
		# Skip layer 0 (Platform layer)
		for l in range(1, floor_map.get_layers_count()):
			if floor_map.is_layer_enabled(l):
				# Enabled layer - 1 is the current tone
				var tone = (l - 1) as Globals.Tone
				tone_changed.emit(tone)
				break
