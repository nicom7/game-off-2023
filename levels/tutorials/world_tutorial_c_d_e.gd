extends World

func _start() -> void:
	_set_player_camera()
	$ClimbTutorial.show()
	$ClimbTutorial.next_step()


func _on_block_sequence_sequence_played(demo_sequence: bool) -> void:
	super._on_block_sequence_sequence_played(demo_sequence)

	if !demo_sequence:
		$ClimbTutorial.hide()
		$BlockSequenceTutorial.show()


func _on_climb_tutorial_finished() -> void:
	_set_overview_camera()
	%BlockSequence.start()
