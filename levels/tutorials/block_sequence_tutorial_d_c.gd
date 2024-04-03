extends BlockSequenceTutorial

func _init_texts() -> void:
	const replay_str: = "Replay the sequence"
	_texts.append_array([
		"Press {D_note} to jump and hit the D block",
		replay_str,
		replay_str,
		replay_str,
	])
