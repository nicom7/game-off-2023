extends Tutorial

enum Step
{
	C,
	C_C,
	C_C_G,
	C_C_G_G,
}

func _init_texts() -> void:
	_texts.append_array([
		"Use your keyboard like a piano:\nThe {C_note} key is the note C, {D_note} key is note D, {E_note} key is note E and so on.\n\nPress {C_note} to jump and hit the C block",
		"Hit the C block twice to replay the sequence",
		"Replay the C, C, G sequence",
		"Replay the sequence",
	])

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
