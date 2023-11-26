extends World

func _start() -> void:
	$AccidentalsTutorial.show()
	$AccidentalsTutorial.next_step()
	%BlockSequence.start()

func _on_block_sequence_sequence_played(demo_sequence: bool) -> void:
	super._on_block_sequence_sequence_played(demo_sequence)
	if !demo_sequence and %BlockSequence.get_current_sequence_end() >= 1:
		$AccidentalsTutorial.hide()
