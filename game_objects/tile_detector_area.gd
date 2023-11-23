extends Node2D

signal tone_changed(tone: Globals.Tone)
signal octave_changed(octave: int)


func _update_overlapping_body(body: Node2D) -> void:
	var platform: Platform = body as Platform
	if platform:
		tone_changed.emit(platform.tone)
		octave_changed.emit(platform.octave)
	else:
		var switch_block: SwitchBlock = body as SwitchBlock
		if switch_block:
			tone_changed.emit(switch_block.tone)
			octave_changed.emit(switch_block.octave)


func _on_center_area_2d_body_entered(body: Node2D) -> void:
	_update_overlapping_body(body)


func _on_base_area_2d_body_entered(body: Node2D) -> void:
	var overlapping_bodies = $BaseArea2D.get_overlapping_bodies()
	if overlapping_bodies.size() == 1:
		_update_overlapping_body(overlapping_bodies[0])
