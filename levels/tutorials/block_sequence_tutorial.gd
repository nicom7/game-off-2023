class_name BlockSequenceTutorial
extends Tutorial

func _on_block_sequence_sequence_finished(valid) -> void:
	if valid:
		$Step/Label.text = "Great!"
	else:
		$Step/Label.text = "Try again!"
		set_step(-1)


func _on_block_sequence_sequence_played(demo_sequence) -> void:
	if !demo_sequence:
		next_step()


func _on_block_sequence_finished() -> void:
	next_step()
