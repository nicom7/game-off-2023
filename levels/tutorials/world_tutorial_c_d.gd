extends World

func _start() -> void:
	_set_player_camera()
	$MovementTutorial.show()
	$MovementTutorial.next_step()


func _on_block_sequence_sequence_played(demo_sequence: bool) -> void:
	super._on_block_sequence_sequence_played(demo_sequence)

	if !demo_sequence:
		$JumpTutorial.hide()
		$BlockSequenceTutorial.show()


func _on_movement_tutorial_finished() -> void:
	$MovementTutorial.hide()
	$JumpTutorial.show()
	$JumpTutorial.next_step()


func _on_jump_tutorial_finished() -> void:
	_set_overview_camera()
	%BlockSequence.start()
