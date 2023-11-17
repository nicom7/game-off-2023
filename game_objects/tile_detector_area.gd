extends Area2D

signal tone_changed(tone: Globals.Tone)

func _on_body_entered(body: Node2D) -> void:
	var platform: Platform = body as Platform
	if platform:
		tone_changed.emit(platform.tone)
	else:
		var switch_block: SwitchBlock = body as SwitchBlock
		if switch_block:
			tone_changed.emit(switch_block.tone)
