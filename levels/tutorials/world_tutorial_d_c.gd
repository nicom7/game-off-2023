extends World

func _start() -> void:
	%BlockSequence.start()


func _on_block_sequence_sequence_played(demo_sequence: bool) -> void:
	super._on_block_sequence_sequence_played(demo_sequence)

	if !demo_sequence:
		$BlockSequenceTutorial.show()
